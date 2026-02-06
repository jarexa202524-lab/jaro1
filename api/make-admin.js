import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);
    try {
        const result = await sql`UPDATE users SET role = 'admin' WHERE email = 'jaro@gmail.com'`;
        return res.status(200).json({
            success: true,
            message: 'jaro@gmail.com role updated to admin',
            rowsAffected: result.length // In postgres-js/neon-serverless, result often contains the rows or count
        });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
}
