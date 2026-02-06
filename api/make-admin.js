import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);
    try {
        await sql`UPDATE users SET role = 'admin' WHERE email = 'jaro@gmail.com'`;
        return res.status(200).json({ message: 'Success' });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
}
