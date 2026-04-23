# Contributing to Prax

Thanks for helping build Prax. Prax is an **enterprise-grade AI Agent template library** for in-role knowledge workers. Every contribution should push the project closer to this goal.

## Contribution Principles

- **Action over theory**: every contribution should improve real deploy-ability
- **Low friction**: docs and steps must stay copy-paste runnable
- **Reusable by default**: templates must be fork-friendly and configurable
- **Explain the why**: avoid black-box instructions, show reasoning
- **Enterprise sense over toy demos**: every module must map to a real business scenario

## Where to Contribute First

1. **New Agent templates** — propose a business scenario not yet covered
2. **Existing module quality** — fix bugs, improve clarity, add failure cases
3. **Platform compatibility** — port existing templates to Coze / n8n
4. **Deployment guides** — improve `docs/deployment.md` with your real-world experience
5. **Case studies** — share your production deployment story

## Development Flow

1. Fork this repository
2. Create branch (`feat/<topic>` or `fix/<topic>` or `docs/<topic>`)
3. Make focused changes (one PR = one topic)
4. Run the self-check (see `docs/governance/module-quality-checklist.md`)
5. Open a Pull Request using the template
6. Respond to review feedback within 7 days

## Module Quality Bar

All new modules must pass the quality checklist in:

**[`docs/governance/module-quality-checklist.md`](docs/governance/module-quality-checklist.md)**

Core requirements at a glance:

- Minimum deliverables: `README.md`, `configs/`, `prompts/`, `workflow/`, `docs/deployment.md`, `output/*.sample.md`
- README must include all standard sections (Business Scenario, Architecture, Prerequisites, Quick Start, DoD, etc.)
- Pass the 5-dimension quality review: Clarity, Runability, Security, Portability, Maintainability
- No hardcoded credentials (all via `_env` references)
- Business scenario must be concrete (not "general AI helper")

New modules enter as `tier: experimental`. They can be promoted to `recommended` / `official` after real-world validation.

## Testing Contributions

Before opening a PR, validate your module by:

1. Running through `docs/testing/first-run-checklist.md` on a clean machine
2. Recording your DT (Deploy Time) and confirming it is <= 30 minutes
3. Having at least one other person try the deployment

## Commit Message Convention

Use imperative and scope:

- `feat(module): add ai-digest module skeleton`
- `docs(readme): clarify quick start`
- `fix(template): correct path in module template`

## Pull Request Expectations

- Explain what changed and why
- Link related issue if available
- Include before/after behavior
- Keep PR small and reviewable

## Code of Conduct

By participating, you agree to follow `CODE_OF_CONDUCT.md`.
