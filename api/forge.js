import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);

    if (req.method === 'POST') {
        const { email, action } = req.body;
        if (!email) return res.status(400).json({ error: 'Email required' });

        let xpToAdd = 0;
        if (action === 'comment') xpToAdd = 10;
        if (action === 'like') xpToAdd = 2;
        if (action === 'visit') xpToAdd = 1;

        try {
            const result = await sql`
                UPDATE users 
                SET xp = xp + ${xpToAdd},
                    level = FLOOR((xp + ${xpToAdd}) / 100) + 1
                WHERE email = ${email}
                RETURNING xp, level, badges
            `;

            if (result.length === 0) return res.status(404).json({ error: 'User not found' });

            // Check for new badges
            let currentBadges = result[0].badges || [];
            let newBadge = null;

            if (result[0].xp >= 100 && !currentBadges.includes('Novice')) newBadge = 'Novice';
            if (result[0].xp >= 500 && !currentBadges.includes('Veteran')) newBadge = 'Veteran';
            if (result[0].xp >= 1000 && !currentBadges.includes('Elite')) newBadge = 'Elite';

            if (newBadge) {
                currentBadges.push(newBadge);
                await sql`UPDATE users SET badges = ${JSON.stringify(currentBadges)} WHERE email = ${email}`;
            }

            return res.status(200).json({
                xp: result[0].xp,
                level: result[0].level,
                badges: currentBadges,
                newBadge: newBadge
            });
        } catch (e) {
            return res.status(500).json({ error: e.message });
        }
    }

    return res.status(405).json({ error: 'Method not allowed' });
}
