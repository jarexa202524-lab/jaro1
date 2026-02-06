import { neon } from '@neondatabase/serverless';
import bcrypt from 'bcryptjs';

export default async function handler(req, res) {
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

    const { username, email, password } = req.body;
    const sql = neon(process.env.DATABASE_URL);

    let ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress || 'unknown';
    if (ip && ip.includes(',')) ip = ip.split(',')[0].trim();

    try {
        // RATE LIMITING: Max 3 registrations per IP per hour
        const recentRegistrations = await sql`SELECT count(*) FROM security_logs WHERE ip_address = ${ip} AND event_type = 'USER_REGISTERED' AND attempt_at > NOW() - INTERVAL '1 hour'`;
        if (parseInt(recentRegistrations[0].count) >= 3) {
            return res.status(429).json({ error: 'ძალიან ბევრი რეგისტრაცია! სცადეთ მოგვიანებით (1 საათში).' });
        }

        // Create/Update table if not exists
        await sql`CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      username TEXT UNIQUE NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      role TEXT DEFAULT 'user',
      last_ip TEXT,
      last_login_at TIMESTAMP WITH TIME ZONE,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    )`;

        // Ensure columns exist (for existing tables)
        try { await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS last_ip TEXT`; } catch (e) { }
        try { await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS last_login_at TIMESTAMP WITH TIME ZONE`; } catch (e) { }

        // Create Security Logs table
        await sql`CREATE TABLE IF NOT EXISTS security_logs (
            id SERIAL PRIMARY KEY,
            email TEXT,
            event_type TEXT,
            ip_address TEXT,
            attempt_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        )`;

        // Check if user exists
        const existing = await sql`SELECT * FROM users WHERE email = ${email} OR username = ${username}`;
        if (existing.length > 0) {
            return res.status(400).json({ error: 'მომხმარებელი ამ სახელით ან მაილით უკვე არსებობს!' });
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Insert user
        await sql`INSERT INTO users (username, email, password, last_ip, last_login_at) VALUES (${username}, ${email}, ${hashedPassword}, ${ip}, CURRENT_TIMESTAMP)`;

        // Log registration
        await sql`INSERT INTO security_logs (email, event_type, ip_address) VALUES (${email}, 'USER_REGISTERED', ${ip})`;

        return res.status(200).json({ message: 'წარმატებით დარეგისტრირდით!' });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'სერვერის შეცდომა' });
    }
}
