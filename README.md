# Mind Vault

Personal defense against the [illusion of explanatory depth](https://thedecisionlab.com/biases/the-illusion-of-explanatory-depth): two Claude Code skills plus a versioned knowledge base of concepts I actually understand — deeply, mechanism-first, verified.

## What's inside

| Piece | Purpose |
|---|---|
| [`skills/deep-coach`](skills/deep-coach/SKILL.md) | Makes **me** explain a concept before Claude does. Scores my understanding 1–5, reports gaps, fills only what's missing, re-checks, and logs the curated explanation here. Auto-triggers on consequential decisions, strong claims, and new concepts; manual via `/coach`. Spaced re-review at +3/+7/+21 days. |
| [`skills/claim-validator`](skills/claim-validator/SKILL.md) | Every factual claim in Claude's answers is labeled ✅ verified (with source) / ⚠️ unverified (model memory) / ❌ conflicting sources. Important claims must be verified before they reach me. |
| [`knowledge/`](knowledge/INDEX.md) | One file per concept: the final, corrected system explanation. Index tracks level and review dates. Mirrored to a Notion page ("Mind Vault") for easy reading. |

## Install

```bash
git clone https://github.com/kietlecocodev/mind-vault.git ~/mind-vault
~/mind-vault/install.sh   # symlinks skills into ~/.claude/skills/
```

Restart your Claude Code session afterward.

## Why

Rozenblit & Keil (2002): we overestimate how well we understand things, and the only proven fix is producing an explanation ourselves. Receiving more information doesn't cure the illusion — so the coach makes me explain first, and the validator makes sure what the AI feeds me is labeled by how much it's been checked.
