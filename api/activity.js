import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);

    // Ensure activity table exists
    try {
        await sql`CREATE TABLE IF NOT EXISTS site_activity (
            id SERIAL PRIMARY KEY,
            user_name TEXT,
            action TEXT,
            details TEXT,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        )`;
    } catch (e) {
        console.error("Table creation error:", e);
    }

    if (req.method === 'GET') {
        try {
            // Get last 50 activities
            const activities = await sql`SELECT * FROM site_activity ORDER BY created_at DESC LIMIT 50`;
            return res.status(200).json(activities);
        } catch (error) {
            return res.status(500).json({ error: 'შეცდომა წაკითხვისას' });
        }
    }

    if (req.method === 'POST') {
        const { user_name, action, details } = req.body;

        try {
            await sql`INSERT INTO site_activity (user_name, action, details) 
                      VALUES (${user_name || 'სტუმარი'}, ${action}, ${details || ''})`;
            return res.status(200).json({ message: 'აქტივობა დაფიქსირდა' });
        } catch (error) {
            console.error(error);
            return res.status(500).json({ error: 'შეცდომა შენახვისას' });
        }
    }

    return res.status(405).json({ error: 'Method not allowed' });
}
