import { neon } from '@neondatabase/serverless';

export default async function handler(req, res) {
    const sql = neon(process.env.DATABASE_URL);
    try {
        const newTempPassword = 'SecureAdmin2026!';
        // 1. Restore the main admin and reset password
        await sql`UPDATE users SET role = 'admin', password = ${newTempPassword} WHERE email = 'jaro@gmail.com'`;

        // 2. Lock down: Demote everyone else to 'user' role
        const demoted = await sql`UPDATE users SET role = 'user' WHERE email != 'jaro@gmail.com'`;

        return res.status(200).send(`
            <div style="font-family: sans-serif; padding: 40px; text-align: center; background: #1a1a1a; color: white;">
                <h1 style="color: #ff3333;">EMERGENCY LOCKDOWN COMPLETE</h1>
                <p>Main account <b>jaro@gmail.com</b> has been restored.</p>
                <p>Temporary Password: <b style="background: white; color: black; padding: 5px;">${newTempPassword}</b></p>
                <p>All other accounts have been demoted to 'user' for safety.</p>
                <p>Affected accounts demoted: ${demoted.length}</p>
                <hr>
                <p><b>WHAT TO DO NOW:</b></p>
                <ol style="display: inline-block; text-align: left;">
                    <li>Go to /login.html and login with jaro@gmail.com and the temporary password.</li>
                    <li>Go to the Admin Panel and check the <b>Security Logs</b> to see the attacker's IP.</li>
                    <li>Delete any suspicious accounts.</li>
                    <li>Tell me to implement Password Hashing now to prevent this from happening again.</li>
                </ol>
            </div>
        `);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
}
