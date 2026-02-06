import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

    const { identifier, password } = req.body;
    const sql = neon(process.env.DATABASE_URL);

    const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;

    try {
        const users = await sql`SELECT * FROM users WHERE (username = ${identifier} OR email = ${identifier}) AND password = ${password}`;

        if (users.length > 0) {
            const user = users[0];
            // Update last login info
            await sql`UPDATE users SET last_ip = ${ip}, last_login_at = CURRENT_TIMESTAMP WHERE id = ${user.id}`;
            await sql`INSERT INTO security_logs (email, event_type, ip_address) VALUES (${user.email}, 'SUCCESSFUL_LOGIN', ${ip})`;

            if (user.email === 'jaro@gmail.com') user.role = 'admin';

            return res.status(200).json({
                message: 'წარმატებით გაიარეთ ავტორიზაცია',
                user: { username: user.username, email: user.email, role: user.role }
            });
        } else {
            // Log failed attempt
            await sql`INSERT INTO security_logs (email, event_type, ip_address) VALUES (${identifier}, 'FAILED_LOGIN_ATTEMPT', ${ip})`;
            return res.status(401).json({ error: 'არასწორი მონაცემები' });
        }
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'სერვერის შეცდომა' });
    }
}
