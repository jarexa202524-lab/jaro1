import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

    const sql = neon(process.env.DATABASE_URL);

    // SECURITY CHECK: Verify Admin Token
    const authHeader = req.headers['authorization'];
    if (!authHeader) return res.status(401).json({ error: 'წვდომა უარყოფილია!' });

    const token = authHeader.replace('Bearer ', '');
    const validUsers = await sql`SELECT email, role FROM users WHERE session_token = ${token}`;

    if (validUsers.length === 0 || (validUsers[0].email !== 'jaro@gmail.com' && validUsers[0].role !== 'admin')) {
        return res.status(403).json({ error: 'წვდომა უარყოფილია!' });
    }

    try {
        // Ensure posts table exists if not already there
        await sql`CREATE TABLE IF NOT EXISTS posts (
            id SERIAL PRIMARY KEY,
            title TEXT NOT NULL,
            content TEXT,
            author_email TEXT NOT NULL,
            status TEXT DEFAULT 'pending',
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        )`;

        // Fetch stats
        const totalPosts = await sql`SELECT count(*) FROM posts`;
        const pendingPosts = await sql`SELECT count(*) FROM posts WHERE status = 'pending'`;

        const now = new Date();
        const oneDayAgo = new Date(now - 24 * 60 * 60 * 1000).toISOString();
        const oneMonthAgo = new Date(now - 30 * 24 * 60 * 60 * 1000).toISOString();
        const oneYearAgo = new Date(now - 365 * 24 * 60 * 60 * 1000).toISOString();

        const daily = await sql`SELECT count(*) FROM posts WHERE created_at > ${oneDayAgo}`;
        const monthly = await sql`SELECT count(*) FROM posts WHERE created_at > ${oneMonthAgo}`;
        const yearly = await sql`SELECT count(*) FROM posts WHERE created_at > ${oneYearAgo}`;

        // User Ranking by posts
        const ranking = await sql`
            SELECT author_email, count(*) as post_count 
            FROM posts 
            GROUP BY author_email 
            ORDER BY post_count DESC 
            LIMIT 10
        `;

        return res.status(200).json({
            summary: {
                total: parseInt(totalPosts[0].count),
                pending: parseInt(pendingPosts[0].count),
                daily: parseInt(daily[0].count),
                monthly: parseInt(monthly[0].count),
                yearly: parseInt(yearly[0].count)
            },
            ranking
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'შეცდომა სტატისტიკის წაკითხვისას: ' + error.message });
    }
}
