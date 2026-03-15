# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Static website for **YouWe Quest LLP** (a CA firm), hosted on GitHub Pages at a custom domain. It publishes weekly regulatory compliance updates covering GST, Direct Tax, MCA, SEBI, and ICAI.

No build tools, bundlers, or package managers — pure HTML/CSS/JS. To preview, open any HTML file directly in a browser or use a local static server (e.g. `python3 -m http.server`).

## Site Structure

- `index.html` — Main landing/home page
- `updates/index.html` — Index listing all weekly update issues (cards linking to individual pages)
- `updates/WeeklyUpdate_Web_v2_<DD><Mon><YYYY>.html` — Individual weekly update pages
- `macro/index.html` — Index listing all macro/market event reports (cards linking to individual pages)
- `macro/MacroReport_<DD><Mon><YYYY>.html` — Individual macro report pages (use `macro/index.html` as template)

## Adding a New Macro Report

1. Create a new file in `macro/` following the naming convention `MacroReport_<DD><Mon><YYYY>.html`. Use the weekly update page as a structural template, but adapt it with the green macro accent (`--macro:#5EBF8C` dark / `#1E7A50` light).
2. Add a new card entry in `macro/index.html` at the top of the `.update-list` (before the empty-state div or after the year divider), and move the `latest-chip` span to the new card. Remove the `empty-state` div once the first report is added.

## Adding a New Weekly Update

1. Create a new file in `updates/` following the naming convention `WeeklyUpdate_Web_v2_<DD><Mon><YYYY>.html`, using an existing update file as the template.
2. Add a new card entry in `updates/index.html` at the top of the `.update-list` (after the year divider), and move the `latest-chip` span to the new card.

## Weekly Update Page — Interactive Chips

The summary chips (GST / Direct Tax / MCA / SEBI / ICAI / Actions) at the top of each update page are clickable:
- Each domain chip calls `scrollToSection('sec-<domain>')` and scrolls to its corresponding section in the Summary tab.
- The Actions chip calls `switchTab('actions', ...)` to switch to the Action Items tab.
- Each summary section `<div>` must carry the matching `id`: `sec-gst`, `sec-dt`, `sec-mca`, `sec-sebi`, `sec-icai`.
- The `scrollToSection` helper offsets for the sticky nav height to prevent section headers being hidden. Always include it when using the template.

### Adding a New Domain Category (e.g. Labour Law)

Do all of the following when adding a new domain:

1. **CSS variable** — add `--<domain>` colour in both `:root` (dark) and `[data-theme="light"]`:
   ```css
   --labour:#82C891;   /* :root */
   --labour:#2A7A3A;   /* [data-theme="light"] */
   ```

2. **Domain pill** — add `.p-<domain>` alongside `.p-gst`, `.p-dt` etc.:
   ```css
   .p-labour{color:var(--labour);border-color:rgba(130,200,145,0.35);background:rgba(130,200,145,0.07)}
   ```

3. **Technical tab border** — add `.b-<domain>` alongside `.b-gst`, `.b-dt` etc.:
   ```css
   .b-labour{border-color:var(--labour)}
   ```

4. **Chip** — add to the `.chips` div with matching onclick:
   ```html
   <div class="chip" onclick="scrollToSection('sec-labour')">
     <div class="chip-n" style="color:var(--labour)">0</div>
     <div class="chip-l">Labour Law</div>
   </div>
   ```

5. **Chip grid column count** — update the hardcoded column count in `.chips` (e.g. 6 → 7) and the mobile breakpoint grid if needed:
   ```css
   .chips{grid-template-columns:repeat(7,1fr)...}
   ```

6. **Summary section** — add with the matching `id`:
   ```html
   <div id="sec-labour" class="sec s6">
     <div class="sec-hd"><span class="dpill p-labour">Labour Law</span><h2 class="sec-title">...</h2></div>
     <div class="gc"><div class="entries">
       <!-- entry divs here -->
     </div></div>
   </div>
   ```

7. **No JS changes needed** — `scrollToSection` works automatically for any id.

## Design System

All pages share the same CSS design language — do not deviate from it:

- **Fonts**: `Cormorant Garamond` (serif, headings/brand) · `DM Sans` (body) · `DM Mono` (loaded but available for code)
- **Theme**: Dark (`#070c12` bg) / Light (`#f4f1eb` bg), toggled via a button and persisted in `localStorage` under the key `theme`. Applied via `data-theme` attribute on `<html>`. A blocking inline `<script>` at the top of `<head>` reads localStorage to set the theme before paint (avoids flash).
- **Gold accent**: `--gold: #B8963E` (dark) / `#8C6D1A` (light)
- **Domain badge colours** (CSS vars, shift in light mode):
  - GST → gold, DT → blue, MCA → purple, SEBI → orange-red, ICAI → teal
- **Macro accent**: `--macro:#5EBF8C` (dark) / `#1E7A50` (light) — used exclusively in `macro/` pages and the `#macro-section` on the home page
- **Animated background**: Three blurred `.orb` divs (fixed, `z-index:0`), content sits at `z-index:1`
- **Motion**: `fadeUp` keyframe animation on cards/sections using `animation-delay` for stagger

## Deployment

Pushing to `main` deploys automatically via GitHub Pages. The custom domain is configured via the `CNAME` file — do not delete or modify it.
