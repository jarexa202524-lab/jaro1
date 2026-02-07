import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

    const sql = neon(process.env.DATABASE_URL);

    // SECURITY CHECK: Verify Admin Token
    const authHeader = req.headers['authorization'];
    if (!authHeader) return res.status(401).json({ error: 'წვდომა უარყოფილია!' });

    const token = authHeader.replace('Bearer ', '');
    const validUsers = await sql`SELECT email, role FROM users WHERE session_token = ${token}`;

    // STRICT LOCKDOWN: Only jaro@gmail.com with admin role can see logs
    if (validUsers.length === 0 || validUsers[0].email !== 'jaro@gmail.com' || validUsers[0].role !== 'admin') {
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
        try { await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS browser TEXT`; } catch (e) { }
        try { await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS country TEXT`; } catch (e) { }
        try { await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS user_agent TEXT`; } catch (e) { }
        try { await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS full_details TEXT`; } catch (e) { }
        try { await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS city TEXT`; } catch (e) { }
        try { await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS region TEXT`; } catch (e) { }
        try { await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS device TEXT`; } catch (e) { }

        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 50;
        const offset = (page - 1) * limit;

        // Fetch paginated security events and total count
        const logs = await sql`SELECT * FROM security_logs ORDER BY attempt_at DESC LIMIT ${limit} OFFSET ${offset}`;
        const totalCount = await sql`SELECT count(*) FROM security_logs`;

        return res.status(200).json({
            logs,
            total: parseInt(totalCount[0].count),
            page,
            limit
        });
    } catch (error) {
        return res.status(500).json({ error: 'შეცდომა ლოგების კითხვისას: ' + error.message });
    }
}
