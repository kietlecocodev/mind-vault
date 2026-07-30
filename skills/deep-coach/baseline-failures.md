# Baseline failures — live session 2026-07-30 (RED phase)

First real coaching session (topic: "paywall của iOS đặc biệt là trên điện thoại") produced these violations. Skill edits must counter each one. Kept as regression reference.

## F1 — Gap-fill asserted unverified claims without labels

Coach step 4 stated "nút Restore Purchases bắt buộc phải có" as flat fact. Not verified against App Review Guidelines in-session; nuance exists (StoreKit 2 auto-syncs entitlements, `AppStore.sync()` is the manual path). Some claims got ⚠️ (commission %) but others didn't — inconsistent labeling inside coach output.

**Rationalization used:** "this is canonical/stable knowledge, labeling is noise."

## F2 — Knowledge file logged memory claims as unlabeled fact

`ios-paywall-iap.md` recorded grace period, `revocationDate`, Family Sharing, sandbox behavior with no verification labels. A persisted file is re-read later as truth — worse than an unlabeled chat claim.

**Rationalization used:** "the file is a curated summary, labels belong in conversation."

## F3 — No depth audit before logging (illusion of levels inside the vault)

File said "app verify chữ ký JWS" without the mechanism (x5c chain → Apple Root CA, `VerificationResult`). The knowledge base itself committed the level-3 error it exists to fix. Nothing in the flow forced a "can this file answer HOW one level deeper?" check.

## F4 — Topic scope drift, silently

User asked about "paywall" — coaching covered IAP plumbing only; paywall-as-UX (hard/soft, trials, placement) was never mentioned as dropped. User discovered the gap themselves.

**Rationalization used:** "the mechanism question I asked was the core of the topic."
