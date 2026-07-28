# Instructions for AI assistants generating STOS Basic

This content has moved into two agent skills:

- `.agents/skills/stos-syntax/` - language rules, editorial policy, and the
  full STOS manual knowledge base (in its `reference/` directory)
- `.agents/skills/stos-workflow/` - the edit -> sync -> run -> debug loop

If your runtime does not auto-discover `.agents/skills/`, read those two
SKILL.md files directly before writing STOS code. The canonical sources the
skills are built from are `docs/stos-manual/`, `docs/stos-cheatsheet.md`, and
`scripts/`; re-sync with `scripts/build-skills.sh`.
