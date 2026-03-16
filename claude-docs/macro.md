# macro.md — Monthly Macro Report Workflow

Automated workflow for the India Macro Intelligence Report.
Loaded automatically by CLAUDE.md when the macro report is triggered.

---

## Monthly Macro Report — Automated Workflow

This section mirrors the weekly update workflow. Everything runs in one step from `scripts/run_macro.sh`.

### Trigger
When `scripts/run_macro.sh` is executed, or when Triyambak says any of:
- "run the macro report"
- "generate the macro report"
- "run the [month] macro report"

The script passes `REPORT_MONTH`, `REPORT_YEAR`, `REPORT_MONTH_YEAR`, `FILE_DATE`, and `REPORT_DATE_DISPLAY` as environment variables.
Follow all seven steps below exactly, in order.

---

### Step 1 — Determine report period

The script auto-detects and exports:
- `REPORT_MONTH` — full month name e.g. `April`
- `REPORT_YEAR` — four-digit year e.g. `2026`
- `REPORT_MONTH_YEAR` — e.g. `April 2026`
- `FILE_DATE` — last day of month e.g. `30Apr2026` (used in filename)
- `REPORT_DATE_DISPLAY` — e.g. `30 April 2026` (shown in report)

The report covers data **as of the run date** for the **current calendar month**.
If run after month-end (first few days of next month), the script detects this and uses the previous month.

---

### Step 2 — Pull all data

Search for every data point below. Pull all data **before** generating any output.
Mark each data point with its "as of" date. If unavailable, mark as `N/A`.

| # | Data point | Search query |
|---|---|---|
| 1 | Fed Funds Rate (target range) | `Fed Funds Rate current ${REPORT_MONTH} ${REPORT_YEAR}` |
| 2 | Fed meeting stance + next date | `FOMC latest decision ${REPORT_MONTH} ${REPORT_YEAR}` |
| 3 | RBI Repo Rate | `RBI repo rate current ${REPORT_MONTH} ${REPORT_YEAR}` |
| 4 | RBI MPC latest stance | `RBI MPC latest decision ${REPORT_MONTH} ${REPORT_YEAR}` |
| 5 | Market-implied Fed cuts for year | `Fed rate cut expectations ${REPORT_YEAR} CME FedWatch` |
| 6 | US 10Y Treasury yield | `US 10 year treasury yield today` |
| 7 | US 2Y Treasury yield | `US 2 year treasury yield today` |
| 8 | India 10Y G-Sec yield | `India 10 year government bond yield today` |
| 9 | DXY level | `DXY dollar index today` |
| 10 | USD/INR | `USD INR exchange rate today` |
| 11 | India Forex Reserves | `India forex reserves latest ${REPORT_MONTH} ${REPORT_YEAR}` |
| 12 | US CPI YoY (latest print) | `US CPI inflation ${REPORT_MONTH} ${REPORT_YEAR}` |
| 13 | India CPI YoY (latest print) | `India CPI inflation ${REPORT_MONTH} ${REPORT_YEAR}` |
| 14 | Brent Crude current price | `Brent crude oil price today` |
| 15 | Fed Balance Sheet size | `Federal Reserve balance sheet size latest` |
| 16 | Nifty 50 level | `Nifty 50 index today` |
| 17 | FII equity flows (MTD) | `FII equity flows India ${REPORT_MONTH} ${REPORT_YEAR}` |
| 18 | Monthly SIP inflows | `SIP inflows ${REPORT_MONTH} ${REPORT_YEAR} AMFI` |

---

### Step 3 — Evaluate trigger conditions

Decide which conditional sections to include this month:

**Oil deep-dive — include if ANY of:**
- Brent moved more than ±10% during the calendar month
- Brent is currently sustained above $90/bbl
- Brent is currently below $60/bbl
- A major supply disruption event occurred (war, OPEC cut/surge, sanctions)

**Sectoral matrix — include if ANY of:**
- Current month is March, June, September, or December (quarter-end)
- Major RBI surprise (cut/hike when market expected hold, or vice versa)
- Major Union Budget or regulatory change materially shifting sector dynamics
- Oil moved >20% in the month

Record the triggered sections before proceeding. Both HTML and DOCX must include identical sections.

---

### Step 4A — Generate HTML file

**Filename:** `macro/MacroReport_${FILE_DATE}.html`

**CSS — critical rule:**
Copy the full `<style>` block (including `[data-theme="light"]` overrides and SVG theme-toggle)
verbatim from the most recent existing file in `macro/`.
Do NOT regenerate styles — inherit them exactly so every design improvement carries forward automatically.
If no previous file exists, use the page shell template in the reference section below.

**Structure:**

Page shell → Cover header → Alert banner (if major shock active) → Tab navigation → Sections → Footer

**Tab navigation (always-on):**

Row 1 — Global (standard styling):
`1. Policy rates` · `2. Bond yields` · `3. DXY` · `4. Inflation` · `5. Liquidity`

Row 2 — India (macro-green accent, `india` class):
`Markets pulse` · `Scenarios`

Row 2 — triggered tabs (dashed border, `trig` class, appended to India row):
- `Oil deep-dive ⚠` — if oil trigger active
- `Sectors · Q[N]` — if sectors trigger active

**Cover badges** must reflect triggered sections:
- Always: `7 always-on sections`
- Add per triggered section: `+ Oil deep-dive · triggered` / `+ Sectors · Q[N] baseline`

**Each global section (1–5) structure:**
1. Section number + Cormorant Garamond title + status pill
2. One-paragraph context (2–3 sentences, current data)
3. Metric cards row (3 cards for most, 4 for inflation)
4. Bullet list (3–4 bullets, dot-r/dot-g/dot-a colour coding)
5. Chart.js line chart with custom HTML legend (charts init on tab switch, not on load)
6. **India impact callout** — teal left-border box, label "INDIA IMPACT", 2–3 lines

**India impact box CSS (must match):**
```css
border-left: 3px solid var(--macro);
border-radius: 0 8px 8px 0;
background: var(--macro-dim);
border-top: 1px solid var(--macro-border);
border-bottom: 1px solid var(--macro-border);
border-right: 1px solid var(--macro-border);
padding: 0.75rem 1rem; margin: 0.875rem 0;
```

**India Markets Pulse section:**
- 4 metric cards: Nifty level · FII equity · DII equity · Monthly SIP
- Table: 6 rows (Large caps / Mid caps / Small caps / India VIX / Gold INR / India 10Y G-Sec)
  - Columns: Segment | Current read | Change vs last month
- One-line read paragraph (plain language for public investors)

**India Scenarios section:**
- 3 scenario cards (A=Bull green / B=Base amber / C=Bear red)
- Each card: trigger description + 4-cell grid (Nifty / INR / G-Sec / RBI) + positioning call
- Structural anchor paragraph in green callout box at bottom

**Triggered: Oil deep-dive** — trig-banner + context + 3 metrics + 4 bullets + chart + India watch levels (below $85 / $85–100 / above $110)

**Triggered: Sectoral matrix** — trig-banner + 10-row table (Sector / Current / Relief / Now chip / On deal chip)

**Chart specifications:**
- Chart.js 4.4.1 from `cdnjs.cloudflare.com` — only CDN allowed
- All 6 charts: 185px wrapper height, init on tab switch
- Grid: `rgba(94,191,140,0.08)` · Ticks: `rgba(154,171,184,0.7)`
- Primary series: `#B8963E` (gold) · Secondary: `#378ADD` (blue)
- 12–14 data points per chart covering prior 12–14 months

**Div balance validation — run before saving:**
```python
python3 -c "
sections = ['s-pol','s-yld','s-dxy','s-infl','s-liq','s-pulse','s-scen','s-oil','s-sectors']
with open('macro/MacroReport_${FILE_DATE}.html') as f:
    c = f.read()
for s in sections:
    start = c.find('id=\"'+s+'\"')
    if start == -1: continue
    nexts = [c.find('id=\"'+ns+'\"') for ns in sections if c.find('id=\"'+ns+'\"') > start]
    end = min(nexts) if nexts else c.find('</script>')
    chunk = c[start:end]
    op, cl = chunk.count('<div'), chunk.count('</div')
    print(f'{s}: {"OK" if op==cl else f"MISMATCH opens={op} closes={cl}"}')
"
```
Do not proceed to Step 5 if any section shows MISMATCH.

---

### Step 4B — Generate DOCX file

**Filename:** `MacroIntel_${REPORT_MONTH}_${REPORT_YEAR}.docx`
**Note:** This file is gitignored — it stays on the local Mac only.

Generate using `docx` npm package. Structure:

**Cover page:**
- Eyebrow: "INDIA MACRO INTELLIGENCE REPORT"
- Title: "Monthly Macro Tracker — ${REPORT_MONTH_YEAR}"
- Triggered sections box (if any)
- Date + sources line

**Section order:**
1. Executive summary
2. Policy rates + India RBI callout (teal left-border box)
3. Bond yields + India G-Sec callout
4. DXY + India INR callout
5. Inflation (US + India) + India inflation callout
6. Global liquidity + India OMO callout
7. Oil deep-dive (if triggered)
8. India Markets Pulse
9. India Scenarios (3-scenario traffic-light cards)
10. Sectoral matrix (if triggered)
11. Disclaimer

**DOCX critical rules:**
- NEVER use `PageNumber` or `PageNumberElement` — corrupts Word on Mac
- Always use `WidthType.DXA` — never `WidthType.PERCENTAGE`
- Tables need dual widths: `columnWidths` on table AND `width` on each cell
- Use `ShadingType.CLEAR` — never `ShadingType.SOLID`
- Page size: US Letter (12240 × 15840 DXA), 1-inch margins (1440 DXA)
- Font: Arial throughout. Bold = `bold: true`. No weight 600/700.
- Footer: plain text only — "MacroIntel · ${REPORT_MONTH_YEAR}" right-aligned

**Validate after generating:**
```python
python3 -c "
import zipfile, xml.etree.ElementTree as ET
z = zipfile.ZipFile('MacroIntel_${REPORT_MONTH}_${REPORT_YEAR}.docx')
ET.fromstring(z.read('word/document.xml'))
print('Valid -', len(z.namelist()), 'files')
"
```

---

### Step 5 — Update macro/index.html

Add a new card at the TOP of `.update-list`. Move `latest-chip` to the new card.

```html
<a href="MacroReport_${FILE_DATE}.html" class="update-card">
  <span class="latest-chip">Latest</span>
  <div class="card-meta">
    <span class="card-date">${REPORT_DATE_DISPLAY}</span>
    <span class="card-tag macro-tag">Macro</span>
  </div>
  <h3 class="card-title">India Macro Intelligence — ${REPORT_MONTH_YEAR}</h3>
  <p class="card-desc">
    [1–2 sentence summary of the month's dominant macro theme.]
  </p>
</a>
```

**Home page CTA — one-time setup only:**
The `index.html` home page has a "Read Latest Report →" link. This should point to `macro/` (the index page), not to a specific report file. If it currently points to a specific file (e.g. `macro/MacroReport_31Mar2026.html`), update it once to `macro/` and it will always be current. No action needed on this each month after that.

---

### Step 6 — Commit and push

```bash
git add macro/MacroReport_${FILE_DATE}.html macro/index.html
git commit -m "macro: add ${REPORT_MONTH_YEAR} macro intelligence report"
git push origin main
```

Note: `*.docx` is gitignored — `git add .` will not pick it up.
GitHub Pages auto-deploys on push. Live at: `https://www.youwequest.com/macro/`

---

### Step 7 — Send email

Using the Gmail API, send directly (not as a draft):
- **To:** youwequest@gmail.com
- **From:** triyambak143@gmail.com
- **Subject:** Macro Intelligence Report — ${REPORT_MONTH_YEAR} (Internal Copy)
- **Body:**
  ```
  Dear Team,

  Please find attached the India Macro Intelligence Report for ${REPORT_MONTH_YEAR}.
  Live on website: https://www.youwequest.com/macro/

  Warm regards,
  S. Triyambaka Patro, CA
  YouWe Quest LLP
  ```
- **Attachment:** `MacroIntel_${REPORT_MONTH}_${REPORT_YEAR}.docx`
  Read the file, base64-encode it, attach via Gmail API multipart send.

---

### Checklist before confirming done

- [ ] All 18 data points pulled with "as of" dates noted
- [ ] Trigger conditions evaluated and recorded
- [ ] HTML file created: `macro/MacroReport_${FILE_DATE}.html`
- [ ] Style block copied verbatim from previous `macro/` file (not regenerated)
- [ ] Div balance check passed — all sections show OK
- [ ] Theme toggle works (dark/light SVG icon, persists on reload)
- [ ] All always-on tabs switch correctly
- [ ] Triggered tabs present with dashed border (if any this month)
- [ ] Cover badges match triggered sections
- [ ] Charts render on tab switch (not on page load)
- [ ] DOCX generated and validated (not in git)
- [ ] `macro/index.html` card added at top, `latest-chip` moved
- [ ] `index.html` home page CTA points to `macro/` (index, not a specific file) — one-time setup, no action needed each month
- [ ] `CNAME` file untouched
- [ ] Git committed and pushed to main
- [ ] Email sent with DOCX attached

---

### Reference: page shell template

Use this only if no previous `macro/` file exists to copy styles from.
Otherwise always copy `<style>` verbatim from the most recent existing file.

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
