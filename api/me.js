import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

    const { email } = req.body;
    if (!email) return res.status(400).json({ error: 'Email is required' });

    const sql = neon(process.env.DATABASE_URL);

    try {
        const users = await sql`SELECT username, email, role FROM users WHERE email = ${email}`;
        if (users.length > 0) {
            const user = users[0];
            // Force admin for jaro
            if (user.email === 'jaro@gmail.com') user.role = 'admin';
            return res.status(200).json(user);
        } else {
            return res.status(404).json({ error: 'User not found' });
        }
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
}
