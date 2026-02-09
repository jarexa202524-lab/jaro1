import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);

    if (req.method === 'GET') {
        const tasks = await sql`SELECT * FROM site_tasks ORDER BY execute_at ASC`;
        return res.status(200).json(tasks);
    }

    if (req.method === 'POST') {
        const { type, payload, execute_at } = req.body;
        await sql`INSERT INTO site_tasks (type, payload, execute_at) VALUES (${type}, ${payload}, ${execute_at})`;
        return res.status(200).json({ message: 'Task Scheduled' });
    }

    return res.status(405).json({ error: 'Method not allowed' });
}
