import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

    const { username, email, password } = req.body;
    const sql = neon(process.env.DATABASE_URL);

    try {
        // Create table if not exists
        await sql`CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      username TEXT UNIQUE NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      role TEXT DEFAULT 'user',
      created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    )`;

        // Check if user exists
        const existing = await sql`SELECT * FROM users WHERE email = ${email} OR username = ${username}`;
        if (existing.length > 0) {
            return res.status(400).json({ error: 'მომხმარებელი ამ სახელით ან მაილით უკვე არსებობს!' });
        }

        // Insert user
        await sql`INSERT INTO users (username, email, password) VALUES (${username}, ${email}, ${password})`;

        return res.status(200).json({ message: 'წარმატებით დარეგისტრირდით!' });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'სერვერის შეცდომა' });
    }
}
