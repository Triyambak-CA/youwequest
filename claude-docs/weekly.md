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

> **Known gap:** X/Twitter returns HTTP 402 (auth required) when fetched programmatically — the automated workflow cannot read tweets directly. This step is therefore manual-only. Triyambak should share any tweet screenshots post-run for items not caught via portal sources. Example missed in W13: @IncomeTaxIndia tweet (26 Mar 2026) on Finance Bill 2026 buyback surcharge was not on incometax.gov.in at run time and was added retroactively. Example missed in W14: CBDT Circular 4/2026 (DIN, 31 Mar 2026) was not surfaced by broad search queries but was visible on @IncomeTaxIndia and tax news aggregators.

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

**Targeted circular/notification searches (run after the 10-source sweep):**
These are a safety net to catch circulars/notifications that portal landing pages may lag in listing. Run all queries, cross-check against findings already collected, and add only genuinely new items.

| Domain | Search queries |
|---|---|
| **GST** | `"CBIC circular" OR "CBIC notification" ${WEEK_PERIOD}` |
| | `"CBIC circular" OR "CBIC notification" ${WEEK_ID} site:taxmann.com OR site:caclubindia.com` |
| **Direct Tax** | `"CBDT circular" ${MONTH} ${YEAR} site:incometax.gov.in` |
| | `"CBDT circular" OR "CBDT notification" ${WEEK_PERIOD} site:taxmann.com` |
| | `"CBDT circular" OR "CBDT notification" ${WEEK_PERIOD} caclubindia OR taxguru OR cleartax` |
| **MCA** | `"MCA circular" OR "MCA notification" ${WEEK_PERIOD} site:mca.gov.in` |
| **SEBI** | `"SEBI circular" ${WEEK_PERIOD} site:sebi.gov.in` |
| **RBI** | `"RBI notification" OR "RBI circular" ${WEEK_PERIOD} site:rbi.org.in` |

**Distinct notifications rule:** When multiple government actions relate to the same topic within a week (e.g., two separate CBDT notifications both concerning ITR forms, or two SEBI circulars on MF regulations), treat each as a distinct entry with its own tag, statutory reference, and source link. Do not merge them into one summary entry — practitioners need to know the specific notification number, date, and scope of each action separately. Example: W14-2026 had both AY 2026-27 ITR forms (old Act, notified 30–31 Mar) and Tax Year 2026-27 ITR forms (new Act, Notification 22/2026 on 1 Apr) — these are two separate entries, not one.

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
- Tag types: `t-court` · `t-dead` · `t-portal` · `t-budget` · `t-new` · `t-live` · `t-icai` (Standards) · `t-udin` (UDIN) · `t-peer` (Peer Review) · `t-pub` (Publication)
- **ICAI sub-type tags — never use `t-icai` for UDIN, Peer Review, or Publication entries:**
  - Standards/Guidance Notes → `t-icai` (teal `#6ECFBE`)
  - UDIN → `t-udin` (amber-orange `#F5A04A`)
  - Peer Review → `t-peer` (sky blue `#64C4E8`)
  - Publications → `t-pub` (lavender `#A89FD8`)
- CSS for these classes (copy into `<style>` after `.t-icai`):
  ```css
  .t-udin{color:#F5A04A;border-color:rgba(245,160,74,0.3);background:rgba(245,160,74,0.07)}
  .t-peer{color:#64C4E8;border-color:rgba(100,196,232,0.3);background:rgba(100,196,232,0.07)}
  .t-pub{color:#A89FD8;border-color:rgba(168,159,216,0.3);background:rgba(168,159,216,0.07)}
  ```
- Each entry must end with a source link: `<a href="DIRECT_URL" target="_blank" class="src-link">Source</a>` — opens in new tab. Use the direct PDF/notification link where available; fall back to the department's relevant section page.

**Technical Reference tab**
- Accordion sections (one per domain, labelled I–V)
- Sub-sections with coloured left-border (`b-gst`, `b-dt`, `b-mca`, `b-sebi`, `b-icai`)
- Statutory citations in monospace teal badge `.cite`
- Section references in gold badge `.stat`
- Deadline dates in red `.date`
- Practice notes in gold callout box `.tnote`
- Click-to-expand: `onclick="toggleSub(this)"` on each `.tsub-hd`
- Group dividers using `<div class="tsubsub">` — plain uppercase label, no letter

**Section V (ICAI) — fixed structure, always follow this layout:**

Two groups separated by `.tsubsub` dividers:

*Group 1 — Compliance & Deadlines* (items requiring firm action by a date):
- One subsection per item — e.g. UDIN mandate, PRB Phase III, CPE deadline
- Only include if there is a near-term deadline or mandatory compliance change

*Group 2 — New Publications* (final publications released this week or since last covered):
- One subsection per publication — never bundle two publications under one letter
- Subsection title format: `Publication Title · Committee · Date`
- Order: audit standards first (AASB), then domain-specific guides (Direct Tax, GST, MCA, Intl Tax), then corporate/other
- If no new publications this week, omit Group 2 entirely — do not add placeholder subsections

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

**Entry sort order — always include this script** (add just before `</script>` at bottom of JS block):
```js
(function sortEntries(){
  var order={
    't-dead':0,'t-new':1,'t-court':2,'t-portal':3,
    't-budget':4,'t-live':5,
    't-udin':6,'t-peer':7,'t-icai':8,'t-pub':9
  };
  document.querySelectorAll('.entries').forEach(function(container){
    var entries=Array.from(container.querySelectorAll(':scope>.entry'));
    entries.sort(function(a,b){
      var ta=a.querySelector('.tag')||{},tb=b.querySelector('.tag')||{};
      var ca=[].find.call(ta.classList||[],function(c){return c in order});
      var cb=[].find.call(tb.classList||[],function(c){return c in order});
      return (order[ca]??99)-(order[cb]??99);
    });
    entries.forEach(function(e){container.appendChild(e);});
  });
})();
```
Sort order: DEADLINE → NEW LAW → COURT → PORTAL → BUDGET → LIVE → UDIN → PEER REVIEW → STANDARDS → PUBLICATION.

**Tag column — fixed 100px, centred badge:**
- `.entry` grid: `grid-template-columns:100px 1fr` — all text content starts at the same horizontal position
- `.tag`: `display:block;text-align:center` — badge is centred within the 100px cell
- Do NOT use `max-content` (causes each row to start at a different position)

---

### Step 2B — Generate DOCX File

**Folder:** `~/Library/CloudStorage/OneDrive-Personal/1_Claude_AI/GitHub-Repos/youwequest/Professional update - weekly/${WEEK_ID}_${FILE_DATE}/`
**Files in folder:**
- `WeeklyUpdate_${FILE_DATE}.docx`
- `WeeklyUpdate_${FILE_DATE}.pdf`
- `WeeklyUpdate_${FILE_DATE}_Messages.txt`

Create the week folder before generating. All three files are gitignored — they stay on the local Mac only.

Generate a merged Word document using a **Python raw-XML script** (not the `docx` npm package).
Write a Python script and run it with `python3`. Use the W12 TOC reference as the template:
`/Users/triyambak/Library/CloudStorage/OneDrive-Personal/1_Claude_AI/GitHub-Repos/youwequest/Professional update - weekly/W12_20Mar2026/WeeklyUpdate_20Mar2026.docx`

The reference script is `/tmp/gen_w12_docx_toc_test.py` — reuse its helper functions verbatim
(`p()`, `rn()`, `tech_section_header()`, `tech_subheading()`, `toc_entry_link()`, `toc_sub_link()`,
`toc_part_link()`, `toc_group_label()`, `_hl_run()`, `_tab_run()`, `_pageref_run()`).

**Design — Light theme (NOT dark):**
- Background: white/off-white (`FFFFFF` / `F7F8FA`) — NEVER dark backgrounds in body text
- Body text: dark navy `0D1B2A`
- Page size: A4 (`w:w="11906" w:h="16838"`)
- Margins: top/bottom `1080` DXA, left/right `1200` DXA
- Font: Arial throughout; Courier New for statutory citations only
- **No em-dashes (—)** anywhere in content — use hyphen (-) instead

**Header (every page):**
- 2-column table (5500 + 4006 DXA), gold bottom border (`B8963E`, sz=5)
- Left cell: `YouWe Quest LLP` bold dark (`0D1B2A`) sz=20
- Right cell: `Regulatory Update  |  ${FRI_DATE_DISPLAY}` grey (`888888`) sz=18 right-aligned

**Footer (every page):**
- Gold top border (`B8963E`, sz=3)
- Centred disclaimer in grey (`AAAAAA`) sz=16

**Part 1 — Summary**
- Title: "Weekly Regulatory Update" centred bold dark sz=44 — add bookmark `bk_p1`
- Subtitle: "PART 1 OF 2 — SUMMARY" (gold) + "Week of ${SAT_DATE} to ${FRI_DATE}" (grey) centred sz=19
- Gold rule (pBdr bottom B8963E sz=6)
- **Table of Contents** (inserted here, before "Dear Clients,"):
  - Heading: "TABLE OF CONTENTS" centred bold sz=24
  - Thin gold separator line (pBdr bottom B8963E)
  - Three parts using `toc_part_link()`: PART 1 · PART 2 · PART 3
  - Domain entries using `toc_entry_link()` with domain colour (gold/blue/purple/orange/teal)
  - Subsection entries using `toc_sub_link()` (one per subheading A–Z)
  - ICAI group dividers (non-clickable) using `toc_group_label()`
  - Followed by thin gold separator + page break
- "Dear Clients," + one-paragraph intro
- Five domain sections, each:
  - Header: emoji + domain name, bold dark sz=24, with gold pBdr bottom sz=3
  - 2-column table (1500 + 8006 DXA): tag badge (left) + content (right)
  - Tag badge cell: coloured bg (see below), white bold text sz=17, centred, vAlign center
  - Content cell: dark text `0D1B2A` sz=20, alternating `F7F8FA`/`FFFFFF` fill
- Tags and badge colours: COURT `C0392B` · DEADLINE `B8963E` · PORTAL `1A5276` · NEW LAW `7A349E` · BUDGET `1E8449` · CIRCULAR `B8963E` · MARKETS `E67E22` · ICAI `1A9080` · DATA `555555` · LIVE `1E8449`
- **Entry sort order within each domain section (apply when building table rows):**
  - Primary: DEADLINE → NEW LAW → COURT → PORTAL → BUDGET → LIVE → ICAI/CIRCULAR/MARKETS/DATA
  - Secondary (within same tag): UDIN → PEER REVIEW → STANDARDS → PUBLICATION → others
- Sign-off after last section

**Divider Page (between Part 1 and Part 2):**
- Gold rule lines centred
- "TECHNICAL REFERENCE" bold gold sz=36 centred
- "PART 2 OF 2 · ${FRI_DATE} · ${SAT_DATE}–${FRI_DATE}" grey centred

**Part 2 — Technical Reference**
- Five sections: I. GST · II. Direct Tax · III. MCA · IV. SEBI · V. ICAI
- Section header bar: dark bg `0D1B2A`, roman numeral gold Courier New sz=22, domain name white Arial sz=24
  — add bookmarks: `bk_s1` (GST) · `bk_s2` (DT) · `bk_s3` (MCA) · `bk_s4` (SEBI) · `bk_s5` (ICAI)
  — use `tech_section_header(numeral, name, color, bk='bk_sN')`
- "TECHNICAL REFERENCE" divider heading — add bookmark `bk_p2`
- Sub-headings (A, B, C…): coloured bold Arial sz=20 — add bookmark per subheading `bk_sNa`, `bk_sNb`…
  — use `tech_subheading(letter, title, color, bk='bk_sNx')`
- ICAI group divider labels — add bookmarks `bk_s5_comp` and `bk_s5_pubs`
- Bullets: ListParagraph style, dark text `0D1B2A` sz=20, num bullet
- Practice notes: light gold bg `FDF8EE`, indented, italic grey `555555` sz=19, bold gold `B8963E` label

**Part 3 — Action Items**
- "ACTION ITEMS" title centred bold sz=36 — add bookmark `bk_p3`
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

**settings.xml must include `updateFields`** so Word auto-calculates page numbers on open:
```xml
<w:updateFields w:val="true"/>
```
When the reader opens the file, Word prompts to update fields — they click **Yes** and all `?` placeholders become real page numbers.

**Validate after generating:**
```python
python3 -c "
import zipfile, os, xml.etree.ElementTree as ET
z = zipfile.ZipFile(os.path.expanduser('~/Library/CloudStorage/OneDrive-Personal/1_Claude_AI/GitHub-Repos/youwequest/Professional update - weekly/${WEEK_ID}_${FILE_DATE}/WeeklyUpdate_${FILE_DATE}.docx'))
for f in ['word/document.xml','word/header1.xml','word/footer1.xml']:
    ET.fromstring(z.read(f))
print('Valid -', len(z.namelist()), 'files')
"
```

**Generate PDF from DOCX using Word (AppleScript):**
```bash
osascript <<'EOF'
set docxPath to "/Users/triyambak/Library/CloudStorage/OneDrive-Personal/1_Claude_AI/GitHub-Repos/youwequest/Professional update - weekly/${WEEK_ID}_${FILE_DATE}/WeeklyUpdate_${FILE_DATE}.docx"
set pdfPath to "/Users/triyambak/Library/CloudStorage/OneDrive-Personal/1_Claude_AI/GitHub-Repos/youwequest/Professional update - weekly/${WEEK_ID}_${FILE_DATE}/WeeklyUpdate_${FILE_DATE}.pdf"
tell application "Microsoft Word"
    open docxPath
    delay 3
    set theDoc to active document
    save as theDoc file name pdfPath file format format PDF
    close theDoc saving no
end tell
EOF
```
Word opens the file (updating all PAGEREF fields automatically), exports to PDF with clickable links preserved, then closes. The PDF is also gitignored and stays local.

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
- **Attachment:** `~/Library/CloudStorage/OneDrive-Personal/1_Claude_AI/GitHub-Repos/youwequest/Professional update - weekly/${WEEK_ID}_${FILE_DATE}/WeeklyUpdate_${FILE_DATE}.docx`
  Read the file, base64-encode it, attach via Gmail API multipart send.

**Client distribution (separate from internal email):**
Using the template at `@claude-docs/weekly_client_email.md`, generate a messages file:
`~/Library/CloudStorage/OneDrive-Personal/1_Claude_AI/GitHub-Repos/youwequest/Professional update - weekly/${WEEK_ID}_${FILE_DATE}/WeeklyUpdate_${FILE_DATE}_Messages.txt`

The file contains three ready-to-send sections — EMAIL, WHATSAPP, and LINKEDIN — fully populated
with that week's dates, highlights, and web link. Gitignored, stays local.

**Messages.txt structure (all three sections required every week):**
- `EMAIL` — formal client email with 4-5 bullet highlights, PDF attachment note
- `WHATSAPP` — condensed version, same highlights as bullets, informal tone
- `LINKEDIN` — public post with 4-5 highlights expanded to 2-3 lines each, emoji markers (🔴 for urgent deadlines, 📌 for new laws/updates), hashtags at end
Attach `WeeklyUpdate_${FILE_DATE}.pdf` when sending.

---

### Checklist before confirming done

- [ ] HTML file created in `updates/` with correct filename
- [ ] Three tabs working: Summary · Technical Reference · Action Items
- [ ] Clickable chips with correct `scrollToSection` / `switchTab` handlers
- [ ] Section `id` attributes present: `sec-gst`, `sec-dt`, `sec-mca`, `sec-sebi`, `sec-icai`
- [ ] Style block copied verbatim from previous week (not regenerated)
- [ ] Theme toggle works (dark/light, persists on reload)
- [ ] DOCX file generated at `~/Library/CloudStorage/OneDrive-Personal/1_Claude_AI/GitHub-Repos/youwequest/Professional update - weekly/${WEEK_ID}_${FILE_DATE}/WeeklyUpdate_${FILE_DATE}.docx` (not in git)
- [ ] DOCX has clickable TOC: all entries use `toc_entry_link` / `toc_sub_link` with `w:hyperlink w:anchor`
- [ ] DOCX TOC has page numbers: PAGEREF fields with dot leaders; `settings.xml` has `updateFields`
- [ ] All section headers carry `bk_sN` bookmarks; all subheadings carry `bk_sNx` bookmarks
- [ ] PDF generated at `~/Library/CloudStorage/OneDrive-Personal/1_Claude_AI/GitHub-Repos/youwequest/Professional update - weekly/${WEEK_ID}_${FILE_DATE}/WeeklyUpdate_${FILE_DATE}.pdf` via AppleScript (not in git)
- [ ] Messages file generated: `WeeklyUpdate_${FILE_DATE}_Messages.txt` with EMAIL + WHATSAPP + LINKEDIN sections populated
- [ ] `updates/index.html` card added at top, `latest-chip` moved
- [ ] `updates/UPDATES_LOG.json` updated
- [ ] `CNAME` file untouched
- [ ] Git committed and pushed to main
- [ ] Email sent to youwequest@gmail.com with DOCX attached