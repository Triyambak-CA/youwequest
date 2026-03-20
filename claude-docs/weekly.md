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

Generate a merged Word document using a **Python raw-XML script** (not the `docx` npm package).
Write a Python script and run it with `python3`. Match the W11 reference exactly:
`/Users/triyambak/Downloads/WeeklyUpdate_Merged_13Mar2026.docx`

**Design — Light theme (NOT dark):**
- Background: white/off-white (`FFFFFF` / `F7F8FA`) — NEVER dark backgrounds in body text
- Body text: dark navy `0D1B2A`
- Page size: A4 (`w:w="11906" w:h="16838"`)
- Margins: top/bottom `1080` DXA, left/right `1200` DXA
- Font: Arial throughout; Courier New for statutory citations only

**Header (every page):**
- 2-column table (5500 + 4006 DXA), gold bottom border (`B8963E`, sz=5)
- Left cell: `YouWe Quest LLP` bold dark (`0D1B2A`) sz=20
- Right cell: `Regulatory Update  |  ${FRI_DATE_DISPLAY}` grey (`888888`) sz=18 right-aligned

**Footer (every page):**
- Gold top border (`B8963E`, sz=3)
- Centred disclaimer in grey (`AAAAAA`) sz=16

**Part 1 — Summary**
- Title: "Weekly Regulatory Update" centred bold dark sz=44
- Subtitle: "PART 1 OF 2 — SUMMARY" (gold) + "Week of ${SAT_DATE} to ${FRI_DATE}" (grey) centred sz=19
- Gold rule (pBdr bottom B8963E sz=6)
- "Dear Clients," + one-paragraph intro
- Five domain sections, each:
  - Header: emoji + domain name, bold dark sz=24, with gold pBdr bottom sz=3
  - 2-column table (1500 + 8006 DXA): tag badge (left) + content (right)
  - Tag badge cell: coloured bg (see below), white bold text sz=17, centred, vAlign center
  - Content cell: dark text `0D1B2A` sz=20, alternating `F7F8FA`/`FFFFFF` fill
- Tags and badge colours: COURT `C0392B` · DEADLINE `B8963E` · PORTAL `1A5276` · NEW LAW `7A349E` · BUDGET `1E8449` · CIRCULAR `B8963E` · MARKETS `E67E22` · ICAI `1A9080` · DATA `555555` · LIVE `1E8449`
- Sign-off after last section

**Divider Page (between Part 1 and Part 2):**
- Gold rule lines centred
- "TECHNICAL REFERENCE" bold gold sz=36 centred
- "PART 2 OF 2 · ${WEEK_ID} · ${SAT_DATE}–${FRI_DATE}" grey centred

**Part 2 — Technical Reference**
- Five sections: I. GST · II. Direct Tax · III. MCA · IV. SEBI · V. ICAI
- Section header bar: dark bg `0D1B2A`, roman numeral gold Courier New sz=22, domain name white Arial sz=24
- Sub-headings (A, B, C): coloured bold Arial sz=20 (colour matches domain theme)
- Bullets: ListParagraph style, dark text `0D1B2A` sz=20, num bullet
- Practice notes: light gold bg `FDF8EE`, indented, italic grey `555555` sz=19, bold gold `B8963E` label

**Part 3 — Action Items**
- "ACTION ITEMS" title centred bold sz=36
- Gold rule
- 3-column table (1200 + 1500 + 6806 DXA):
  - Domain col: coloured bg badge, white bold text sz=17, centred
  - Deadline col: `F7F8FA`/`FFFFFF` alternating, red `C0392B` for dates, grey `888888` for Ongoing
  - Action col: `F7F8FA`/`FFFFFF` alternating, dark text `0D1B2A` sz=19
- Table border: gold `B8963E` sz=3
- Sign-off after table

**Sign-off:**
- Italic grey closing note centred sz=19
- "Warm regards," dark `0D1B2A` sz=20
- "S. Triyambaka Patro, CA" bold dark `0D1B2A` sz=20
- "YouWe Quest LLP" grey `555555` sz=20

**Validate after generating:**
```python
python3 -c "
import zipfile, xml.etree.ElementTree as ET
z = zipfile.ZipFile('WeeklyUpdate_Merged_${WEEK_ID}_${FILE_DATE}.docx')
for f in ['word/document.xml','word/header1.xml','word/footer1.xml']:
    ET.fromstring(z.read(f))
print('Valid -', len(z.namelist()), 'files')
"
```

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
  <h3 class="card-title">Weekly Regulatory Update — ${FRI_DATE}</h3>
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