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

-- Worklog / delivery board
create table if not exists public.mc_work_items (
  id bigserial primary key,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  title text not null,
  status text not null default 'in_progress' check (status in ('in_progress','done','blocked','todo')),
  owner text not null default 'guenther',
  eta_at timestamptz,
  result_link text,
  notes text
);

create or replace function public.mc_set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists trg_mc_work_items_updated_at on public.mc_work_items;
create trigger trg_mc_work_items_updated_at
before update on public.mc_work_items
for each row execute function public.mc_set_updated_at();

alter table public.mc_todos enable row level security;
alter table public.mc_activity enable row level security;
alter table public.mc_work_items enable row level security;

drop policy if exists p_all_mc_todos on public.mc_todos;
create policy p_all_mc_todos on public.mc_todos for all to authenticated using (true) with check (true);

drop policy if exists p_all_mc_activity on public.mc_activity;
create policy p_all_mc_activity on public.mc_activity for all to authenticated using (true) with check (true);

drop policy if exists p_all_mc_work_items on public.mc_work_items;
create policy p_all_mc_work_items on public.mc_work_items for all to authenticated using (true) with check (true);

insert into public.mc_activity (source,event,summary) values
('system','mission_control_bootstrap','Mission Control schema initialized')
on conflict do nothing;

insert into public.mc_work_items (title,status,owner,notes)
values
('Mission Control MVP deployed','done','guenther','Initial dashboard with auth + overview + agents + crm + activity'),
('Add worklog board','in_progress','guenther','Track in-progress/done/blocked centrally')
on conflict do nothing;
