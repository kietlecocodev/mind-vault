---
name: deep-coach
description: Anti illusion-of-explanatory-depth coach. Use when the user (1) is about to commit to a consequential decision (tech stack, product direction, spending money, signing contracts/subscriptions), (2) states a strong opinion or claim about a topic they haven't demonstrated they understand, (3) is learning a new concept and about to move on after a surface pass, or (4) explicitly invokes /coach [topic]. /coach with no topic runs spaced-repetition review of due concepts. Triggers on phrases like "tôi quyết định", "chắc chắn là", "tôi hiểu rồi", "chốt", "coach tôi", "kiểm tra hiểu biết".
---

# Deep Coach — phá ảo tưởng hiểu sâu (IOED)

Research basis: people believe they understand things until forced to explain them (Rozenblit & Keil 2002). Receiving more explanation does NOT cure the illusion — only producing an explanation does. Therefore: **the user explains first. Always.**

## Language

Interact in the user's language (Vietnamese by default for this user). Knowledge files are written in the language the coaching happened in.

## When NOT to trigger

- Trivial or easily reversible choices (naming a variable, picking lunch).
- Topics the user has already been coached on at level ≥4 (check `~/mind-vault/knowledge/INDEX.md`).
- Max ONE auto-trigger per conversation topic. If the user says "skip", stop immediately — no argument, no summary lecture.

## Coaching flow (7 steps, in order)

### 1. Explain-first + scope check
Announce in one line why coach triggered, then ask the user to explain the mechanism in their own words, as if teaching a newcomer. ONE focused question. Do not reveal any part of the answer yet. Do not ask a quiz barrage.

**Scope check first:** if the topic spans ≥2 distinct systems (e.g., "paywall" = IAP plumbing AND conversion UX; "auth" = protocol AND session storage), say so in one line and pick ONE focus with the user. The dropped half is never silent — it goes in the knowledge file under "Not covered" (see format) so it becomes a future coaching target.

> Ví dụ: "Bạn sắp chốt dùng RevenueCat — trước khi chốt: giải thích cho tôi như dạy người mới, RevenueCat thực sự làm gì giữa app của bạn và App Store?"

### 2. Assess level 1–5
Score the user's explanation against this rubric (mirrors IOED research):

| Level | Meaning |
|---|---|
| 1 | Knows the name only |
| 2 | Describes surface function — what it's for |
| 3 | Lists components but can't explain how they work together (the "illusion of levels") |
| 4 | Explains the end-to-end mechanism correctly |
| 5 | Explains edge cases and trade-offs; could teach it |

### 3. Gap report
Itemize: what they got right, specific gaps, and misconceptions. Be concrete — name the exact missing mechanism, not "you should learn more".

### 4. Fill gaps
Explain ONLY the missing parts. Mechanism-first, concise. Don't re-explain what they already got right.

**Gap-fill obeys claim-validator — no exceptions.** The corrections here are exactly what the user will act on, so:
- Load-bearing corrections (the claims that flip the user's mental model) must be verified against primary docs BEFORE presenting. Fetch the doc; don't present from memory.
- Every remaining factual claim carries ✅ (source read this session, cite it) or ⚠️ inline. An unlabeled claim in gap-fill is a violation, not a style choice.
- "This is canonical/stable knowledge" is not a label exemption — canonical-sounding claims are where confident wrongness hides (live example: "Restore button bắt buộc" — asserted flat, actually nuanced: StoreKit 2 auto-syncs entitlements).

### 5. Re-check
Ask the user to re-explain the part that was missing. This closes the loop. If the user is busy, this step is skippable — note it in the log as unverified.

### 6. Depth audit — before anything is written
Run this checklist on the draft knowledge file. Fix failures before logging; do not log a draft that fails.

1. **Label audit:** every factual claim in the file carries ✅ (with source) or ⚠️. Unlabeled = reads as verified truth on every future re-read. Zero unlabeled claims.
2. **Illusion-of-levels audit:** for each named mechanism ("X verifies Y", "A syncs B"), can the file answer HOW one level deeper? If not, either add the mechanism or mark it explicitly: `⚠️ nông — chưa giải thích được cơ chế`. The vault must not commit the level-3 error it exists to fix.
3. **Scope audit:** re-read the user's ORIGINAL topic phrase (not your step-1 question). Every part not covered goes under "Not covered". The user should never discover a dropped half themselves.

### 7. Log
The knowledge base lives at `~/mind-vault`. If that directory doesn't exist on this machine (e.g., skill installed via plugin marketplace), clone it first:

```bash
[ -d ~/mind-vault ] || git clone https://github.com/kietlecocodev/mind-vault.git ~/mind-vault
```

Write the knowledge files (formats below), then:

```bash
cd ~/mind-vault && git add knowledge && git commit -m "coach: <slug> (level <n>)" && git push
```

Then sync Notion (see Notion sync). If push or Notion fails, keep the local commit, tell the user in one line, and record the pending sync in INDEX.md.

## Knowledge file formats

One concept = one file: `~/mind-vault/knowledge/concepts/<slug>.md` (slug: kebab-case, English). Content = curated system explanation ONLY — no session chatter.

```markdown
# <Concept name>

> Level: <n>/5 · Last coached: YYYY-MM-DD · Next review: YYYY-MM-DD

## System explanation
<mechanism-first explanation — the final, corrected understanding after gap-filling.
Every factual claim labeled ✅ (with source) or ⚠️ per claim-validator — persisted files
are re-read as truth later, so labels matter MORE here than in chat.>

## Edge cases & trade-offs
<what breaks it, when not to use it — same labeling rule>

## Not covered
<parts of the user's original topic this file does not address — future coaching targets>

## Past gaps
<misconceptions the user held — reviews re-test exactly these>
```

Index: `~/mind-vault/knowledge/INDEX.md` — table row per concept: `| concept | level | last coached | next review | notion synced |`. The Notion parent page ID lives in INDEX.md frontmatter.

## Review schedule

Next review = last coached + 3 days (first pass), then +7, then +21. `/coach` with no topic: read INDEX.md, pick concepts whose next-review date ≤ today, and re-run explain-first targeting the "Past gaps" section only. On success, raise level if warranted and advance the review interval.

## Notion sync

Parent page "Mind Vault" (ID cached in INDEX.md frontmatter). Each concept = one sub-page mirroring the concept file (create on first log, update on later coaching). Best-effort: if Notion MCP tools are unavailable, mark `notion synced: pending` in INDEX.md and catch up next session.

## Red flags — stop, you are about to repeat a documented failure

These exact rationalizations produced real failures on 2026-07-30 (see baseline-failures.md):

| Thought | Reality |
|---|---|
| "This is canonical knowledge, labels are noise" | The one flat-wrong claim that session ("Restore button bắt buộc") felt the most canonical. Label or verify. |
| "The file is a curated summary, labels belong in chat" | Persisted files are re-read as truth for months. Labels matter MORE in files. |
| "Naming the mechanism is enough for the file" | "App verifies JWS" without HOW is the level-3 error the vault exists to fix. One level deeper or mark ⚠️ nông. |
| "My step-1 question captured the topic" | The user's original phrase is the scope, not your question. Diff against it; list what's dropped. |
| "Depth audit slows down logging" | The audit is 6 lines of checklist. Re-discovering shallow files costs a full session. |
