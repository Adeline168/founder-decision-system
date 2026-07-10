# Security

## Secret Handling
- `OPENAI_API_KEY`, `STRIPE_SECRET_KEY`, `SUPABASE_SERVICE_ROLE_KEY` — server-side env vars only; never referenced in client bundles
- Stripe webhook validates `stripe-signature` header before any credit allocation
- PDF generation runs in a serverless function with no client access

## Permission Model (v1 → lock-down)
- **v1 demo:** open RLS policies — all tables readable/writable by anyone (safe because no real PII at demo stage)
- **Lock-down sprint:** replace with `auth.uid() = user_id`; service-role key used only in server routes
- `credit_packages` writable only via service role (never from client)
- `ai_outputs.pdf_url` signed URLs (Supabase Storage) expire in 1 hour

## Approved Tools Rule
- AI agent may only call named tools listed in `AGENTIC_LAYER.md`
- No `eval`, `exec`, raw SQL from client, or open-ended HTTP from agent
- Every tool call is logged to `audit_log` before and after execution

## Audit Principle
- Every credit allocation, AI generation, PDF render, and report download writes an audit row
- Audit rows are append-only (no update/delete policy, even for admins in v1)
- Builder reviews audit log weekly until lock-down sprint ships
