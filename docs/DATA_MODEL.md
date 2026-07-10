# Data Model

## users
| Field | Type |
|---|---|
| id | uuid PK |
| email | text unique not null |
| full_name | text |
| created_at | timestamptz |

## credit_packages
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| name | text | e.g. "Starter", "Builder", "Pro" |
| credits | int | 1 / 3 / 5 |
| price_usd_cents | int | 4900 / 12900 / 19900 |
| stripe_price_id | text | |
| created_at | timestamptz | |

## credit_ledger
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | FK → users |
| credits_purchased | int | |
| credits_used | int default 0 | |
| credits_remaining | int | computed or maintained |
| stripe_payment_intent | text | |
| package_id | uuid | FK → credit_packages |
| created_at | timestamptz | |

## decision_sessions
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| credit_ledger_id | uuid | FK → credit_ledger |
| business_idea | text | Founder's idea title |
| current_engine | int default 1 | 1, 2, or 3 |
| current_step | int default 0 | step index within engine |
| status | text | draft / in_progress / complete |
| created_at | timestamptz | |

## engine_responses
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| session_id | uuid | FK → decision_sessions |
| engine_number | int | 1, 2, or 3 |
| question_key | text | e.g. "strengths", "constraints" |
| response_text | text | |
| created_at | timestamptz | |

## ai_outputs
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| session_id | uuid | FK → decision_sessions |
| engine_number | int | |
| report_type | text | core_goal / goal_pathway / blueprint30 / final_report |
| value | text | AI-generated content |
| source | text | e.g. "openai/gpt-4o" |
| confidence | numeric | 0–1 score from prompt response |
| review_status | text default 'unreviewed' | unreviewed / approved / flagged |
| pdf_url | text nullable | Supabase Storage path |
| created_at | timestamptz | |

## RLS Notes
- v1: permissive open policies on all tables (demo-first)
- Lock-down sprint: replace with `auth.uid() = user_id` owner policies
- `credit_packages` is read-only public; write only via service role
