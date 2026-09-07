# RC Center Ganesh Committee — V2 Cloud Edition

This version keeps the existing V2 interface and adds Supabase cloud storage + email/password authentication.

## Files
- `index.html` — complete cloud-connected app
- `supabase_setup.sql` — database tables, grants and RLS policies

## Mobile deployment
1. Create a Supabase project.
2. Open SQL Editor and run `supabase_setup.sql`.
3. In Supabase Project Settings → API Keys, copy the Project URL and **Publishable Key**. Never use the secret/service-role key in this browser app.
4. Deploy `index.html` to Netlify Drop.
5. Open the deployed URL. The app asks for the Supabase URL and Publishable Key once and stores them locally on that device.
6. Create the first RC Center account. If email confirmation is enabled, confirm the email first.
7. After signing in, the app loads cloud data. If the cloud tables are empty but local V2 data exists, it uploads that local data as the initial dataset.
8. Add trusted committee member accounts from Supabase Auth, then disable public signups if you want only invited/approved members to access the app.

## Data safety
- Main records are stored in Supabase Postgres, not only in the browser.
- Supabase Auth stores the login session.
- RLS is enabled for both tables and only authenticated users can access them.
- The app also keeps a local copy for resilience and has JSON/CSV backup.
- Supabase's secret/service-role key must never be put into `index.html`.
- RLS policies in this starter are shared-committee policies: every authenticated RC Center member can read/write the committee data. Only give accounts to trusted members.

## Important
The free tier is subject to provider limits and policies. Cloud storage is not the same as a backup. Keep periodic JSON exports in a separate safe location.
