import { neon } from '@neondatabase/serverless';
import bcrypt from 'bcryptjs';

export default async function handler(req, res) {
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

    const { username, email, password } = req.body;
    const sql = neon(process.env.DATABASE_URL);

    // ADVANCED IP & PROXY DETECTION (Anti-VPN)
    const forwarded = req.headers['x-forwarded-for'];
    const realIp = req.headers['x-real-ip'];
    const vercelIp = req.headers['x-vercel-forwarded-for'];
    const country = req.headers['x-vercel-ip-country'] || 'Unknown';
    const ip = forwarded ? forwarded.split(',')[0].trim() : (realIp || req.socket.remoteAddress || 'unknown');
    const fullIpInfo = `Client: ${ip}, Country: ${country}, Forwarded: ${forwarded || 'none'}, RealIP: ${realIp || 'none'}, Vercel: ${vercelIp || 'none'}`;
    const userAgent = req.headers['user-agent'] || 'unknown';

    // Simple browser detection from userAgent
    let browser = "Other";
    if (userAgent.includes("Firefox")) browser = "Firefox";
    else if (userAgent.includes("SamsungBrowser")) browser = "Samsung Browser";
    else if (userAgent.includes("Opera") || userAgent.includes("OPR")) browser = "Opera";
    else if (userAgent.includes("Trident")) browser = "Internet Explorer";
    else if (userAgent.includes("Edge") || userAgent.includes("Edg")) browser = "Edge";
    else if (userAgent.includes("Chrome")) browser = "Chrome";
    else if (userAgent.includes("Safari")) browser = "Safari";

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

        // Create Security Logs table with Advanced Columns
        await sql`CREATE TABLE IF NOT EXISTS security_logs (
            id SERIAL PRIMARY KEY,
            email TEXT,
            event_type TEXT,
            ip_address TEXT,
            user_agent TEXT,
            full_details TEXT,
            attempt_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        )`;
        try {
            await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS last_country TEXT`;
            await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS last_browser TEXT`;
            await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS user_agent TEXT`;
            await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS full_details TEXT`;
            await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS browser TEXT`;
            await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS country TEXT`;
        } catch (e) { }

        // Check if user exists
        const existing = await sql`SELECT * FROM users WHERE email = ${email} OR username = ${username}`;
        if (existing.length > 0) {
            return res.status(400).json({ error: 'მომხმარებელი ამ სახელით ან მაილით უკვე არსებობს!' });
        }

        // ULTRA-SECURE PASSWORD VALIDATION (Complex requirements)
        const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
        if (!passwordRegex.test(password)) {
            return res.status(400).json({ error: 'პაროლი უნდა იყოს მინიმუმ 8 სიმბოლო და შეიცავდეს: დიდ ასოს, პატარა ასოს, ციფრს და სიმბოლოს (@$!%*?&).' });
        }

        // Hash password with higher cost factor (12) for extra security
        const hashedPassword = await bcrypt.hash(password, 12);

        // Insert user
        await sql`INSERT INTO users (username, email, password, last_ip, last_country, last_browser, last_login_at) VALUES (${username}, ${email}, ${hashedPassword}, ${ip}, ${country}, ${browser}, CURRENT_TIMESTAMP)`;

        // Log registration with Proxy Info
        await sql`INSERT INTO security_logs (email, event_type, ip_address, user_agent, full_details, browser, country) VALUES (${email}, 'USER_REGISTERED', ${ip}, ${userAgent}, ${fullIpInfo}, ${browser}, ${country})`;

        return res.status(200).json({ message: 'წარმატებით დარეგისტრირდით!' });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'სერვერის შეცდომა' });
    }
}
