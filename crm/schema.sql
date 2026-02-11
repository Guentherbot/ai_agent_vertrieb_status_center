-- CRM v1 (Supabase)
-- Fokus: Lead-Pipeline + Touchpoints + Tasks

create extension if not exists pgcrypto;

create table if not exists public.crm_leads (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  full_name text,
  company text,
  source text not null default 'manual', -- insta, x, dm, referral, ad
  channel text not null default 'dm',     -- dm, whatsapp, email, phone
  handle text,

  stage text not null default 'new' check (stage in (
    'new','contacted','replied','qualified','call_booked','won','lost'
  )),

  score int default 0,
  owner text default 'tim',
  problem_summary text,
  next_step text,
  next_followup_at timestamptz,
  estimated_value_eur numeric(12,2),

  is_archived boolean not null default false
);

create index if not exists idx_crm_leads_stage on public.crm_leads(stage);
create index if not exists idx_crm_leads_followup on public.crm_leads(next_followup_at);

create table if not exists public.crm_touchpoints (
  id bigserial primary key,
  lead_id uuid not null references public.crm_leads(id) on delete cascade,
  created_at timestamptz not null default now(),
  type text not null check (type in ('outbound','inbound','note','call')),
  channel text,
  content text,
  outcome text
);

create table if not exists public.crm_tasks (
  id bigserial primary key,
  lead_id uuid references public.crm_leads(id) on delete cascade,
  created_at timestamptz not null default now(),
  due_at timestamptz,
  title text not null,
  priority text default 'normal' check (priority in ('low','normal','high')),
  status text default 'open' check (status in ('open','done','canceled')),
  assignee text default 'tim'
);

create table if not exists public.crm_stage_history (
  id bigserial primary key,
  lead_id uuid not null references public.crm_leads(id) on delete cascade,
  changed_at timestamptz not null default now(),
  old_stage text,
  new_stage text not null,
  reason text
);

create or replace function public.crm_set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists trg_crm_leads_updated_at on public.crm_leads;
create trigger trg_crm_leads_updated_at
before update on public.crm_leads
for each row execute function public.crm_set_updated_at();

-- RLS (MVP): authenticated full access
alter table public.crm_leads enable row level security;
alter table public.crm_touchpoints enable row level security;
alter table public.crm_tasks enable row level security;
alter table public.crm_stage_history enable row level security;

drop policy if exists p_all_crm_leads on public.crm_leads;
create policy p_all_crm_leads on public.crm_leads for all to authenticated using (true) with check (true);

drop policy if exists p_all_crm_touchpoints on public.crm_touchpoints;
create policy p_all_crm_touchpoints on public.crm_touchpoints for all to authenticated using (true) with check (true);

drop policy if exists p_all_crm_tasks on public.crm_tasks;
create policy p_all_crm_tasks on public.crm_tasks for all to authenticated using (true) with check (true);

drop policy if exists p_all_crm_stage_history on public.crm_stage_history;
create policy p_all_crm_stage_history on public.crm_stage_history for all to authenticated using (true) with check (true);
