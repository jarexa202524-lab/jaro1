import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

    const sql = neon(process.env.DATABASE_URL);

    // SECURITY CHECK: Verify Admin Token
    const authHeader = req.headers['authorization'];
    if (!authHeader) return res.status(401).json({ error: 'წვდომა უარყოფილია!' });

    const token = authHeader.replace('Bearer ', '');
    const validUsers = await sql`SELECT email, role FROM users WHERE session_token = ${token}`;

    // STRICT LOCKDOWN: Only jaro@gmail.com can see logs
    if (validUsers.length === 0 || validUsers[0].email !== 'jaro@gmail.com') {
        return res.status(403).json({ error: 'წვდომა უარყოფილია!' });
    }

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
