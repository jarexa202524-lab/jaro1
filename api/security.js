import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);
    const authHeader = req.headers['authorization'];

    if (req.method === 'GET') {
        const bans = await sql`SELECT * FROM site_bans ORDER BY created_at DESC`;
        return res.status(200).json(bans);
    }

    if (req.method === 'POST') {
        // Only Admin can ban
        if (!authHeader) return res.status(401).json({ error: 'Unauthorized' });

        const { target, reason } = req.body;
        try {
            await sql`INSERT INTO site_bans (target, reason) VALUES (${target}, ${reason}) ON CONFLICT (target) DO UPDATE SET reason = ${reason}`;
            return res.status(200).json({ message: 'Target Banned' });
        } catch (e) {
            return res.status(500).json({ error: e.message });
        }
    }

    if (req.method === 'DELETE') {
        const { target } = req.body;
        await sql`DELETE FROM site_bans WHERE target = ${target}`;
        return res.status(200).json({ message: 'Unbanned' });
    }

    return res.status(405).json({ error: 'Method not allowed' });
}
