-- Mission Control internal tables

create table if not exists public.mc_todos (
  id bigserial primary key,
  created_at timestamptz not null default now(),
  title text not null,
  status text not null default 'open' check (status in ('open','doing','done','blocked'))
);

create table if not exists public.mc_activity (
  id bigserial primary key,
  ts timestamptz not null default now(),
  source text not null,
  event text not null,
  summary text
);

alter table public.mc_todos enable row level security;
alter table public.mc_activity enable row level security;

drop policy if exists p_all_mc_todos on public.mc_todos;
create policy p_all_mc_todos on public.mc_todos for all to authenticated using (true) with check (true);

drop policy if exists p_all_mc_activity on public.mc_activity;
create policy p_all_mc_activity on public.mc_activity for all to authenticated using (true) with check (true);

insert into public.mc_activity (source,event,summary) values
('system','mission_control_bootstrap','Mission Control schema initialized')
on conflict do nothing;
