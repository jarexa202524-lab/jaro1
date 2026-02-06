import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

    const { email, token } = req.body;
    if (!email || !token) return res.status(400).json({ error: 'Email and Token are required' });

    const sql = neon(process.env.DATABASE_URL);

    try {
        const users = await sql`SELECT username, email, role, session_token FROM users WHERE email = ${email}`;
        if (users.length > 0) {
            const user = users[0];

            // SECURITY: Verify token
            if (user.session_token !== token) {
                return res.status(401).json({ error: 'Invalid session' });
            }

            // Force admin for jaro
            if (user.email === 'jaro@gmail.com') user.role = 'admin';

            // Remove token from response for safety
            delete user.session_token;
            return res.status(200).json(user);
        } else {
            return res.status(404).json({ error: 'User not found' });
        }
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
}
