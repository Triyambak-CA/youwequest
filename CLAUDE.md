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
- `macro/MacroReport_<DD><Mon><YYYY>.html` — Individual macro report pages

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

---

## Monthly Macro Report — Deployment Workflow

This section describes how to take the HTML file generated by the `macro-monthly-report` Claude.ai skill and deploy it to the site.

### Trigger phrase
When Triyambak says anything like:
- "deploy the macro report"
- "upload the macro report"
- "add the macro report to the site"
- "publish the [month] macro report"

Follow this workflow exactly.

---

### Step 1 — Receive the source file

The skill generates a file named `[Month]_[Year]_Macro_Report.html` (e.g. `April_2026_Macro_Report.html`).
Triyambak will either paste the path or upload the file. Read it fully before proceeding.

---

### Step 2 — Determine the output filename

Convert to the site naming convention:
- Source: `April_2026_Macro_Report.html`
- Output: `macro/MacroReport_30Apr2026.html`

Use the last day of the report month as the date (e.g. April → 30, March → 31, February → 28/29).
If Triyambak specifies a different date, use that instead.

---

### Step 3 — Adapt the HTML to the site design system

The skill output uses generic CSS variables from the claude.ai widget environment.
You must rewrite it as a standalone site page matching the YouWe Quest design system.

#### Page shell (required wrapper for every macro report page)

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>India Macro Report — [Month] [Year] | YouWe Quest</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600&family=DM+Sans:wght@300;400;500&family=DM+Mono&display=swap" rel="stylesheet">
  <script>
    /* Theme restore — must run before paint */
    (function(){
      var t=localStorage.getItem('theme')||'dark';
      document.documentElement.setAttribute('data-theme',t);
    })();
  </script>
  <style>
    /* === Site-wide CSS variables === */
    :root {
      --bg: #070c12;
      --bg2: #0d1520;
      --bg3: #111d2b;
      --text: #e8dfc8;
      --text2: #9aabb8;
      --text3: #5c7080;
      --border: rgba(184,150,62,0.15);
      --gold: #B8963E;
      --macro: #5EBF8C;
      --macro-dim: rgba(94,191,140,0.12);
      --macro-border: rgba(94,191,140,0.25);
    }
    [data-theme="light"] {
      --bg: #f4f1eb;
      --bg2: #ede9e0;
      --bg3: #e6e1d6;
      --text: #1a1410;
      --text2: #4a4030;
      --text3: #8a7a60;
      --border: rgba(140,109,26,0.15);
      --gold: #8C6D1A;
      --macro: #1E7A50;
      --macro-dim: rgba(30,122,80,0.08);
      --macro-border: rgba(30,122,80,0.2);
    }

    /* === Reset & base === */
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html { scroll-behavior: smooth; }
    body {
      background: var(--bg);
      color: var(--text);
      font-family: 'DM Sans', sans-serif;
      font-size: 15px;
      line-height: 1.65;
      min-height: 100vh;
      overflow-x: hidden;
    }

    /* === Animated orb background === */
    .orb {
      position: fixed; border-radius: 50%;
      filter: blur(80px); opacity: 0.18; z-index: 0; pointer-events: none;
    }
    .orb1 { width: 600px; height: 600px; background: var(--macro); top: -200px; right: -100px; }
    .orb2 { width: 400px; height: 400px; background: var(--gold); bottom: 10%; left: -150px; opacity: 0.10; }
    .orb3 { width: 300px; height: 300px; background: var(--macro); top: 50%; left: 40%; opacity: 0.08; }

    /* === Nav === */
    .nav {
      position: sticky; top: 0; z-index: 100;
      display: flex; align-items: center; justify-content: space-between;
      padding: 0.75rem 2rem;
      background: rgba(7,12,18,0.85);
      backdrop-filter: blur(12px);
      border-bottom: 1px solid var(--border);
    }
    [data-theme="light"] .nav { background: rgba(244,241,235,0.88); }
    .nav-brand {
      font-family: 'Cormorant Garamond', serif;
      font-size: 1.1rem; font-weight: 600;
      color: var(--text);
      text-decoration: none;
      display: flex; align-items: center; gap: 0.5rem;
    }
    .nav-brand span { color: var(--macro); }
    .nav-right { display: flex; align-items: center; gap: 1rem; }
    .nav-back {
      font-size: 0.8rem; color: var(--text2);
      text-decoration: none; border: 1px solid var(--border);
      padding: 0.3rem 0.75rem; border-radius: 20px;
      transition: color 0.2s, border-color 0.2s;
    }
    .nav-back:hover { color: var(--macro); border-color: var(--macro-border); }
    .theme-toggle {
      display: flex; align-items: center; justify-content: center;
      width: 32px; height: 32px; border-radius: 8px;
      border: 1px solid var(--border); background: transparent;
      cursor: pointer; color: var(--text2); transition: all 0.2s;
      flex-shrink: 0; padding: 0;
    }
    .theme-toggle:hover { border-color: var(--macro-border); color: var(--macro); background: var(--macro-dim); }
    .theme-toggle svg { width: 15px; height: 15px; }
    [data-theme="light"] .theme-toggle { border-color: rgba(0,0,0,0.14); }
    [data-theme="light"] .theme-toggle:hover { border-color: rgba(30,122,80,0.45); color: var(--macro); background: var(--macro-dim); }

    /* === Page wrapper === */
    .page { position: relative; z-index: 1; max-width: 960px; margin: 0 auto; padding: 2rem 1.5rem 4rem; }

    /* === Cover header === */
    .cover {
      margin-bottom: 2.5rem;
      padding-bottom: 1.5rem;
      border-bottom: 1px solid var(--border);
    }
    .cover-eyebrow {
      font-size: 0.7rem; font-weight: 500; letter-spacing: 0.1em;
      text-transform: uppercase; color: var(--macro);
      margin-bottom: 0.5rem;
    }
    .cover-title {
      font-family: 'Cormorant Garamond', serif;
      font-size: 2rem; font-weight: 500; line-height: 1.2;
      color: var(--text); margin-bottom: 0.4rem;
    }
    .cover-sub { font-size: 0.85rem; color: var(--text2); margin-bottom: 1rem; }
    .cover-badges { display: flex; flex-wrap: wrap; gap: 0.5rem; }
    .badge {
      font-size: 0.7rem; font-weight: 500; padding: 0.2rem 0.65rem;
      border-radius: 20px; border: 1px solid var(--border); color: var(--text3);
    }
    .badge-trig {
      border-color: var(--macro-border);
      background: var(--macro-dim); color: var(--macro);
    }

    /* === Tab navigation === */
    .tabs-wrap { margin-bottom: 1.75rem; }
    .tab-group { display: flex; gap: 0.4rem; flex-wrap: wrap; align-items: center; margin-bottom: 0.4rem; }
    .tab-grp-label {
      font-size: 0.65rem; font-weight: 500; text-transform: uppercase;
      letter-spacing: 0.06em; color: var(--text3); min-width: 52px; padding-top: 4px;
    }
    .tab {
      padding: 0.25rem 0.85rem; border-radius: 20px; font-size: 0.75rem;
      cursor: pointer; border: 1px solid var(--border);
      background: transparent; color: var(--text2);
      font-family: 'DM Sans', sans-serif;
      transition: all 0.15s;
    }
    .tab:hover { border-color: var(--macro-border); color: var(--macro); }
    .tab.active {
      background: var(--bg3); color: var(--text);
      border-color: rgba(184,150,62,0.3); font-weight: 500;
    }
    .tab.india { border-color: var(--macro-border); color: var(--macro); }
    .tab.india.active { background: var(--macro-dim); color: var(--macro); border-color: var(--macro); }
    .tab.triggered { border-style: dashed; }

    /* === Sections === */
    .sec { display: none; animation: fadeUp 0.3s ease both; }
    .sec.active { display: block; }
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(10px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* === Section header === */
    .sec-head { display: flex; align-items: baseline; gap: 0.6rem; flex-wrap: wrap; margin-bottom: 0.4rem; }
    .sec-num { font-size: 0.7rem; color: var(--text3); }
    .sec-title { font-family: 'Cormorant Garamond', serif; font-size: 1.25rem; font-weight: 500; color: var(--text); margin: 0; }
    .sec-pill {
      font-size: 0.7rem; font-weight: 500; padding: 0.15rem 0.6rem;
      border-radius: 10px;
    }
    .pill-amber { background: rgba(184,150,62,0.12); border: 1px solid rgba(184,150,62,0.3); color: var(--gold); }
    .pill-green { background: var(--macro-dim); border: 1px solid var(--macro-border); color: var(--macro); }
    .pill-red { background: rgba(200,50,50,0.08); border: 1px solid rgba(200,50,50,0.25); color: #d45050; }
    .pill-blue { background: rgba(55,138,221,0.08); border: 1px solid rgba(55,138,221,0.25); color: #378ADD; }
    .sec-desc { font-size: 0.82rem; color: var(--text2); line-height: 1.6; margin: 0.5rem 0 0.875rem; }

    /* === Metric cards === */
    .metrics { display: grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap: 10px; margin: 0.875rem 0; }
    .metrics-4 { grid-template-columns: repeat(4, minmax(0,1fr)); }
    .metric {
      background: var(--bg2); border-radius: 8px; padding: 0.875rem;
      border: 1px solid var(--border);
    }
    .metric-label { font-size: 0.7rem; color: var(--text2); margin-bottom: 3px; }
    .metric-value { font-size: 1.15rem; font-weight: 500; color: var(--text); }
    .metric-sub { font-size: 0.7rem; color: var(--text3); margin-top: 2px; }
    .mv-red { color: #d45050; }
    .mv-green { color: var(--macro); }
    .mv-amber { color: var(--gold); }

    /* === Bullet list === */
    .blist { list-style: none; padding: 0; margin: 0.5rem 0 0.875rem; }
    .blist li {
      display: flex; gap: 8px; align-items: flex-start;
      padding: 5px 0; border-bottom: 1px solid var(--border);
      font-size: 0.82rem; color: var(--text2); line-height: 1.5;
    }
    .blist li:last-child { border-bottom: none; }
    .dot { width: 5px; height: 5px; border-radius: 50%; margin-top: 5px; flex-shrink: 0; }
    .dot-r { background: #d45050; }
    .dot-g { background: var(--macro); }
    .dot-a { background: var(--gold); }

    /* === Chart legend === */
    .chart-legend { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 5px; }
    .chart-legend span { display: flex; align-items: center; gap: 4px; font-size: 0.7rem; color: var(--text2); }
    .chart-legend i { display: inline-block; width: 14px; height: 2px; border-radius: 1px; }

    /* === India impact callout === */
    .india-box {
      border-left: 3px solid var(--macro);
      border-radius: 0 8px 8px 0;
      background: var(--macro-dim);
      border-top: 1px solid var(--macro-border);
      border-bottom: 1px solid var(--macro-border);
      border-right: 1px solid var(--macro-border);
      padding: 0.75rem 1rem;
      margin: 0.875rem 0;
    }
    .india-box-label {
      font-size: 0.65rem; font-weight: 500; text-transform: uppercase;
      letter-spacing: 0.05em; color: var(--macro); margin-bottom: 6px;
    }
    .india-line {
      display: flex; gap: 6px; align-items: flex-start;
      margin-bottom: 4px; font-size: 0.8rem; color: var(--text);
      line-height: 1.45;
    }
    .india-line:last-child { margin-bottom: 0; }
    .india-dot { width: 4px; height: 4px; border-radius: 50%; background: var(--macro); margin-top: 5px; flex-shrink: 0; }

    /* === Trigger banner === */
    .trig-banner {
      display: flex; align-items: center; gap: 8px;
      padding: 0.4rem 0.75rem; border-radius: 6px;
      border: 1px dashed var(--gold);
      background: rgba(184,150,62,0.06);
      font-size: 0.75rem; color: var(--gold);
      margin-bottom: 0.875rem;
    }

    /* === India pulse table === */
    .pulse-table { width: 100%; border-collapse: collapse; font-size: 0.82rem; margin: 0.875rem 0; }
    .pulse-table th {
      text-align: left; padding: 6px 10px; font-size: 0.7rem; font-weight: 500;
      color: var(--text3); border-bottom: 1px solid var(--border);
      background: var(--bg2);
    }
    .pulse-table td {
      padding: 7px 10px; border-bottom: 1px solid var(--border);
      color: var(--text2); vertical-align: top;
    }
    .pulse-table tr:last-child td { border-bottom: none; }

    /* === Scenario cards === */
    .scen { border-radius: 10px; overflow: hidden; margin-bottom: 10px; }
    .scen-head { padding: 8px 13px; display: flex; justify-content: space-between; align-items: center; }
    .scen-body { padding: 10px 13px; }
    .scen-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 6px; margin: 7px 0; }
    .scen-cell-label { font-size: 0.68rem; color: var(--text3); margin-bottom: 2px; }
    .scen-cell-val { font-size: 0.8rem; font-weight: 500; }
    .scen-pos { font-size: 0.78rem; color: var(--text2); margin-top: 4px; padding-top: 6px; }
    .scen-green { border: 1px solid var(--macro-border); }
    .scen-green .scen-head { background: var(--macro-dim); }
    .scen-green .scen-head-title { color: var(--macro); font-size: 0.85rem; font-weight: 500; }
    .scen-green .scen-cell-val { color: var(--macro); }
    .scen-green .scen-pos { border-top: 1px solid var(--macro-border); }
    .scen-amber { border: 1px solid rgba(184,150,62,0.3); }
    .scen-amber .scen-head { background: rgba(184,150,62,0.07); }
    .scen-amber .scen-head-title { color: var(--gold); font-size: 0.85rem; font-weight: 500; }
    .scen-amber .scen-cell-val { color: var(--gold); }
    .scen-amber .scen-pos { border-top: 1px solid rgba(184,150,62,0.2); }
    .scen-red { border: 1px solid rgba(212,80,80,0.3); }
    .scen-red .scen-head { background: rgba(212,80,80,0.07); }
    .scen-red .scen-head-title { color: #d45050; font-size: 0.85rem; font-weight: 500; }
    .scen-red .scen-cell-val { color: #d45050; }
    .scen-red .scen-pos { border-top: 1px solid rgba(212,80,80,0.2); }

    /* === Sector table === */
    .sector-table { width: 100%; border-collapse: collapse; font-size: 0.78rem; margin: 0.75rem 0; table-layout: fixed; }
    .sector-table th {
      padding: 6px 8px; text-align: left; font-size: 0.7rem; font-weight: 500;
      color: var(--text3); border-bottom: 1px solid var(--border);
      background: var(--bg2); white-space: nowrap;
    }
    .sector-table td {
      padding: 7px 8px; border-bottom: 1px solid var(--border);
      color: var(--text2); vertical-align: top; line-height: 1.4;
    }
    .sector-table tr:last-child td { border-bottom: none; }

    /* === Chips (sector calls) === */
    .chip {
      font-size: 0.65rem; font-weight: 500; padding: 2px 6px;
      border-radius: 6px; white-space: nowrap; display: inline-block;
    }
    .chip-g { background: var(--macro-dim); color: var(--macro); border: 1px solid var(--macro-border); }
    .chip-a { background: rgba(184,150,62,0.1); color: var(--gold); border: 1px solid rgba(184,150,62,0.25); }
    .chip-r { background: rgba(212,80,80,0.08); color: #d45050; border: 1px solid rgba(212,80,80,0.2); }

    /* === Anchor callout === */
    .anchor-box {
      background: var(--macro-dim); border: 1px solid var(--macro-border);
      border-radius: 8px; padding: 0.875rem 1rem;
      font-size: 0.82rem; color: var(--text); line-height: 1.55;
      margin-top: 1rem;
    }

    /* === Footer === */
    .footer {
      margin-top: 3rem; padding-top: 1.5rem;
      border-top: 1px solid var(--border);
      font-size: 0.72rem; color: var(--text3); line-height: 1.6;
    }

    /* === Responsive === */
    @media (max-width: 600px) {
      .metrics { grid-template-columns: repeat(2, 1fr); }
      .metrics-4 { grid-template-columns: repeat(2, 1fr); }
      .scen-grid { grid-template-columns: repeat(2, 1fr); }
      .cover-title { font-size: 1.5rem; }
      .nav { padding: 0.6rem 1rem; }
      .page { padding: 1.25rem 1rem 3rem; }
    }
  </style>
</head>
<body>

<div class="orb orb1"></div>
<div class="orb orb2"></div>
<div class="orb orb3"></div>

<nav class="nav">
  <a href="../index.html" class="nav-brand">YouWe Quest<span>.</span></a>
  <div class="nav-right">
    <a href="index.html" class="nav-back">← All macro reports</a>
    <button class="theme-toggle" id="theme-toggle" aria-label="Toggle theme">
      <svg id="icon-sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>
      <svg id="icon-moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" style="display:none"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
    </button>
  </div>
</nav>

<div class="page">

  <!-- COVER -->
  <div class="cover">
    <div class="cover-eyebrow">India macro intelligence report</div>
    <h1 class="cover-title">Monthly macro tracker — [Month] [Year]</h1>
    <div class="cover-sub">Data as of [DD Month YYYY] · YouWe Quest LLP</div>
    <div class="cover-badges">
      <span class="badge">7 always-on sections</span>
      <!-- Add triggered badges here if applicable: -->
      <!-- <span class="badge badge-trig">+ Oil deep-dive · triggered</span> -->
      <!-- <span class="badge badge-trig">+ Sectors · Q1 baseline</span> -->
    </div>
  </div>

  <!-- TAB NAVIGATION -->
  <div class="tabs-wrap">
    <div class="tab-group">
      <span class="tab-grp-label">Global</span>
      <button class="tab active" onclick="sw('pol',this)">1. Policy rates</button>
      <button class="tab" onclick="sw('yld',this)">2. Bond yields</button>
      <button class="tab" onclick="sw('dxy',this)">3. DXY</button>
      <button class="tab" onclick="sw('infl',this)">4. Inflation</button>
      <button class="tab" onclick="sw('liq',this)">5. Liquidity</button>
    </div>
    <div class="tab-group">
      <span class="tab-grp-label">India</span>
      <button class="tab india" onclick="sw('pulse',this)">Markets pulse</button>
      <button class="tab india" onclick="sw('scen',this)">Scenarios</button>
      <!-- Add triggered tabs here if applicable: -->
      <!-- <button class="tab india triggered" onclick="sw('oil',this)">Oil deep-dive ⚠</button> -->
      <!-- <button class="tab india triggered" onclick="sw('sectors',this)">Sectors · Q1</button> -->
    </div>
  </div>

  <!-- ═══ SECTIONS GO HERE ═══ -->
  <!-- Paste the adapted section content from the skill HTML output below -->
  <!-- Each section: <div class="sec [active]" id="s-[id]"> ... </div> -->

</div><!-- .page -->

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
<script>
(function(){
  var html=document.documentElement;
  var btn=document.getElementById('theme-toggle');
  var sun=document.getElementById('icon-sun');
  var moon=document.getElementById('icon-moon');
  function applyTheme(t){
    html.setAttribute('data-theme',t);
    sun.style.display=t==='dark'?'':'none';
    moon.style.display=t==='light'?'':'none';
  }
  applyTheme(localStorage.getItem('theme')||'dark');
  btn.addEventListener('click',function(){
    var next=html.getAttribute('data-theme')==='dark'?'light':'dark';
    localStorage.setItem('theme',next);
    applyTheme(next);
  });
})();

const ch={};
function sw(id,btn){
  document.querySelectorAll('.sec').forEach(s=>s.classList.remove('active'));
  document.querySelectorAll('.tab').forEach(t=>t.classList.remove('active'));
  document.getElementById('s-'+id).classList.add('active');
  btn.classList.add('active');
  if(chartInits[id]) setTimeout(()=>chartInits[id](),60);
}

/* Chart defaults — use these options for every chart */
const chartOpts = {
  responsive:true, maintainAspectRatio:false,
  plugins:{ legend:{display:false}, tooltip:{mode:'index',intersect:false} },
  scales:{
    x:{ grid:{color:'rgba(94,191,140,0.08)'}, ticks:{color:'rgba(154,171,184,0.7)',font:{size:10},maxTicksLimit:6}, border:{display:false} },
    y:{ grid:{color:'rgba(94,191,140,0.08)'}, ticks:{color:'rgba(154,171,184,0.7)',font:{size:10}}, border:{display:false} }
  }
};

/* Register chart init functions here — one per section that has a chart */
const chartInits = {
  pol: () => { /* init policy chart */ },
  yld: () => { /* init yields chart */ },
  dxy: () => { /* init dxy chart */ },
  infl: () => { /* init inflation chart */ },
  liq: () => { /* init liquidity chart */ },
  oil: () => { /* init oil chart — only if triggered */ },
};

/* Init the default active chart on load */
setTimeout(()=>{ if(chartInits.pol) chartInits.pol(); }, 250);
</script>

</body>
</html>
```

#### Colour mapping — skill CSS vars → site vars

| Skill output (claude.ai vars) | Site equivalent |
|---|---|
| `var(--color-background-primary)` | `var(--bg)` |
| `var(--color-background-secondary)` | `var(--bg2)` |
| `var(--color-text-primary)` | `var(--text)` |
| `var(--color-text-secondary)` | `var(--text2)` |
| `var(--color-text-tertiary)` | `var(--text3)` |
| `var(--color-border-tertiary)` | `var(--border)` |
| `var(--color-border-secondary)` | `var(--border)` |
| `var(--border-radius-md)` | `8px` |
| `var(--border-radius-lg)` | `10px` |
| Positive green (`#1D9E75`, `#E1F5EE`) | `var(--macro)`, `var(--macro-dim)` |
| Amber (`#EF9F27`, `#FAEEDA`) | `var(--gold)`, `rgba(184,150,62,0.08)` |
| Red (`#D85A30`, `#FAECE7`) | `#d45050`, `rgba(212,80,80,0.08)` |
| Blue (`#378ADD`) | `#378ADD` (unchanged) |
| Chart grid lines | `rgba(94,191,140,0.08)` |
| Chart tick labels | `rgba(154,171,184,0.7)` |

#### Font mapping
- Section titles → `font-family: 'Cormorant Garamond', serif`
- All other text → `font-family: 'DM Sans', sans-serif` (already the body default)

---

### Step 4 — Update macro/index.html

Add a new card at the top of `.update-list`, following the existing card pattern.
Move the `latest-chip` span to the new card.

Card template:
```html
<a href="MacroReport_30Apr2026.html" class="update-card">
  <span class="latest-chip">Latest</span>
  <div class="card-meta">
    <span class="card-date">30 Apr 2026</span>
    <span class="card-tag macro-tag">Macro</span>
  </div>
  <h3 class="card-title">India Macro Intelligence — April 2026</h3>
  <p class="card-desc">
    Monthly tracker: Fed on hold at 3.50–3.75%, RBI paused at 5.25%.
    [One sentence summary of the month's dominant theme.]
  </p>
</a>
```

Fill `card-desc` with a 1–2 sentence summary of the month's key macro theme from the report.

---

### Step 5 — Update the home page CTA

In `index.html`, update the "Read Latest Report →" button `href` to point to the new file:

```html
<a href="/macro/MacroReport_<DD><Mon><YYYY>.html" class="btn-primary" ...>Read Latest Report →</a>
```

---

### Step 6 — Commit and push

```bash
git add macro/MacroReport_<DD><Mon><YYYY>.html macro/index.html index.html
git commit -m "macro: add [Month] [Year] macro intelligence report"
git push origin main
```

GitHub Pages auto-deploys on push. The report will be live at:
`https://www.youwequest.com/macro/MacroReport_<DD><Mon><YYYY>.html`

---

### Checklist before pushing

- [ ] File named correctly: `MacroReport_<DD><Mon><YYYY>.html`
- [ ] Theme toggle works (dark/light, persists on reload)
- [ ] All 5 global tabs switch correctly
- [ ] Both India tabs switch correctly
- [ ] Charts render correctly on tab switch (not on page load)
- [ ] Triggered tabs present with dashed border (if any this month)
- [ ] Cover badges match which sections are triggered
- [ ] `macro/index.html` card added at top, `latest-chip` moved
- [ ] `index.html` "Read Latest Report →" href updated to new file
- [ ] `CNAME` file untouched


---

## Weekly Regulatory Update — Automated Workflow

### Trigger
When `run_weekly.sh` is executed, or when Triyambak says any of:
- "run the weekly update"
- "Friday digest"
- "generate the weekly update"

The script passes `WEEK_PERIOD`, `WEEK_ID`, and `FILE_DATE` as environment variables.
Follow all five steps below exactly, in order.

---

### Step 1 — Research

Search all six sources for developments published during the week period:

| Source | Coverage |
|---|---|
| `cbic-gst.gov.in` | GST circulars, notifications, portal updates |
| `incometax.gov.in` | IT notifications, press releases, CBDT orders |
| `mca.gov.in` | Company law circulars, scheme notifications |
| `sebi.gov.in` | Circulars, press releases, consultation papers |
| `taxmann.com` | Court rulings, tribunal orders, analysis |
| `icai.org` | Standards, peer review, UDIN, CPE advisories |

Compile findings into five domain buckets: GST · Direct Tax · MCA · SEBI · ICAI.
For each item identify: type tag (COURT / DEADLINE / PORTAL / BUDGET / NEW LAW / LIVE), statutory reference, plain-language summary, and practice implication.

---

### Step 2A — Generate HTML File

**Filename:** `updates/WeeklyUpdate_Web_v2_${FILE_DATE}.html`

**Structure:** Single self-contained HTML file with three tabs:

**Summary tab**
- Six clickable chips at top (GST / Direct Tax / MCA / SEBI / ICAI / Actions) — each calls `scrollToSection('sec-<domain>')`, Actions chip calls `switchTab('actions', ...)`
- Each domain section `<div>` carries matching `id`: `sec-gst`, `sec-dt`, `sec-mca`, `sec-sebi`, `sec-icai`
- Glass cards with entries: each entry has a colour-coded tag + text
- Tag types: `t-court` · `t-dead` · `t-portal` · `t-budget` · `t-new` · `t-live` · `t-icai`

**Technical Reference tab**
- Accordion sections (one per domain, labelled I–V)
- Sub-sections with coloured left-border (`b-gst`, `b-dt`, `b-mca`, `b-sebi`, `b-icai`)
- Statutory citations in monospace teal badge `.cite`
- Section references in gold badge `.stat`
- Deadline dates in red `.date`
- Practice notes in gold callout box `.tnote`
- Click-to-expand: `onclick="toggleSub(this)"` on each `.tsub-hd`

**Action Items tab**
- Table sorted chronologically, domain as tiebreaker within same date
- Columns: Due Date · Domain · Action Required
- Due dates in red `.dred`, Ongoing in muted `.dgray`
- Domain badges use same colour classes as pills

**CSS — critical rule:**
Copy the full `<style>` block (including `[data-theme="light"]` overrides and
theme-toggle button) verbatim from the most recent existing file in `updates/`.
Do NOT regenerate styles — inherit them exactly so every design improvement
carries forward automatically.

**Domain colours (CSS vars):**
- GST: `--gst` (gold ramp)
- Direct Tax: `--dt` (blue ramp)
- MCA: `--mca` (purple ramp)
- SEBI: `--sebi` (orange-red ramp)
- ICAI: `--icai` (teal ramp)

**Sign-off:** S. Triyambaka Patro, CA · YouWe Quest LLP

---

### Step 2B — Generate DOCX File

**Filename:** `WeeklyUpdate_Merged_${WEEK_ID}_${FILE_DATE}.docx`
**Note:** This file is gitignored — it stays on the local Mac only.

Generate a merged Word document using `docx` npm package with three parts:

**Part 1 — Summary**
- Page heading: "Weekly Regulatory Update — W[##]-[YEAR]"
- Subheading: "Dear Clients, · [SAT DATE] to [FRI DATE]"
- Five domain sub-sections, each with colour-coded tag rows
- Tags: COURT · DEADLINE · PORTAL · BUDGET · NEW LAW · SCHEME · URGENT

**Divider Page**
- Full-width gold horizontal rules
- Large centred text: "TECHNICAL REFERENCE"
- Week reference below
- Page break before and after

**Part 2 — Technical Reference**
- Five sections: I. GST · II. Direct Tax · III. MCA · IV. SEBI · V. ICAI
- Dark background (`#0D1B2A`) section headers with gold text
- Sub-sections with coloured headings
- Bullet points with statutory citations in Courier New
- Practice notes in indented italic text

**Part 3 — Action Items**
- Three-column table: Domain (colour-coded) · Deadline (red) · Action
- Sorted chronologically, domain tiebreaker within same date
- Alternating row shading

**Branding:**
- Firm: YouWe Quest LLP
- Greeting: Dear Clients,
- Sign-off: Warm regards, / S. Triyambaka Patro, CA / YouWe Quest LLP
- Colours: DARK=#0D1B2A · GOLD=#B8963E · fonts: Arial body, Courier New citations

---

### Step 3 — Update Archive

**`updates/index.html`**
Add a new card at the TOP of `.update-list` (after the year divider if present).
Move the `latest-chip` span to the new card.

Card template:
```html
<a href="WeeklyUpdate_Web_v2_${FILE_DATE}.html" class="update-card">
  <span class="latest-chip">Latest</span>
  <div class="card-meta">
    <span class="card-date">${FRI_DATE_DISPLAY}</span>
    <span class="card-tag">Regulatory</span>
  </div>
  <h3 class="card-title">Weekly Regulatory Update — ${WEEK_ID}</h3>
  <p class="card-desc">
    [1–2 sentence summary of the week's most important development.]
  </p>
</a>
```

**`updates/UPDATES_LOG.json`**
Prepend a new entry:
```json
{
  "week": "${WEEK_ID}",
  "period": "${SAT_DATE} to ${FRI_DATE}",
  "date_prepared": "${TODAY_ISO}",
  "file": "WeeklyUpdate_Web_v2_${FILE_DATE}.html"
}
```

---

### Step 4 — Commit and Push

```bash
git add updates/WeeklyUpdate_Web_v2_${FILE_DATE}.html updates/index.html updates/UPDATES_LOG.json
git commit -m "feat: add ${WEEK_ID} weekly regulatory update"
git push origin main
```

Note: `*.docx` is gitignored — `git add .` will not pick it up.
GitHub Pages auto-deploys on push. Live at: `https://www.youwequest.com/updates/`

---

### Step 5 — Send Email

Using the Gmail API, send directly (not as a draft):
- **To:** youwequest@gmail.com
- **From:** triyambak143@gmail.com
- **Subject:** Weekly Update ${WEEK_ID} — Internal Copy (${FRI_DATE})
- **Body:**
  ```
  Dear Team,

  Please find attached this week's regulatory update document.
  Week: ${SAT_DATE} to ${FRI_DATE}
  Live on website: https://www.youwequest.com/updates/

  Warm regards,
  S. Triyambaka Patro, CA
  YouWe Quest LLP
  ```
- **Attachment:** `WeeklyUpdate_Merged_${WEEK_ID}_${FILE_DATE}.docx`
  Read the file, base64-encode it, attach via Gmail API multipart send.

---

### Checklist before confirming done

- [ ] HTML file created in `updates/` with correct filename
- [ ] Three tabs working: Summary · Technical Reference · Action Items
- [ ] Clickable chips with correct `scrollToSection` / `switchTab` handlers
- [ ] Section `id` attributes present: `sec-gst`, `sec-dt`, `sec-mca`, `sec-sebi`, `sec-icai`
- [ ] Style block copied verbatim from previous week (not regenerated)
- [ ] Theme toggle works (dark/light, persists on reload)
- [ ] DOCX file generated locally (not in git)
- [ ] `updates/index.html` card added at top, `latest-chip` moved
- [ ] `updates/UPDATES_LOG.json` updated
- [ ] `CNAME` file untouched
- [ ] Git committed and pushed to main
- [ ] Email sent to youwequest@gmail.com with DOCX attached