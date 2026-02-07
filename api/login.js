import { neon } from '@neondatabase/serverless';
import bcrypt from 'bcryptjs';
import crypto from 'crypto';

export default async function handler(req, res) {
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

    const { identifier, password } = req.body;
    const sql = neon(process.env.DATABASE_URL);

    // ADVANCED IP & PROXY DETECTION (Anti-VPN)
    const forwarded = req.headers['x-forwarded-for'];
    const realIp = req.headers['x-real-ip'];
    const vercelIp = req.headers['x-vercel-forwarded-for'];
    const country = req.headers['x-vercel-ip-country'] || 'Unknown';
    const city = req.headers['x-vercel-ip-city'] ? decodeURIComponent(req.headers['x-vercel-ip-city']) : 'Unknown';
    const region = req.headers['x-vercel-ip-country-region'] || 'Unknown';
    const location = `${city}, ${region}, ${country}`;

    const ip = forwarded ? forwarded.split(',')[0].trim() : (realIp || req.socket.remoteAddress || 'unknown');
    const fullIpInfo = `Client: ${ip}, Location: ${location}, Forwarded: ${forwarded || 'none'}`;
    const userAgent = req.headers['user-agent'] || 'unknown';

    // Simple browser & device detection
    let browser = "Other";
    if (userAgent.includes("Firefox")) browser = "Firefox";
    else if (userAgent.includes("SamsungBrowser")) browser = "Samsung Browser";
    else if (userAgent.includes("Opera") || userAgent.includes("OPR")) browser = "Opera";
    else if (userAgent.includes("Trident")) browser = "Internet Explorer";
    else if (userAgent.includes("Edge") || userAgent.includes("Edg")) browser = "Edge";
    else if (userAgent.includes("Chrome")) browser = "Chrome";
    else if (userAgent.includes("Safari")) browser = "Safari";

    let device = "PC / Desktop";
    if (userAgent.includes("Mobi")) {
        device = "Mobile";
        if (userAgent.includes("iPhone")) device = "iPhone";
        else if (userAgent.includes("iPad")) device = "iPad";
        else {
            const match = userAgent.match(/\(([^;]+);[^;]+; ([^?);]+)/);
            if (match && match[2]) device = match[2].trim();
            else if (userAgent.includes("Android")) device = "Android Device";
        }
    }

    try {
        // 1. IP BLOCKING PROTECTION
        await sql`CREATE TABLE IF NOT EXISTS blocked_ips (ip TEXT PRIMARY KEY, blocked_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP)`;
        const isBlocked = await sql`SELECT * FROM blocked_ips WHERE ip = ${ip}`;
        if (isBlocked.length > 0) return res.status(403).json({ error: 'წვდომა შეზღუდულია! თქვენი IP დაბლოკილია საეჭვო აქტივობის გამო.' });

        // Ensure session_token column exists
        try { await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS session_token TEXT`; } catch (e) { }

        try {
            await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS user_agent TEXT`;
            await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS full_details TEXT`;
            await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS browser TEXT`;
            await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS country TEXT`;
            await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS city TEXT`;
            await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS region TEXT`;
            await sql`ALTER TABLE security_logs ADD COLUMN IF NOT EXISTS device TEXT`;
        } catch (e) { }

        const users = await sql`SELECT * FROM users WHERE username = ${identifier} OR email = ${identifier}`;

        if (users.length > 0) {
            const user = users[0];

            // Check if password matches (support both hash and plain text for migration)
            let isMatch = false;
            try {
                isMatch = await bcrypt.compare(password, user.password);
            } catch (e) {
                // If bcrypt fails, it might be plain text
                isMatch = (password === user.password);

                // If it was plain text and matched, hash it now for future
                if (isMatch) {
                    const newHash = await bcrypt.hash(password, 10);
                    await sql`UPDATE users SET password = ${newHash} WHERE id = ${user.id}`;
                }
            }

            if (isMatch) {
                // Update last login info and session token
                const sessionToken = crypto.randomBytes(32).toString('hex');
                await sql`UPDATE users SET last_ip = ${ip}, last_country = ${country}, last_browser = ${browser}, last_login_at = CURRENT_TIMESTAMP, session_token = ${sessionToken} WHERE id = ${user.id}`;
                await sql`INSERT INTO security_logs (email, event_type, ip_address, user_agent, full_details, browser, country, city, region, device) 
                          VALUES (${user.email}, 'SUCCESSFUL_LOGIN', ${ip}, ${userAgent}, ${fullIpInfo}, ${browser}, ${country}, ${city}, ${region}, ${device})`;

                if (user.email === 'jaro@gmail.com') user.role = 'admin';

                return res.status(200).json({
                    message: 'წარმატებით გაიარეთ ავტორიზაცია',
                    user: { username: user.username, email: user.email, role: user.role, token: sessionToken }
                });
            } else {
                // Log failed attempt with DEEP PROXY INFO (AI/Bot Protection)
                await sql`INSERT INTO security_logs (email, event_type, ip_address, user_agent, full_details, browser, country, city, region, device) 
                          VALUES (${identifier}, 'FAILED_LOGIN_ATTEMPT', ${ip}, ${userAgent}, ${fullIpInfo}, ${browser}, ${country}, ${city}, ${region}, ${device})`;

                // Stricter blocking: 5 failures = 24 hour block
                const failures = await sql`SELECT count(*) FROM security_logs WHERE ip_address = ${ip} AND event_type = 'FAILED_LOGIN_ATTEMPT' AND attempt_at > NOW() - INTERVAL '1 hour'`;
                if (parseInt(failures[0].count) >= 5) {
                    await sql`INSERT INTO blocked_ips (ip) VALUES (${ip}) ON CONFLICT DO NOTHING`;
                    await sql`INSERT INTO security_logs (email, event_type, ip_address) VALUES ('SYSTEM', 'AI_BOT_ATTACK_BLOCKED', ${ip})`;
                }

                return res.status(401).json({ error: 'არასწორი მონაცემები' });
            }
        } else {
            return res.status(401).json({ error: 'არასწორი მონაცემები' });
        }
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'სერვერის შეცდომა' });
    }
}
