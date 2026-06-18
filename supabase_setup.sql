-- Run this once in Supabase → SQL Editor (https://lbyuuzrqachfasxnxzoh.supabase.co)

create table if not exists public.scores (
  id          bigint generated always as identity primary key,
  name        text not null,
  email       text,
  gender      text not null check (gender in ('male','female')),
  score       integer not null,
  beans_caught integer,
  created_at  timestamptz not null default now()
);

-- Enable Row Level Security
alter table public.scores enable row level security;

-- Allow the public (anon) key to INSERT scores only — no reading others' data.
create policy "anon can insert scores"
  on public.scores for insert
  to anon
  with check (true);

-- (Optional) if you later want a public leaderboard, add:
-- create policy "anon can read scores" on public.scores for select to anon using (true);
