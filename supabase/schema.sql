-- AI-AGENT-VERTRIEB: Status-Center Schema v1
-- DSGVO-minimiert: keine Chatinhalte, keine PII-Message-Payloads

create extension if not exists pgcrypto;

-- ==========
-- Tenants / Instances
-- ==========
create table if not exists public.tenants (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  display_name text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.instances (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  instance_code text not null unique,
  host_label text,
  environment text not null default 'prod' check (environment in ('prod','staging','dev')),
  model_ref text,
  status text not null default 'unknown' check (status in ('online','degraded','offline','unknown')),
  last_heartbeat_at timestamptz,
  current_version text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_instances_tenant on public.instances(tenant_id);
create index if not exists idx_instances_status on public.instances(status);

-- ==========
-- Heartbeats (nur technische Betriebsdaten)
-- ==========
create table if not exists public.heartbeats (
  id bigserial primary key,
  instance_id uuid not null references public.instances(id) on delete cascade,
  ts timestamptz not null default now(),
  is_healthy boolean not null,
  queue_depth int,
  context_pct numeric(5,2),
  token_in bigint,
  token_out bigint,
  cost_eur numeric(12,6),
  note text
);

create index if not exists idx_heartbeats_instance_ts on public.heartbeats(instance_id, ts desc);

-- ==========
-- Incidents (technische Fehlerklassen)
-- ==========
create table if not exists public.incidents (
  id bigserial primary key,
  instance_id uuid not null references public.instances(id) on delete cascade,
  opened_at timestamptz not null default now(),
  closed_at timestamptz,
  severity text not null check (severity in ('info','warn','error','critical')),
  code text not null,
  summary text not null,
  details jsonb,
  is_open boolean generated always as (closed_at is null) stored
);

create index if not exists idx_incidents_open on public.incidents(instance_id, is_open);

-- ==========
-- Deployments / Versions
-- ==========
create table if not exists public.deployments (
  id bigserial primary key,
  instance_id uuid not null references public.instances(id) on delete cascade,
  deployed_at timestamptz not null default now(),
  version text not null,
  actor text,
  changelog text
);

create index if not exists idx_deployments_instance_ts on public.deployments(instance_id, deployed_at desc);

-- ==========
-- Cost snapshots (aggregiert)
-- ==========
create table if not exists public.cost_snapshots (
  id bigserial primary key,
  instance_id uuid not null references public.instances(id) on delete cascade,
  bucket_start timestamptz not null,
  bucket_end timestamptz not null,
  token_in bigint,
  token_out bigint,
  cost_eur numeric(12,6),
  unique(instance_id, bucket_start, bucket_end)
);

-- ==========
-- updated_at trigger
-- ==========
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists trg_instances_updated_at on public.instances;
create trigger trg_instances_updated_at
before update on public.instances
for each row execute function public.set_updated_at();

-- ==========
-- RLS baseline
-- ==========
alter table public.tenants enable row level security;
alter table public.instances enable row level security;
alter table public.heartbeats enable row level security;
alter table public.incidents enable row level security;
alter table public.deployments enable row level security;
alter table public.cost_snapshots enable row level security;

-- For now: authenticated users can read/write (MVP). Later tighten by tenant membership claims.
drop policy if exists p_all_tenants on public.tenants;
create policy p_all_tenants on public.tenants for all to authenticated using (true) with check (true);

drop policy if exists p_all_instances on public.instances;
create policy p_all_instances on public.instances for all to authenticated using (true) with check (true);

drop policy if exists p_all_heartbeats on public.heartbeats;
create policy p_all_heartbeats on public.heartbeats for all to authenticated using (true) with check (true);

drop policy if exists p_all_incidents on public.incidents;
create policy p_all_incidents on public.incidents for all to authenticated using (true) with check (true);

drop policy if exists p_all_deployments on public.deployments;
create policy p_all_deployments on public.deployments for all to authenticated using (true) with check (true);

drop policy if exists p_all_cost on public.cost_snapshots;
create policy p_all_cost on public.cost_snapshots for all to authenticated using (true) with check (true);
