-- Seed v1
insert into public.crm_leads (full_name, company, source, channel, stage, score, problem_summary, next_step, next_followup_at, estimated_value_eur)
values
('Demo Lead A', 'Musterfirma A', 'insta', 'dm', 'new', 20, 'Operative Überlastung', 'Erstkontakt senden', now() + interval '1 day', 1200),
('Demo Lead B', 'Musterfirma B', 'x', 'dm', 'contacted', 35, 'Follow-up Chaos', 'Follow-up #1 senden', now() + interval '6 hours', 1800)
on conflict do nothing;

insert into public.crm_tasks (title, due_at, priority, status, assignee)
values
('20 neue DMs senden', now() + interval '12 hours', 'high', 'open', 'tim'),
('2 Follow-ups für alte Leads', now() + interval '8 hours', 'normal', 'open', 'tim')
on conflict do nothing;
