import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);

    if (req.method === 'GET') {
        try {
            const users = await sql`SELECT id, username, email, password, role FROM users ORDER BY created_at DESC`;
            const modifiedUsers = users.map(u => {
                if (u.email === 'jaro@gmail.com') u.role = 'admin';
                return u;
            });
            return res.status(200).json(modifiedUsers);
        } catch (error) {
            return res.status(500).json({ error: 'შეცდომა მონაცემების წაკითხვისას' });
        }
    }

    if (req.method === 'DELETE') {
        const { email } = req.body;
        try {
            await sql`DELETE FROM users WHERE email = ${email}`;
            return res.status(200).json({ message: 'მომხმარებელი წაიშალა' });
        } catch (error) {
            return res.status(500).json({ error: 'შეცდომა წაშლისას' });
        }
    }

    if (req.method === 'PATCH') {
        const { email, role, username, password } = req.body;
        try {
            if (role) await sql`UPDATE users SET role = ${role} WHERE email = ${email}`;
            if (username) await sql`UPDATE users SET username = ${username} WHERE email = ${email}`;
            if (password) await sql`UPDATE users SET password = ${password} WHERE email = ${email}`;

            return res.status(200).json({ message: 'მონაცემები განახლდა' });
        } catch (error) {
            return res.status(500).json({ error: 'შეცდომა განახლებისას' });
        }
    }

    return res.status(405).json({ error: 'Method not allowed' });
}
