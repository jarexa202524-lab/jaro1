import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);

    if (req.method === 'GET') {
        try {
            const users = await sql`SELECT username, email, role FROM users ORDER BY created_at DESC`;
            return res.status(200).json(users);
        } catch (error) {
            return res.status(500).json({ error: 'შეცდომა მონაცემების წაკითხვისას' });
        }
    }

    if (req.method === 'DELETE') {
        const { email } = req.body;
        try {
            await sql`DELETE FROM users WHERE email = ${email}`;
            return res.status(200).json({ message: 'მომხმარებელი წაიშალა' });
        } catch (error) {
            return res.status(500).json({ error: 'შეცდომა წაშლისას' });
        }
    }

    return res.status(405).json({ error: 'Method not allowed' });
}
