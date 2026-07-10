create table if not exists credit_packages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  name text not null,
  credits int not null,
  price_usd_cents int not null,
  stripe_price_id text,
  created_at timestamptz not null default now()
);
alter table credit_packages enable row level security;
drop policy if exists "credit_packages_v1_read" on credit_packages;
create policy "credit_packages_v1_read" on credit_packages for select using (true);
drop policy if exists "credit_packages_v1_write" on credit_packages;
create policy "credit_packages_v1_write" on credit_packages for all using (true) with check (true);

insert into credit_packages (id, name, credits, price_usd_cents, stripe_price_id) values
  ('a1000000-0000-0000-0000-000000000001', 'Starter', 1, 4900, 'price_starter_placeholder'),
  ('a1000000-0000-0000-0000-000000000002', 'Builder', 3, 12900, 'price_builder_placeholder'),
  ('a1000000-0000-0000-0000-000000000003', 'Pro', 5, 19900, 'price_pro_placeholder')
on conflict (id) do nothing;

create table if not exists credit_ledger (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  credits_purchased int not null default 0,
  credits_used int not null default 0,
  credits_remaining int not null default 0,
  stripe_payment_intent text,
  package_id uuid references credit_packages(id),
  created_at timestamptz not null default now()
);
alter table credit_ledger enable row level security;
drop policy if exists "credit_ledger_v1_read" on credit_ledger;
create policy "credit_ledger_v1_read" on credit_ledger for select using (true);
drop policy if exists "credit_ledger_v1_write" on credit_ledger;
create policy "credit_ledger_v1_write" on credit_ledger for all using (true) with check (true);

insert into credit_ledger (id, user_id, credits_purchased, credits_used, credits_remaining, stripe_payment_intent, package_id) values
  ('b1000000-0000-0000-0000-000000000001', null, 1, 1, 0, 'pi_demo_001', 'a1000000-0000-0000-0000-000000000001'),
  ('b1000000-0000-0000-0000-000000000002', null, 3, 1, 2, 'pi_demo_002', 'a1000000-0000-0000-0000-000000000002')
on conflict (id) do nothing;

create table if not exists decision_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  credit_ledger_id uuid references credit_ledger(id),
  business_idea text,
  current_engine int not null default 1,
  current_step int not null default 0,
  status text not null default 'in_progress',
  created_at timestamptz not null default now()
);
alter table decision_sessions enable row level security;
drop policy if exists "decision_sessions_v1_read" on decision_sessions;
create policy "decision_sessions_v1_read" on decision_sessions for select using (true);
drop policy if exists "decision_sessions_v1_write" on decision_sessions;
create policy "decision_sessions_v1_write" on decision_sessions for all using (true) with check (true);

insert into decision_sessions (id, user_id, credit_ledger_id, business_idea, current_engine, current_step, status) values
  ('c1000000-0000-0000-0000-000000000001', null, 'b1000000-0000-0000-0000-000000000001', 'AI-powered meal planning app for busy parents', 3, 5, 'complete'),
  ('c1000000-0000-0000-0000-000000000002', null, 'b1000000-0000-0000-0000-000000000002', 'B2B SaaS for freelance accountants', 2, 3, 'in_progress')
on conflict (id) do nothing;

create table if not exists engine_responses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  session_id uuid references decision_sessions(id),
  engine_number int not null,
  question_key text not null,
  response_text text,
  created_at timestamptz not null default now()
);
alter table engine_responses enable row level security;
drop policy if exists "engine_responses_v1_read" on engine_responses;
create policy "engine_responses_v1_read" on engine_responses for select using (true);
drop policy if exists "engine_responses_v1_write" on engine_responses;
create policy "engine_responses_v1_write" on engine_responses for all using (true) with check (true);

insert into engine_responses (id, user_id, session_id, engine_number, question_key, response_text) values
  ('d1000000-0000-0000-0000-000000000001', null, 'c1000000-0000-0000-0000-000000000001', 1, 'strengths', 'I have 8 years in product design and a strong network of parent communities online.'),
  ('d1000000-0000-0000-0000-000000000002', null, 'c1000000-0000-0000-0000-000000000001', 1, 'constraints', 'Limited runway — 4 months of savings. Working alone. No technical co-founder.'),
  ('d1000000-0000-0000-0000-000000000003', null, 'c1000000-0000-0000-0000-000000000001', 1, 'competing_ideas', 'Also considering a coaching business and a Notion template store.'),
  ('d1000000-0000-0000-0000-000000000004', null, 'c1000000-0000-0000-0000-000000000002', 1, 'strengths', '12 years as a chartered accountant. Deep understanding of freelancer pain points.'),
  ('d1000000-0000-0000-0000-000000000005', null, 'c1000000-0000-0000-0000-000000000002', 2, 'demand_evidence', 'Posted in 3 freelancer Facebook groups — 47 people said they would pay for this.')
on conflict (id) do nothing;

create table if not exists ai_outputs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  session_id uuid references decision_sessions(id),
  engine_number int not null,
  report_type text not null,
  value text,
  source text,
  confidence numeric,
  review_status text not null default 'unreviewed',
  pdf_url text,
  created_at timestamptz not null default now()
);
alter table ai_outputs enable row level security;
drop policy if exists "ai_outputs_v1_read" on ai_outputs;
create policy "ai_outputs_v1_read" on ai_outputs for select using (true);
drop policy if exists "ai_outputs_v1_write" on ai_outputs;
create policy "ai_outputs_v1_write" on ai_outputs for all using (true) with check (true);

insert into ai_outputs (id, user_id, session_id, engine_number, report_type, value, source, confidence, review_status, pdf_url) values
  ('e1000000-0000-0000-0000-000000000001', null, 'c1000000-0000-0000-0000-000000000001', 1, 'core_goal', 'Your strongest direction is the AI meal planning app. Your design background and parent community access give you an unfair advantage. Recommended focus: validate willingness-to-pay with 20 parents before building anything.', 'openai/gpt-4o', 0.87, 'unreviewed', null),
  ('e1000000-0000-0000-0000-000000000002', null, 'c1000000-0000-0000-0000-000000000001', 2, 'goal_pathway', 'Pathway: Launch a waitlist with a $9/month pre-sell offer. Readiness score: 74/100. Verdict: PROCEED — demand signals are strong, differentiation is clear, and no-code tools remove the technical blocker.', 'openai/gpt-4o', 0.82, 'unreviewed', null),
  ('e1000000-0000-0000-0000-000000000003', null, 'c1000000-0000-0000-0000-000000000001', 3, 'final_report', 'Week 1–4: Interview 20 parents, build a landing page, collect 50 emails. Week 5–8: Launch $9/month pre-sell, target 30 paying users. Week 9–12: Onboard first cohort, ship MVP with 3 core meal plan types. Key metric: 30 pre-sales before writing a line of code.', 'openai/gpt-4o', 0.91, 'unreviewed', null)
on conflict (id) do nothing;

create table if not exists audit_log (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  session_id uuid,
  action text not null,
  tool_used text,
  input_summary text,
  output_summary text,
  risk_level text,
  status text,
  created_at timestamptz not null default now()
);
alter table audit_log enable row level security;
drop policy if exists "audit_log_v1_read" on audit_log;
create policy "audit_log_v1_read" on audit_log for select using (true);
drop policy if exists "audit_log_v1_write" on audit_log;
create policy "audit_log_v1_write" on audit_log for all using (true) with check (true);