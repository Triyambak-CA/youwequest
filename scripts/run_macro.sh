#!/bin/bash
# ─────────────────────────────────────────────
#  scripts/run_macro.sh — India Macro Intelligence Report
#  Run from the repo root: ./scripts/run_macro.sh
#  Auto-detects the report month.
# ─────────────────────────────────────────────

set -euo pipefail

# ── Guard: must be run from repo root ────────────────────────────────────────
if [ ! -f "CLAUDE.md" ]; then
  echo "❌  Error: run this script from the repo root (youwequest folder)"
  exit 1
fi

TODAY_DOM=$(date +%d)

# If run in first 3 days of a new month, use previous month
if [ "$TODAY_DOM" -le 3 ]; then
  REPORT_MONTH=$(date -v-1m +%B 2>/dev/null || date -d "last month" +%B)
  REPORT_YEAR=$(date -v-1m +%Y 2>/dev/null || date -d "last month" +%Y)
  REPORT_MONTH_NUM=$(date -v-1m +%m 2>/dev/null || date -d "last month" +%m)
  REPORT_YEAR_NUM=$(date -v-1m +%Y 2>/dev/null || date -d "last month" +%Y)
else
  REPORT_MONTH=$(date +%B)
  REPORT_YEAR=$(date +%Y)
  REPORT_MONTH_NUM=$(date +%m)
  REPORT_YEAR_NUM=$(date +%Y)
fi

# Last day of report month
LAST_DAY=$(python3 -c "
import calendar
m=int('$REPORT_MONTH_NUM'); y=int('$REPORT_YEAR_NUM')
print(f'{calendar.monthrange(y, m)[1]:02d}')
")

REPORT_MONTH_SHORT=$(python3 -c "
import datetime
dt = datetime.datetime.strptime('$REPORT_MONTH $REPORT_YEAR', '%B %Y')
print(dt.strftime('%b'))
")

export REPORT_MONTH
export REPORT_YEAR
export REPORT_MONTH_YEAR="$REPORT_MONTH $REPORT_YEAR"
export FILE_DATE="${LAST_DAY}${REPORT_MONTH_SHORT}${REPORT_YEAR}"
export REPORT_DATE_DISPLAY="${LAST_DAY} ${REPORT_MONTH} ${REPORT_YEAR}"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  India Macro Intelligence Report"
echo "  Report month  : $REPORT_MONTH_YEAR"
echo "  Output file   : macro/MacroReport_${FILE_DATE}.html"
echo "  DOCX file     : MacroIntel_${REPORT_MONTH}_${REPORT_YEAR}.docx"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

claude -p "
Run the macro report for $REPORT_MONTH_YEAR.

REPORT_MONTH=$REPORT_MONTH
REPORT_YEAR=$REPORT_YEAR
REPORT_MONTH_YEAR=$REPORT_MONTH_YEAR
FILE_DATE=$FILE_DATE
REPORT_DATE_DISPLAY=$REPORT_DATE_DISPLAY

All workflow instructions are in claude-docs/macro.md.
Follow all seven steps in order. Do not ask for confirmation between steps.
Confirm when complete with: HTML created · DOCX generated · site live · email sent.
"
