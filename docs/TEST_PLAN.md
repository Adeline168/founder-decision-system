# Test Plan

## End-to-End Success Scenario
1. Visit homepage (no login) → demo session visible with engine outputs → PASS if page loads < 3s with real DB data
2. Click "Start a New Decision" → land on credit package page → PASS if all 3 packages display with correct prices
3. Select Starter ($49) → Stripe test-mode checkout → complete payment with card `4242 4242 4242 4242`
4. Post-payment redirect → account created, inbox has confirmation, vault opens with 1 credit → PASS if `credit_ledger.credits_remaining = 1`
5. New session auto-created → Engine 1 Step 1 renders first question → PASS if `decision_sessions` row exists with `status = in_progress`
6. Answer all 6 Engine 1 questions → submit → spinner → Core Goal report appears → PASS if `ai_outputs` row with `report_type = core_goal` exists
7. Continue to Engine 2, answer 6 questions → Goal Pathway report generated → PASS
8. Continue to Engine 3, answer 5 questions → Blueprint30 + Final Report generated → session `status = complete` → PASS
9. Navigate to Decision Vault → session listed → click Final Report → report renders fully → PASS
10. Click Download PDF → file downloads, opens correctly, contains founder's answers and all reports → PASS

## Empty / Error Cases
| Scenario | Expected behaviour |
|---|---|
| User visits vault with no sessions | Empty state: "Purchase a credit to begin" with CTA |
| OpenAI call times out | Retry button shown; session not corrupted; `current_step` unchanged |
| Stripe webhook arrives twice | Idempotency key prevents double credit allocation |
| User tries to start session with 0 credits | Blocked at UI + server; redirected to purchase page |
| PDF generation fails | Error message in vault; retry option; no broken download link |
| User refreshes mid-engine | Resumes at last saved step; no answers lost |
| User A accesses User B's session URL (post lock-down) | 403 returned; no data exposed |
