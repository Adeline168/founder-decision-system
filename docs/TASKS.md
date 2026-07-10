# Tasks & Sprints

## Sprint 1 — Database + Demo Shell (Days 1–2)
**Goal:** Schema live, seed data visible, homepage renders a real demo session without login.
- Create all Supabase tables + v1 open RLS policies
- Seed: 2 demo sessions across all three engines with sample AI outputs
- Build homepage that lists demo Decision Vault (read from DB, no auth)
- Build session detail page showing engine progress + report text
- Empty state: "No sessions yet — start your first decision"
- Loading + error states on all data fetches
**Definition of Done:** Visiting the homepage shows a real demo session with engine outputs pulled from the database. No login required. No dead links.

## Sprint 2 — Engine Question Flows (Days 3–5) ★ v1 functional
**Goal:** A visitor can walk through all three engines, save every answer, and trigger AI report generation.
- Engine 1 question flow (6 questions): saves each `engine_response` row on submit
- On Engine 1 complete: POST to `/api/generate/core-goal` → OpenAI → saves `ai_output`
- Engine 2 question flow (6 questions) + Goal Pathway report generation
- Engine 3 question flow (5 questions) + Blueprint30 + Final Report generation
- Progress bar + resume from last step (reads `current_engine` / `current_step`)
- Retry button if AI call fails (never a broken session)
- All five UI states per screen: loading / empty / partial / error / ready
**Definition of Done:** Starting from the homepage, a tester completes all three engines end-to-end, every answer persists in `engine_responses`, all four AI reports appear in `ai_outputs`, and the session status updates to `complete`.

## Sprint 3 — Credit Purchase + Session Creation (Days 6–7)
**Goal:** Paying creates an account, allocates credits, and opens a new session.
- Credit package selection page (Starter $49 / Builder $129 / Pro $199)
- Stripe Checkout integration (server-side session creation)
- Stripe webhook → `credit_ledger` row created; credits allocated
- Post-payment: account created (Supabase Auth email+password), session auto-started
- One credit deducted per new session (`credits_used++`, `credits_remaining--`)
- Error handling: webhook failure → alert builder; no silent credit loss
**Definition of Done:** Complete a real Stripe test-mode payment → account exists → credit_ledger shows correct balance → new decision_session row created → user lands on Engine 1 step 1.

## Sprint 4 — Decision Vault + PDF Download (Days 8–9)
**Goal:** All sessions and reports are permanently accessible and downloadable.
- Decision Vault page: list all user's sessions, status badges, engine progress
- Report detail view: Core Goal, Goal Pathway, Blueprint30, Final Report rendered
- PDF generation endpoint (Puppeteer serverless) → upload to Supabase Storage
- Signed URL download button (1-hour expiry)
- Empty vault state: prompt to purchase a credit
**Definition of Done:** After completing a session, the vault lists it; each report renders correctly; clicking Download produces a valid PDF from Storage without errors.

## Sprint 5 — Lock It Down (Day 10)
**Goal:** Real user data is owner-scoped; no cross-user data leakage.
- Replace v1 open RLS with `auth.uid() = user_id` owner policies on all tables
- Verify anonymous visitors can still view demo seed rows (public flag or separate demo table)
- Audit log reviewed — no unexpected open reads
- Stripe webhook confirms email match before writing to user's ledger
**Definition of Done:** User A cannot read or write User B's sessions, responses, or reports. Demo seed data remains publicly visible. All tests in TEST_PLAN.md pass.

## Gantt (by day)
```
Day 1-2   [Sprint 1] DB + Demo Shell
Day 3-5   [Sprint 2] Engine Flows + AI Reports  ← v1 functional
Day 6-7   [Sprint 3] Credit Purchase + Auth
Day 8-9   [Sprint 4] Vault + PDF Download
Day 10    [Sprint 5] Lock It Down
```
