# Agentic Layer

## Risk Levels & Actions

### Low Risk — Auto-execute
- `generate_core_goal_report` — summarise Engine 1 responses, produce Core Goal text
- `generate_goal_pathway_report` — analyse Engine 2 responses, produce pathway + verdict
- `generate_blueprint30_report` — produce 30/90-day plan from Engine 3 responses
- `tag_session_status` — update `decision_sessions.status` after each engine completes
- `score_readiness` — compute numeric readiness score from structured responses

### Medium Risk — Confirm before execute
- `generate_final_report_pdf` — triggers PDF render + Storage upload (costs compute)
- `send_report_ready_email` — sends email with vault link (v2)

### High Risk — Always requires approval
- `allocate_credits` — writing to `credit_ledger` after Stripe webhook (server-side only, webhook signature verified)

### Critical — Human only
- Issuing refunds (Stripe dashboard)
- Deleting a session or vault data on user request
- Any bulk data export

## Named Tools (v1)
- `openai_chat_completion` — structured prompt → report text
- `supabase_insert` — persist responses and outputs
- `stripe_checkout_session_create` — initiate payment
- `pdf_render` — serverless Puppeteer function

## Audit Log Fields
`id, session_id, user_id, action, tool_used, input_summary, output_summary, risk_level, status, created_at`

## v1 vs Later
- **v1:** auto-generate reports; human-only refunds
- **Later:** email delivery agent; contradiction-alert agent; re-run engine on founder request
