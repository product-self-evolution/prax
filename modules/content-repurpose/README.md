# content-repurpose

## Context

Solo creators often write one long-form piece, but distribution requires multiple platform formats.

## Goal

Convert one source content piece into platform-ready variants:

- short post
- long article draft
- video script outline

Target: first usable multi-format output in <= 30 minutes.

## Scope (v0 skeleton)

- Input: one markdown/article source
- Process: transform with style constraints
- Output: 3 variant files

## Planned Deliverable

- `input/source.md`
- `output/xiaohongshu.md`
- `output/wechat.md`
- `output/video-script.md`

## Success Criteria

- User can produce three formats from one source
- Each format follows platform style constraints
- User can publish with minimal manual edits

## Next Implementation

1. Define transformation prompt pack
2. Add style constraints per format
3. Add generation steps and output samples
4. Add quality checklist before publish
