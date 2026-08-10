---
name: pr
description: Commit the current work on a branch and open a pull/merge request. Use when the user says "open a PR", "make an MR", "ship this", "/pr", or asks to turn their working changes into a reviewable request. Drafts the title and description, gets user approval on the exact wording, then opens it with gh or glab depending on the remote.
---

# Open a PR / MR

## 1. Branch and commit

```bash
git status --short && git branch --show-current
```

- If changes are uncommitted: stage everything (`git add -A`) and commit.
- If the current branch is the default branch (`main`/`master`/`develop`), create a new branch first, named after the change (`fix-upload-timeout`, not `jsolon-patch-1`).
- If already on a feature branch with everything committed, skip to step 2.

Commit message: one imperative summary line. Body only if the why isn't obvious.

## 2. Draft the title and description

Read the actual diff against the base branch, not just file names:

```bash
git diff $(git merge-base HEAD origin/HEAD)...HEAD --stat
git diff $(git merge-base HEAD origin/HEAD)...HEAD
```

Write it for a busy colleague who will scan it in ten seconds.

**Title:** one line, plain language, says what changed.

**Description:** this shape, nothing more.

```markdown
<One or two sentences: what this does and why.>

## Changes
- `path/to/file.ts` — what changed here, in a few words
- `path/to/other.py` — what changed here
```

Rules:
- Simple words. No "leverages", "robust", "comprehensive", "seamlessly".
- One bullet per file or per tightly-grouped set of files. No sub-bullets.
- Skip lockfiles, generated files, and formatting-only churn — group them as one bullet: "- lockfile + formatting".
- No test plan, no screenshots section, no checklist, unless the repo has a PR template that asks for them (check `.github/PULL_REQUEST_TEMPLATE.md` or `.gitlab/merge_request_templates/`).
- Don't restate the diff line by line. If a bullet needs a sentence, the file did something non-obvious.

## 3. Get approval — do not skip

Show the user the exact title and description as it will appear. Ask them to approve or edit the wording.

**Do not run `gh pr create` or `glab mr create` before the user has approved.** If they edit it, show the revision and confirm again.

## 4. Open it

Detect the host from the remote:

```bash
git remote get-url origin
```

Push the branch, then:

**GitHub:**
```bash
git push -u origin HEAD
gh pr create --title "..." --body-file <file>
```

**GitLab:**
```bash
git push -u origin HEAD
glab mr create --title "..." --description "$(cat <file>)" --remove-source-branch
```

Write the body to a temp file rather than inlining it — backticks and newlines in shell arguments are a reliable way to mangle a description.

Report the resulting URL.
