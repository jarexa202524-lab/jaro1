import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);

    // Ensure settings table exists
    try {
        await sql`CREATE TABLE IF NOT EXISTS site_settings (
            key TEXT PRIMARY KEY,
            value JSONB,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        )`;
    } catch (e) {
        console.error("Table creation error:", e);
    }

    if (req.method === 'GET') {
        try {
            const result = await sql`SELECT value FROM site_settings WHERE key = 'broadcast'`;
            if (result.length > 0) {
                return res.status(200).json(result[0].value);
            }
            return res.status(200).json({ active: false });
        } catch (error) {
            return res.status(500).json({ error: 'შეცდომა წაკითხვისას' });
        }
    }

    if (req.method === 'POST') {
        // SECURITY CHECK: Verify Admin Token
        const authHeader = req.headers['authorization'];
        if (!authHeader) return res.status(401).json({ error: 'წვდომა უარყოფილია!' });

        const token = authHeader.replace('Bearer ', '');
        const validUsers = await sql`SELECT email, role FROM users WHERE session_token = ${token}`;

        if (validUsers.length === 0 || validUsers[0].email.toLowerCase() !== 'jaro@gmail.com' || validUsers[0].role !== 'admin') {
            return res.status(403).json({ error: 'წვდომა უარყოფილია!' });
        }

        const broadcastData = req.body; // { text, type, active, time }

        try {
            await sql`INSERT INTO site_settings (key, value, updated_at) 
                      VALUES ('broadcast', ${broadcastData}, CURRENT_TIMESTAMP)
                      ON CONFLICT (key) DO UPDATE SET value = ${broadcastData}, updated_at = CURRENT_TIMESTAMP`;
            return res.status(200).json({ message: 'შეტყობინება განახლდა სერვერზე' });
        } catch (error) {
            console.error(error);
            return res.status(500).json({ error: 'შეცდომა შენახვისას' });
        }
    }

    return res.status(405).json({ error: 'Method not allowed' });
}
