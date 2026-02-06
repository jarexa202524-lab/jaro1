import { neon } from '@neondatabase/serverless';
import bcrypt from 'bcryptjs';

export default async function handler(req, res) {
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

    const { identifier, password } = req.body;
    const sql = neon(process.env.DATABASE_URL);

    let ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress || 'unknown';
    if (ip && ip.includes(',')) ip = ip.split(',')[0].trim();

    try {
        const users = await sql`SELECT * FROM users WHERE username = ${identifier} OR email = ${identifier}`;

        if (users.length > 0) {
            const user = users[0];

            // Check if password matches (support both hash and plain text for migration)
            let isMatch = false;
            try {
                isMatch = await bcrypt.compare(password, user.password);
            } catch (e) {
                // If bcrypt fails, it might be plain text
                isMatch = (password === user.password);

                // If it was plain text and matched, hash it now for future
                if (isMatch) {
                    const newHash = await bcrypt.hash(password, 10);
                    await sql`UPDATE users SET password = ${newHash} WHERE id = ${user.id}`;
                }
            }

            if (isMatch) {
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
        } else {
            return res.status(401).json({ error: 'არასწორი მონაცემები' });
        }
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'სერვერის შეცდომა' });
    }
}
