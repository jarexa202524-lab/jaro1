import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);

    if (req.method === 'GET') {
        const settings = await sql`SELECT * FROM site_settings`;
        const mapped = {};
        settings.forEach(s => mapped[s.key] = s.value);
        return res.status(200).json(mapped);
    }

    if (req.method === 'POST') {
        // ADMIN ONLY
        const authHeader = req.headers['authorization'];
        if (!authHeader) return res.status(401).json({ error: 'Unauthorized' });

        const { key, value } = req.body;
        try {
            await sql`INSERT INTO site_settings (key, value, updated_at) 
                      VALUES (${key}, ${value}, CURRENT_TIMESTAMP)
                      ON CONFLICT (key) DO UPDATE SET value = ${value}, updated_at = CURRENT_TIMESTAMP`;
            return res.status(200).json({ message: 'Settings Updated' });
        } catch (e) {
            return res.status(500).json({ error: e.message });
        }
    }

    return res.status(405).json({ error: 'Method not allowed' });
}
