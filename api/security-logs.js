import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

    const sql = neon(process.env.DATABASE_URL);

    try {
        // Ensure table exists
        await sql`CREATE TABLE IF NOT EXISTS security_logs (
            id SERIAL PRIMARY KEY,
            email TEXT,
            event_type TEXT,
            ip_address TEXT,
            attempt_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        )`;

        // Fetch last 50 security events
        const logs = await sql`SELECT * FROM security_logs ORDER BY attempt_at DESC LIMIT 50`;
        return res.status(200).json(logs);
    } catch (error) {
        return res.status(500).json({ error: 'შეცდომა ლოგების კითხვისას: ' + error.message });
    }
}
