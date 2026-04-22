# workflow-starter

## Context

Many users can complete one task with AI, but fail to chain tasks into a reusable workflow.

## Goal

Create a minimal reusable workflow starter that links:

1. input collection
2. transformation
3. output packaging

Target: first workflow run in <= 30 minutes.

## Scope (v0 skeleton)

- Input: user topic + source notes
- Process: normalize -> generate -> format
- Output: packaged folder with final artifacts

## Planned Deliverable

- `workflow.yml` (or equivalent process definition)
- `input/` sample files
- `output/` generated artifacts
- quickstart instructions

## Success Criteria

- User can run workflow without custom coding
- Workflow can be copied and adapted for another use case
- Output is structured and ready for publishing/archiving

## Next Implementation

1. Define baseline workflow schema
2. Add one runnable example flow
3. Add fork-and-customize guide
4. Add common failure troubleshooting
