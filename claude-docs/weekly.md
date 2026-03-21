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

Search all ten sources for developments published during the week period:

| Source | Domain | Coverage |
|---|---|---|
| `cbic-gst.gov.in` | GST | Circulars, Notifications (CT/IT/UT/IGST/Compensation Cess), Instructions |
| `gst.gov.in/home/advmsg` | GST | GSTN portal/technical advisories — separate from CBIC; HSN changes, e-invoice updates, API changes |
| `gstcouncil.gov.in/gst-council-meetings` | GST | Post-Council meeting press notes (issued before formal CBIC notification — 1–2 week advance notice) |
| `incometax.gov.in` | Direct Tax | Notifications, Circulars, Press releases, CBDT orders |
| `tdscpc.gov.in` | Direct Tax | TRACES advisories — TDS/TCS form schema changes, utility releases, validation rule updates |
| `mca.gov.in` | MCA | Circulars, GSRs, V3 portal announcements |
| `sebi.gov.in` | SEBI | Circulars, press releases, consultation papers |
| `rbi.org.in` | RBI / FEMA | Notifications, Press releases, Master Direction amendments — FEMA rules, ECB guidelines, LRS limits, NRO/NRE account regulations, forex rules |
| `taxmann.com` | Cross-domain | Court rulings, tribunal orders, analysis |
| `icai.org` | ICAI | Standards, peer review, UDIN, CPE advisories |

**Note on RBI/FEMA:** Include in the **Direct Tax** domain bucket if the item relates to NRI taxation or foreign income (FEMA + income tax overlap). Create a standalone **RBI/FEMA** entry in the summary only if the item is purely regulatory (no direct tax angle) — e.g., a change to LRS limits or NRO repatriation rules.

**ICAI Publications — check these 5 committee pages every week (newest first on each page):**

| Committee page | Coverage |
|---|---|
| `icai.org/post/icai-publications-auditing-assurance-standards-board` | Technical Guides, Guidance Notes, Practitioner's Guides (shows dates — easy to scan) |
| `icai.org/post/icai-publications-direct-taxes-committee` | Technical Guides, Handbooks on income tax |
| `idtc.icai.org/publications.php` | GST/Customs handbooks, case law compilations |
| `icai.org/post/icai-publications-corporate-laws-corporate-governance-committee` | Company law, LLP, SEBI/LODR handbooks |
| `icai.org/post/icai-publications-committee-on-international-taxation` | Transfer pricing, DTAA, PE, expatriate tax guides |

**Rule:** Include **final publications only** — Technical Guides, Guidance Notes (final), Handbooks, Standards. **Exclude** exposure drafts, consultation papers, background materials for courses, and CPE webinar announcements.

**Cross-verification — X (Twitter) handles:**
After pulling from all 10 sources above, scan these handles for the week period. If a tweet references something not already in your findings, investigate and add it.

| Handle | Department |
|---|---|
| `@cbic_india` | CBIC — GST circulars, notifications |
| `@askGST_GoI` | GSTN — portal advisories, system updates |
| `@IncomeTaxIndia` | Income Tax Department — CBDT notifications, portal updates |
| `@MCA21India` | MCA — circulars, V3 portal announcements |
| `@SEBI_India` | SEBI — circulars, orders, press releases |
| `@RBI` | RBI — notifications, FEMA, press releases |
| `@theICAI` | ICAI — publications, standards, announcements |
| `@FinMinIndia` | Ministry of Finance — cross-domain MoF announcements |

Compile findings into five domain buckets: GST · Direct Tax · MCA · SEBI · ICAI.
For each item identify: type tag (COURT / DEADLINE / PORTAL / BUDGET / NEW LAW / LIVE), statutory reference, plain-language summary, practice implication, and **direct URL** to the source document (circular PDF, notification page, press release, court order, or publication download link). The URL is required — if a direct link is not available, use the department's relevant section page as the fallback.

---

### Step 2A — Generate HTML File

**Filename:** `updates/WeeklyUpdate_Web_v2_${FILE_DATE}.html`

**Structure:** Single self-contained HTML file with three tabs:

**Summary tab**
- Six clickable chips at top (GST / Direct Tax / MCA / SEBI / ICAI / Actions) — each calls `scrollToSection('sec-<domain>')`, Actions chip calls `switchTab('actions', ...)`
- Each domain section `<div>` carries matching `id`: `sec-gst`, `sec-dt`, `sec-mca`, `sec-sebi`, `sec-icai`
- Glass cards with entries: each entry has a colour-coded tag + text + source link
- Tag types: `t-court` · `t-dead` · `t-portal` · `t-budget` · `t-new` · `t-live` · `t-icai`
- Each entry must end with a source link: `<a href="DIRECT_URL" target="_blank" class="src-link">Source</a>` — opens in new tab. Use the direct PDF/notification link where available; fall back to the department's relevant section page.

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

**Filename:** `WeeklyUpdate_${FILE_DATE}.docx`
**Output folder:** `~/Documents/Professional update - weekly/`
**Full path:** `~/Documents/Professional update - weekly/WeeklyUpdate_${FILE_DATE}.docx`
**Note:** This file is gitignored — it stays on the local Mac only.

Generate a merged Word document using a **Python raw-XML script** (not the `docx` npm package).
Write a Python script and run it with `python3`. Match the W11 reference exactly:
`/Users/triyambak/Downloads/WeeklyUpdate_13Mar2026.docx`

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
- "PART 2 OF 2 · ${FRI_DATE} · ${SAT_DATE}–${FRI_DATE}" grey centred

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
z = zipfile.ZipFile(os.path.expanduser('~/Documents/Professional update - weekly/WeeklyUpdate_${FILE_DATE}.docx'))
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
- **Attachment:** `~/Documents/Professional update - weekly/WeeklyUpdate_${FILE_DATE}.docx`
  Read the file, base64-encode it, attach via Gmail API multipart send.

---

### Checklist before confirming done

- [ ] HTML file created in `updates/` with correct filename
- [ ] Three tabs working: Summary · Technical Reference · Action Items
- [ ] Clickable chips with correct `scrollToSection` / `switchTab` handlers
- [ ] Section `id` attributes present: `sec-gst`, `sec-dt`, `sec-mca`, `sec-sebi`, `sec-icai`
- [ ] Style block copied verbatim from previous week (not regenerated)
- [ ] Theme toggle works (dark/light, persists on reload)
- [ ] DOCX file generated at `~/Documents/Professional update - weekly/WeeklyUpdate_${FILE_DATE}.docx` (not in git)
- [ ] `updates/index.html` card added at top, `latest-chip` moved
- [ ] `updates/UPDATES_LOG.json` updated
- [ ] `CNAME` file untouched
- [ ] Git committed and pushed to main
- [ ] Email sent to youwequest@gmail.com with DOCX attached