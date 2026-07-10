# Architecture

## Stack
- **Frontend:** Next.js 14 (App Router) on Vercel
- **Backend/DB:** Supabase (Postgres + RLS + Storage)
- **Payments:** Stripe Checkout (webhooks allocate credits)
- **AI:** OpenAI GPT-4o via server-side API route (key never in client)
- **PDF:** react-pdf or Puppeteer serverless function

## Now vs Later
**Now:** credit purchase → session creation → three-engine question flows → AI report generation → Decision Vault view/download
**Later:** auth hardening (owner RLS), admin dashboard, referral codes, team seats

## Key User Action — Step by Step
1. Visitor lands on homepage (demo session visible, no login required)
2. Selects credit package → Stripe Checkout
3. Stripe webhook → server creates account (or matches existing), allocates credits
4. System deducts one credit, creates `decision_session` row
5. Founder answers Engine 1 questions; each answer saved to `engine_responses`
6. On Engine 1 completion, server calls OpenAI → saves `ai_output` (Core Goal)
7. Repeat for Engine 2 (Goal Pathway) and Engine 3 (Blueprint30 + Final Report)
8. Final Report triggers PDF generation → stored in Supabase Storage
9. Decision Vault renders all sessions and report download links

## Layer Order
1. **Data first** — tables, constraints, RLS policies
2. **App logic** — question flow, progress tracking, credit ledger
3. **Smart layer** — OpenAI calls, structured prompt templates, confidence scoring

## AI-Off Core
All question flows, progress saving, and vault display work without AI. AI calls produce reports but session state is DB-driven — a failed AI call shows a retry button, not a broken session.
