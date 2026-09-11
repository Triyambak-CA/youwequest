# AGENTS.md

Contributor and AI-agent guide for the YouWe Quest LLP website.
Harness-neutral: Claude Code, Codex, opencode and any other agent should read this file first.
Codex and opencode read `AGENTS.md` natively. Claude Code reads `CLAUDE.md`, so the tracked `CLAUDE.md` is a stub that imports this file and, when present, `AGENTS.local.md`. Keep it a stub and put the content here.

## What this repo is

A static website for YouWe Quest LLP, a chartered accountancy firm in India. It is served by GitHub Pages on a custom domain and publishes regulatory compliance updates, RBI bulletin digests and macro reports.

Pure HTML, CSS and vanilla JS. No build step, no bundler, no package manager. To preview, open any HTML file in a browser or run `python3 -m http.server` from the repo root.

## Read this before changing anything

**Check whether `claude-docs/` exists in your working copy.**

If it is absent you are in a clone or a git worktree, and your scope is site code only: CSS, layout, navigation, accessibility, responsive behaviour, and index pages.

In that case, do not hand-create, regenerate, restyle or "fix" any of these:

- `updates/WeeklyUpdate_Web_v2_*.html`
- `rbi/RBIBulletin_*.html`
- `macro/MacroReport_*.html`

Those pages are produced by a local, human-supervised workflow that is not part of this repository. Editing one by hand puts it out of step with its source template, and the next run will overwrite your change.

**If you change shared CSS or anything in the design system below, say so explicitly in the pull request description.** The maintainer has to mirror that change into the local page templates by hand, or the next generated page silently reverts it. There are two of them, described under Design system.

## Layout

| Path | What it is |
|---|---|
| `index.html` | Home page. Sections include `#rbi-section` and `#updates-section`. |
| `updates/index.html` | Card index of every weekly regulatory update |
| `updates/WeeklyUpdate_Web_v2_<DD><Mon><YYYY>.html` | One weekly update issue (generated) |
| `updates/UPDATES_LOG.json` | Machine-readable index of issues. Keep it in step with the cards. |
| `rbi/index.html` | Card index of RBI bulletin digests |
| `rbi/RBIBulletin_<Mon><YYYY>.html` | One RBI digest (generated) |
| `macro/index.html` | Card index of macro reports |
| `macro/MacroReport_<DD><Mon><YYYY>.html` | One macro report (generated) |
| `CNAME` | Custom domain. Never edit or delete it. |

Each index page lists issues as cards in `.update-list`, newest first. On `updates/` and `rbi/`, exactly one card carries the `latest-chip` span, so when a new issue is added that chip moves to it.

`macro/` is an archived series: its chip reads "Final issue", the page carries an archived banner, and no new macro reports are produced now that the RBI Bulletin Digest in `rbi/` is the monthly publication. Never add a new card to `macro/index.html`.

## Design system

These hold across the site. Do not deviate without being asked:

- **Theme:** dark by default, with a light mode. Toggled by a button and stored in `localStorage` under the key `theme`, applied as a `data-theme` attribute on `<html>`. A small blocking script at the top of `<head>` reads that value before first paint so the page does not flash.
- **Gold accent:** `--gold:#B8963E` on every page. The classic template darkens it to `#8C6D1A` in light mode; the newspaper template keeps the one value in both.

Everything else belongs to one of two templates. Motion is the exception: background orbs and entry animation differ by page family, so read the file you are editing rather than assuming a pattern holds.

### Classic template

The home page, all three index pages, every RBI digest, every macro report, and weekly issues up to 10 Jul 2026.

- **Fonts:** Cormorant Garamond (serif, headings and brand) and DM Sans (body), plus DM Mono (code) everywhere except the macro reports. Loaded from Google Fonts.
- **Backgrounds:** dark `#070c12`, light `#f4f1eb`.
- **Macro accent:** `--macro:#5EBF8C` dark, `#1E7A50` light. Used throughout `macro/` and `rbi/`.
- **Domain colours** on `updates/index.html` and the classic weekly issues: GST gold, Direct Tax blue, MCA purple, SEBI orange-red, ICAI teal.

### Newspaper template

Weekly issues from 20 Jul 2026 onwards. These are not broken and are not a style drift to be corrected.

- **Fonts:** Archivo only.
- **Backgrounds:** light `#FBFAF7` as the `:root` default, dark `#111110` under `[data-theme="dark"]`.
- **Markup:** a masthead and column layout using `.mast-id`, `.kick` and the `.cd-*` classes.
- No domain colour variables and no orbs. Ink, rule and muted tones carry the structure instead.

## Rules

**Only files needed to serve the website belong in git.** Everything else stays on the maintainer's machine and is listed in `.gitignore`: workflow instructions, automation scripts, generation scripts, and all DOCX, PDF and message files.

**`AGENTS.md` and `CLAUDE.md` are tracked and published.** Anything written into either one is live on a public site. Local-only agent instructions belong in `AGENTS.local.md` or `CLAUDE.local.md`, both of which `.gitignore` keeps off GitHub. Never move private content into the tracked pair.

**Stage files by name.** Never `git add -A` and never `git add .`. Before staging anything, check it belongs to the site.

**Never push to `origin/main` directly.** Site changes go through the review gate on a branch and land as a pull request. GitHub Pages deploys from `main` automatically, so anything pushed there is live immediately.

**Never modify or delete `CNAME`.** It holds the custom domain and removing it takes the site offline.

**No em dashes or en dashes in new content.** Use a plain hyphen, including in ranges. Some older index pages still contain them; leave those alone rather than doing a cleanup pass just for dashes.

**Indian tax terminology must be correct.** AY and FY are different things, and it is a DTAA, not a "tax treaty".

## Full workflow

The complete operational workflow, including how issues are researched and generated, is local to the maintainer's machine and deliberately absent from this repository. If `claude-docs/`, `AGENTS.local.md` or `CLAUDE.local.md` are present in your working copy, read them. If they are not, everything you need is in this file.
