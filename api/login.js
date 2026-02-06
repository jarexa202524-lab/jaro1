import { neon } from '@neondatabase/serverless';
import bcrypt from 'bcryptjs';
import crypto from 'crypto';

export default async function handler(req, res) {
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

    const { identifier, password } = req.body;
    const sql = neon(process.env.DATABASE_URL);

    let ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress || 'unknown';
    if (ip && ip.includes(',')) ip = ip.split(',')[0].trim();

    try {
        // 1. IP BLOCKING PROTECTION
        await sql`CREATE TABLE IF NOT EXISTS blocked_ips (ip TEXT PRIMARY KEY, blocked_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP)`;
        const isBlocked = await sql`SELECT * FROM blocked_ips WHERE ip = ${ip}`;
        if (isBlocked.length > 0) return res.status(403).json({ error: 'წვდომა შეზღუდულია! თქვენი IP დაბლოკილია საეჭვო აქტივობის გამო.' });

        // Ensure session_token column exists
        try { await sql`ALTER TABLE users ADD COLUMN IF NOT EXISTS session_token TEXT`; } catch (e) { }

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
                await sql`UPDATE users SET last_ip = ${ip}, last_login_at = CURRENT_TIMESTAMP, session_token = ${sessionToken} WHERE id = ${user.id}`;
                await sql`INSERT INTO security_logs (email, event_type, ip_address) VALUES (${user.email}, 'SUCCESSFUL_LOGIN', ${ip})`;

                if (user.email === 'jaro@gmail.com') user.role = 'admin';

                return res.status(200).json({
                    message: 'წარმატებით გაიარეთ ავტორიზაცია',
                    user: { username: user.username, email: user.email, role: user.role, token: sessionToken }
                });
            } else {
                // Log failed attempt and check for brute-force attacks
                await sql`INSERT INTO security_logs (email, event_type, ip_address) VALUES (${identifier}, 'FAILED_LOGIN_ATTEMPT', ${ip})`;

                const failures = await sql`SELECT count(*) FROM security_logs WHERE ip_address = ${ip} AND event_type = 'FAILED_LOGIN_ATTEMPT' AND attempt_at > NOW() - INTERVAL '15 minutes'`;
                if (parseInt(failures[0].count) > 10) {
                    await sql`INSERT INTO blocked_ips (ip) VALUES (${ip}) ON CONFLICT DO NOTHING`;
                    await sql`INSERT INTO security_logs (email, event_type, ip_address) VALUES ('SYSTEM', 'IP_AUTO_BLOCKED', ${ip})`;
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
