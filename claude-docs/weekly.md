# weekly.md — Weekly Regulatory Update Workflow

Automated workflow for the weekly regulatory compliance update.
Loaded automatically by CLAUDE.md when the weekly update is triggered.

---

## Weekly Regulatory Update — Automated Workflow

### Trigger
When `scripts/run_weekly.sh` is executed, or when Triyambak says any of:
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