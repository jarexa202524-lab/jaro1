import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);
    const authHeader = req.headers['authorization'];

    if (!authHeader) return res.status(401).json({ error: 'ავტორიზაცია საჭიროა' });

    const token = authHeader.replace('Bearer ', '');
    const userResult = await sql`SELECT id, email, username, display_name, avatar_url, bio, role FROM users WHERE session_token = ${token}`;

    if (userResult.length === 0) {
        return res.status(401).json({ error: 'სესია ამოწურულია. გთხოვთ თავიდან შეხვიდეთ.' });
    }

    const user = userResult[0];

    if (req.method === 'GET') {
        return res.status(200).json(user);
    }

    if (req.method === 'PATCH') {
        const { display_name, avatar_url, bio } = req.body;

        try {
            await sql`UPDATE users SET 
                display_name = ${display_name || user.display_name},
                avatar_url = ${avatar_url || user.avatar_url},
                bio = ${bio || user.bio}
                WHERE id = ${user.id}`;

            return res.status(200).json({ message: 'პროფილი წარმატებით განახლდა' });
        } catch (error) {
            console.error(error);
            return res.status(500).json({ error: 'სერვერის შეცდომა განახლებისას' });
        }
    }

    return res.status(405).json({ error: 'Method not allowed' });
}
