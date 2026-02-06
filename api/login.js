import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

    const { identifier, password } = req.body;
    const sql = neon(process.env.DATABASE_URL);

    try {
        const users = await sql`SELECT * FROM users WHERE (username = ${identifier} OR email = ${identifier}) AND password = ${password}`;

        if (users.length > 0) {
            const user = users[0];
            // Force admin role for the specific user
            if (user.email === 'jaro@gmail.com') {
                user.role = 'admin';
            }
            return res.status(200).json({
                message: 'წარმატებით გაიარეთ ავტორიზაცია',
                user: { username: user.username, email: user.email, role: user.role }
            });
        } else {
            return res.status(401).json({ error: 'არასწორი მონაცემები' });
        }
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'სერვერის შეცდომა' });
    }
}
