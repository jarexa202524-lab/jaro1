import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);

    // SECURITY CHECK: Verify Admin Token (only Admin Can Run Migrations)
    const authHeader = req.headers['authorization'];
    if (!authHeader) return res.status(401).json({ error: 'წვდომა უარყოფილია!' });

    const token = authHeader.replace('Bearer ', '');
    const validUsers = await sql`SELECT email, role FROM users WHERE session_token = ${token}`;

    if (validUsers.length === 0 || validUsers[0].email.toLowerCase() !== 'jaro@gmail.com' || validUsers[0].role !== 'admin') {
        return res.status(403).json({ error: 'მხოლოდ მთავარ ადმინს შეუძლია ბაზის მოდერნიზაცია' });
    }

    try {
        // 1. Users Expansion
        await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS xp INT DEFAULT 0`;
        await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS badges JSONB DEFAULT '[]'`;
        await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS level INT DEFAULT 1`;
        await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS is_banned BOOLEAN DEFAULT FALSE`;

        // 2. Security Bans
        await sql`CREATE TABLE IF NOT EXISTS site_bans (
            id SERIAL PRIMARY KEY,
            target TEXT UNIQUE NOT NULL, -- IP or Email
            reason TEXT,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        )`;

        // 3. Global Settings (Architect & Architect)
        await sql`CREATE TABLE IF NOT EXISTS site_settings (
            key TEXT PRIMARY KEY,
            value JSONB,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        )`;

        // 4. Chronos Tasks
        await sql`CREATE TABLE IF NOT EXISTS site_tasks (
            id SERIAL PRIMARY KEY,
            type TEXT NOT NULL,
            payload JSONB,
            execute_at TIMESTAMP WITH TIME ZONE,
            status TEXT DEFAULT 'pending'
        )`;

        return res.status(200).json({ message: 'მონაცემთა ბაზა წარმატებით განახლდა ინოვაციებისთვის! 🚀' });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'მიგრაციის შეცდომა: ' + error.message });
    }
}
