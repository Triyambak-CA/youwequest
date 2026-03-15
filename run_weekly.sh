#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# run_weekly.sh — YouWe Quest LLP Weekly Regulatory Update
# Run every Friday evening from your repo root: ./run_weekly.sh
# ─────────────────────────────────────────────────────────────────────────────

set -e

# ── Auto-calculate dates ──────────────────────────────────────────────────────
# macOS date syntax (use GNU date on Linux: date -d "6 days ago")
TODAY_FULL=$(date +"%d %B %Y")                    # e.g. 20 March 2026
TODAY_ISO=$(date +"%Y-%m-%d")                     # e.g. 2026-03-20
SAT_DATE=$(date -v-6d +"%d %B %Y")               # last Saturday (6 days ago)
SAT_DATE_SHORT=$(date -v-6d +"%d %b %Y")         # e.g. 14 Mar 2026
FRI_DATE_SHORT=$(date +"%d %b %Y")               # e.g. 20 Mar 2026
WEEK_NUM=$(date +"%V")                            # ISO week number e.g. 12
YEAR=$(date +"%Y")                                # e.g. 2026
FILE_DATE=$(date +"%d%b%Y")                       # e.g. 20Mar2026
WEEK_ID="W${WEEK_NUM}-${YEAR}"                    # e.g. W12-2026

# ── Guard: must be run from repo root ────────────────────────────────────────
if [ ! -f "CLAUDE.md" ]; then
  echo "❌  Error: run this script from the repo root (youwequest.com folder)"
  exit 1
fi

if [ ! -d "updates" ]; then
  echo "❌  Error: updates/ folder not found"
  exit 1
fi

# ── Summary ──────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  YouWe Quest LLP — Weekly Regulatory Update"
echo "  Week:    ${WEEK_ID}"
echo "  Period:  ${SAT_DATE} to ${TODAY_FULL}"
echo "  Files:   WeeklyUpdate_Web_v2_${FILE_DATE}.html"
echo "           WeeklyUpdate_Merged_${WEEK_ID}_${FILE_DATE}.docx"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Pass to Claude Code non-interactively ────────────────────────────────────
claude -p "
Today is ${TODAY_FULL}. Run the weekly regulatory update for YouWe Quest LLP.

WEEK_ID=${WEEK_ID}
WEEK_PERIOD=${SAT_DATE} to ${TODAY_FULL}
FILE_DATE=${FILE_DATE}
TODAY_ISO=${TODAY_ISO}
SAT_DATE=${SAT_DATE_SHORT}
FRI_DATE=${FRI_DATE_SHORT}

All output specs, design rules, branding, workflow steps, and the full
checklist are documented in CLAUDE.md under the section:
'Weekly Regulatory Update — Automated Workflow'.

Follow that section exactly — all five steps in order:
1. Research all six sources for this week's period
2. Generate both output files (HTML + DOCX) using the variables above
3. Update the archive (updates/index.html + updates/UPDATES_LOG.json)
4. Commit and push to main
5. Send email to youwequest@gmail.com with DOCX attached

Do not ask for confirmation between steps — run all five end to end.
Confirm when complete with: files generated · site live · email sent.
"
