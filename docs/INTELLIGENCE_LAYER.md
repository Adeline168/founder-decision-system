# Intelligence Layer

## Messy Inputs
Founders submit free-text answers to 6–10 questions per engine (strengths, constraints, competing ideas, goals, market, risks, readiness, etc.). Answers are often vague, contradictory, or overly broad.

## Auto-Structure Schema (Engine 1 example)
```json
{
  "session_id": "uuid",
  "engine": 1,
  "extracted": {
    "primary_strength": "string",
    "top_constraint": "string",
    "competing_ideas": ["string"],
    "stated_goal": "string",
    "recommended_direction": "string"
  },
  "confidence": 0.84,
  "source": "openai/gpt-4o",
  "review_status": "unreviewed"
}
```

## Events to Track
- Engine question answered
- Engine completed
- AI report generated (with latency + token count)
- Report downloaded
- Session resumed after gap

## Scoring Rules (rule-based v1, AI-assisted later)
- **Readiness score** (Engine 2): weighted sum of demand + feasibility + differentiation answers (0–100)
- **Direction confidence**: count of non-contradictory answers / total answers
- **Proceed / Validate / Pivot / Stop** verdict: rule thresholds on readiness score

## What Gets Ranked
- Competing business ideas ranked by strength-fit score
- Pathways ranked by feasibility × demand × founder readiness

## v1 vs Later
- **v1:** Structured prompt → GPT-4o → store raw + parsed JSON output
- **Later:** Fine-tuned scoring model; contradiction detection; benchmark against past sessions
