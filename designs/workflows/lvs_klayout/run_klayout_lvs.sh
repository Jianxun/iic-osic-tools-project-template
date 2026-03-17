#!/usr/bin/bash
# run_klayout_lvs.sh
# 
# Full LVS flow: netlist generation -> GDS label stripping -> KLayout LVS
# Usage: ./run_klayout_lvs.sh [--no-strip] <cell_name> <lvs_sub>
#
# Assumes <cell_name>.sch and <cell_name>.gds exist in the current directory.

set -euo pipefail

STRIP_LABELS=1

# Parse options
while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-strip)
      STRIP_LABELS=0
      shift
      ;;
    *)
      break
      ;;
  esac
done

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 [--no-strip] <cell_name> <lvs_sub>"
  echo "  --no-strip: Skip GDS label stripping (use original GDS)"
  echo "  cell_name:  Name of the cell (assumes .sch and .gds exist in current directory)"
  echo "  lvs_sub:    Substrate net name (e.g., VSS, gf180mcu_gnd)"
  exit 1
fi

CELL="$1"
LVS_SUB="$2"
CELL_DIR="$(pwd)"
LVS_SCRIPT="/foss/pdks/gf180mcuD/libs.tech/klayout/lvs/run_lvs.py"

# Input files
SCH_FILE="${CELL_DIR}/${CELL}.sch"
GDS_FILE="${CELL_DIR}/${CELL}.gds"

# LVS run directory and output files
LVS_RUN_DIR="${CELL_DIR}/klayout_lvs_run"
LVS_NETLIST="${LVS_RUN_DIR}/${CELL}_lvs.spice"
LVS_GDS="${LVS_RUN_DIR}/${CELL}_lvs.gds"

# Check input files exist
if [[ ! -f "$SCH_FILE" ]]; then
  echo "Error: Schematic file not found: $SCH_FILE"
  exit 1
fi

if [[ ! -f "$GDS_FILE" ]]; then
  echo "Error: GDS file not found: $GDS_FILE"
  exit 1
fi

# Create lvs_run directory
mkdir -p "$LVS_RUN_DIR"

echo "=== LVS Flow for: $CELL ==="
echo ""

echo "LVS_RUN_DIR: $LVS_RUN_DIR"
# Step 1: Generate LVS netlist from schematic
echo ">>> Step 1: Generating LVS netlist..."
xschem_netlisting.sh --lvs --netlist_dir "$LVS_RUN_DIR" "$SCH_FILE"
# Append standard cell library include for LVS
echo ".include /foss/designs/libs/gf180mcu_fd_sc_mcu9t5v0/lvs/gf180mcu_fd_sc_mcu9t5v0_lvs.spice" >> "$LVS_NETLIST"
echo ""

# Step 2: Prepare GDS (strip labels or copy)
if [[ $STRIP_LABELS -eq 1 ]]; then
  echo ">>> Step 2: Stripping GDS labels..."
  cp "$GDS_FILE" "${LVS_RUN_DIR}/${CELL}.gds"
  lvs_strip_gds_labels.py "${LVS_RUN_DIR}/${CELL}.gds"
  rm "${LVS_RUN_DIR}/${CELL}.gds"
else
  echo ">>> Step 2: Copying GDS (no label stripping)..."
  cp "$GDS_FILE" "$LVS_GDS"
fi
echo ""

# Step 3: Run KLayout LVS
echo ">>> Step 3: Running KLayout LVS..."
python "${LVS_SCRIPT}" \
  --layout="$LVS_GDS" \
  --netlist="$LVS_NETLIST" \
  --variant=D \
  --run_dir="$LVS_RUN_DIR" \
  --topcell="$CELL" \
  --lvs_sub="$LVS_SUB" \
  --run_mode=flat \
  --schematic_simplify

echo ""
echo "=== LVS complete ==="
