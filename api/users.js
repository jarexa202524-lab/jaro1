import { neon } from '@neondatabase/serverless';
import bcrypt from 'bcryptjs';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);

    // SECURITY CHECK: Verify Admin Token
    const authHeader = req.headers['authorization'];
    if (!authHeader) return res.status(401).json({ error: 'წვდომა უარყოფილია! Token არ არსებობს.' });

    const token = authHeader.replace('Bearer ', '');
    const validUsers = await sql`SELECT email, role FROM users WHERE session_token = ${token}`;

    // ULTRA-SECURE CHECK: Absolute email verification + Role confirmation
    if (validUsers.length === 0 || validUsers[0].email !== 'jaro@gmail.com' || validUsers[0].role !== 'admin') {
        const attackerIp = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
        await sql`INSERT INTO security_logs (email, event_type, ip_address) VALUES (${validUsers[0]?.email || 'UNKNOWN'}, 'UNAUTHORIZED_ADMIN_ACCESS_ATTEMPT', ${attackerIp})`;
        return res.status(403).json({ error: 'წვდომა უარყოფილია! თქვენი აქტივობა დაფიქსირებულია.' });
    }

    if (req.method === 'GET') {
        try {
            // Ensure schema is up to date
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

            try { await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS last_ip TEXT`; } catch (e) { }
            try { await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS last_login_at TIMESTAMP WITH TIME ZONE`; } catch (e) { }
            try { await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS last_country TEXT`; } catch (e) { }
            try { await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS last_browser TEXT`; } catch (e) { }
            try { await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS last_device TEXT`; } catch (e) { }
            try { await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS last_city TEXT`; } catch (e) { }
            try { await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS last_region TEXT`; } catch (e) { }

            await sql`CREATE TABLE IF NOT EXISTS security_logs (
                id SERIAL PRIMARY KEY,
                email TEXT,
                event_type TEXT,
                ip_address TEXT,
                attempt_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
            )`;

            // EMERGENCY CLEANUP: Force 'jaro@gmail.com' to admin and demote EVERYONE else
            await sql`UPDATE users SET role = 'admin' WHERE email = 'jaro@gmail.com'`;
            await sql`UPDATE users SET role = 'user' WHERE email != 'jaro@gmail.com'`;

            // SELECT query EXCLUDES password for maximum security
            const users = await sql`SELECT id, username, email, role, last_ip, last_country, last_city, last_region, last_browser, last_device, last_login_at FROM users ORDER BY created_at DESC`;
            return res.status(200).json(users);
        } catch (error) {
            console.error(error);
            return res.status(500).json({ error: 'მონაცემთა ბაზის შეცდომა: ' + error.message });
        }
    }

    if (req.method === 'DELETE') {
        const { email } = req.body;

        // CRITICAL: Prevent deletion of main admin
        if (email === 'jaro@gmail.com') {
            return res.status(403).json({ error: 'მთავარი ადმინისტრატორის წაშლა აკრძალულია!' });
        }

        try {
            await sql`DELETE FROM users WHERE email = ${email}`;
            return res.status(200).json({ message: 'მომხმარებელი წაიშალა' });
        } catch (error) {
            return res.status(500).json({ error: 'შეცდომა წაშლისას' });
        }
    }

    if (req.method === 'PATCH') {
        const { email, role, username, password } = req.body;

        // CRITICAL: Protect jaro@gmail.com from role/username changes
        if (email === 'jaro@gmail.com' && (role || username)) {
            return res.status(403).json({ error: 'მთავარი ადმინისტრატორის მონაცემების შეცვლა აკრძალულია!' });
        }

        try {
            if (role) await sql`UPDATE users SET role = ${role} WHERE email = ${email}`;
            if (username) await sql`UPDATE users SET username = ${username} WHERE email = ${email}`;
            if (password) {
                const hashedPassword = await bcrypt.hash(password, 10);
                await sql`UPDATE users SET password = ${hashedPassword} WHERE email = ${email}`;
            }

            return res.status(200).json({ message: 'მონაცემები განახლდა' });
        } catch (error) {
            return res.status(500).json({ error: 'შეცდომა განახლებისას' });
        }
    }

    return res.status(405).json({ error: 'Method not allowed' });
}
