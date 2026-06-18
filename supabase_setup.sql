-- ============================================================
-- FULL SETUP (run once on a fresh project). If you ALREADY ran
-- the first version, skip to the "MIGRATION" block at the bottom.
-- Supabase → SQL Editor → paste → Run.
-- ============================================================

create table if not exists public.scores (
  id           bigint generated always as identity primary key,
  name         text not null,
  email        text,
  gender       text not null check (gender in ('male','female')),
  score        integer not null,
  beans_caught integer,
  consent      boolean not null default false,
  created_at   timestamptz not null default now()
);

alter table public.scores enable row level security;

-- Public (anon) key may INSERT scores only — it cannot read anyone's data.
drop policy if exists "anon can insert scores" on public.scores;
create policy "anon can insert scores"
  on public.scores for insert
  to anon
  with check (true);

-- Count-only function: lets the game show "X games played" WITHOUT
-- exposing names/emails. Runs as definer so it bypasses RLS for the count only.
create or replace function public.play_count()
returns integer
language sql
security definer
set search_path = public
as $$ select count(*)::int from public.scores $$;

grant execute on function public.play_count() to anon;


-- ============================================================
-- MIGRATION — run ONLY this part if the table already exists
-- ============================================================
-- alter table public.scores add column if not exists consent boolean not null default false;
--
-- create or replace function public.play_count()
-- returns integer language sql security definer set search_path = public
-- as $$ select count(*)::int from public.scores $$;
-- grant execute on function public.play_count() to anon;
