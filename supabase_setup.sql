-- RC CENTER GANESH COMMITTEE — SUPABASE SETUP
-- Run this entire script in Supabase Dashboard → SQL Editor.
-- The app uses Supabase Auth and allows signed-in RC Center members to share one committee dataset.

create table if not exists public.collections (
  id bigint primary key,
  donor text not null,
  amount numeric(12,2) not null check (amount > 0),
  method text not null check (method in ('UPI','Cash','Bank')),
  date date not null default current_date,
  note text default '',
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.expenses (
  id bigint primary key,
  item text not null,
  amount numeric(12,2) not null check (amount > 0),
  category text not null,
  date date not null default current_date,
  note text default '',
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.collections enable row level security;
alter table public.expenses enable row level security;

-- Shared RC Center committee: every authenticated committee account can read/write committee records.
-- Only give accounts to trusted committee members.
drop policy if exists "authenticated can read collections" on public.collections;
drop policy if exists "authenticated can insert collections" on public.collections;
drop policy if exists "authenticated can update collections" on public.collections;
drop policy if exists "authenticated can delete collections" on public.collections;
create policy "authenticated can read collections" on public.collections for select to authenticated using (true);
create policy "authenticated can insert collections" on public.collections for insert to authenticated with check (true);
create policy "authenticated can update collections" on public.collections for update to authenticated using (true) with check (true);
create policy "authenticated can delete collections" on public.collections for delete to authenticated using (true);

drop policy if exists "authenticated can read expenses" on public.expenses;
drop policy if exists "authenticated can insert expenses" on public.expenses;
drop policy if exists "authenticated can update expenses" on public.expenses;
drop policy if exists "authenticated can delete expenses" on public.expenses;
create policy "authenticated can read expenses" on public.expenses for select to authenticated using (true);
create policy "authenticated can insert expenses" on public.expenses for insert to authenticated with check (true);
create policy "authenticated can update expenses" on public.expenses for update to authenticated using (true) with check (true);
create policy "authenticated can delete expenses" on public.expenses for delete to authenticated using (true);

-- Grant only the client roles the app needs. RLS remains the row-level gate.
grant select, insert, update, delete on public.collections to authenticated;
grant select, insert, update, delete on public.expenses to authenticated;

-- Optional hardening: after creating your committee accounts, turn OFF public email signups
-- in Authentication → Providers → Email. Then create/invite only trusted members.
