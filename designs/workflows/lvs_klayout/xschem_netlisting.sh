#!/usr/bin/bash
# xschem_gen_netlist.sh
# Usage:
#   ./xschem_gen_netlist.sh [--lvs] [--dut] [--netlist_dir DIR] path/to/cell.sch

set -euo pipefail

LVS=0
DUT=0
NETLIST_DIR=""
OUT_PATH=""

# Parse options
while [[ $# -gt 0 ]]; do
  case "$1" in
    --lvs)
      LVS=1
      shift
      ;;
    --dut)
      DUT=1
      shift
      ;;
    --netlist_dir)
      NETLIST_DIR="$2"
      shift 2
      ;;
    --out_file)
      OUT_PATH="$2"
      shift 2
      ;;
    *)
      break
      ;;
  esac
done

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 [--lvs] [--dut] [--netlist_dir DIR] [--out_file FILE] path/to/cell.sch"
  exit 1
fi

SCH="$1"
if [[ ! -f "$SCH" ]]; then
  echo "Error: schematic '$SCH' not found."
  exit 1
fi

TOP="$(basename "$SCH" .sch)"
SCH_DIR="$(dirname "$SCH")"

# Set netlist directory: use provided value or default to schematic's directory
if [[ -z "$NETLIST_DIR" ]]; then
  NETLIST_DIR="$SCH_DIR"
fi

# Create netlist directory if it doesn't exist
mkdir -p "$NETLIST_DIR"

# Set output filename based on LVS mode if not passed as option
if [[ -z "$OUT_PATH" ]]; then
  if [[ $LVS -eq 1 ]]; then
    OUT="${TOP}_lvs.spice"
  else
    OUT="${TOP}.spice"
  fi
  OUT_PATH="${NETLIST_DIR}/${OUT}"
else
  OUT=$(basename $OUT_PATH)
fi

# Configure TCL variables for xschem
if [[ $LVS -eq 1 ]]; then
  TCL="set lvs_netlist 1; set netlist_dir {$NETLIST_DIR};"
else
  TCL="set lvs_netlist 0; set netlist_dir {$NETLIST_DIR};"
fi

# This might not work, assess to delete it
if [[ $DUT -eq 1 ]]; then
  TCL="set format lvs_format; set netlist_dir {$NETLIST_DIR};"
fi

xschem \
  --no_x -q -n -s \
  --tcl "$TCL" \
  --netlist_filename "$OUT" \
  "$SCH"

# Post-process netlist for DUT mode
if [[ $DUT -eq 1 ]]; then
  # Uncomment **.subckt and **.ends lines for DUT instantiation
  sed -E -i.bak 's/^\*\*\.subckt/.subckt/g; s/^\*\+\s/\+ /g; s/^\*\*\.ends/.ends/g' "$OUT_PATH"
  rm -f "${OUT_PATH}.bak"
  echo "Generated DUT netlist: ${OUT_PATH} (uncommented .subckt/.ends)"
else
  echo "Generated netlist: ${OUT_PATH}"
fi
