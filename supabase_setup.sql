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

-- Top-3 function: returns name + gender + score (no emails) for the leaderboard.
-- Ranked by BEANS CAUGHT (gender-neutral, fair for prizes) but we still display the score/points.
create or replace function public.top_scores()
returns table(name text, gender text, score integer)
language sql
security definer
set search_path = public
as $$
  select name, gender, score from (
    select distinct on (lower(btrim(email))) name, gender, score, beans_caught, created_at
    from public.scores
    where email is not null and btrim(email) <> ''
    order by lower(btrim(email)), beans_caught desc nulls last, created_at asc
  ) t
  order by t.beans_caught desc nulls last, t.created_at asc
  limit 3
$$;

grant execute on function public.top_scores() to anon;


-- ============================================================
-- MIGRATION — run ONLY this part if the table already exists
-- ============================================================
-- alter table public.scores add column if not exists consent boolean not null default false;
--
-- create or replace function public.play_count()
-- returns integer language sql security definer set search_path = public
-- as $$ select count(*)::int from public.scores $$;
-- grant execute on function public.play_count() to anon;
--
-- create or replace function public.top_scores()
-- returns table(gender text, score integer) language sql security definer set search_path = public
-- as $$ select gender, score from public.scores order by score desc, created_at asc limit 3 $$;
-- grant execute on function public.top_scores() to anon;
