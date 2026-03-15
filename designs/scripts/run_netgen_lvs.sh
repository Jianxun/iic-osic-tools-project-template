#!/usr/bin/bash
# run_netgen_lvs.sh
#
# Based on script run_klayout_lvs.sh
# 
# Full LVS flow: netlist generation -> layout netlist extraction -> netgen LVS
# Usage: ./run_netgen_lvs.sh <cell_name>
#
# Assumes <cell_name>.sch and <cell_name>.gds exist in the current directory.

set -euo pipefail

STRIP_LABELS=0


if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <cell_name>"
  echo "  cell_name:  Name of the cell (assumes .sch and .gds exist in current directory)"
  exit 1
fi

#Variables
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

CELL="$1"
CELL_DIR="$(pwd)"
LVS_EXT_SCRIPT="${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc"
LVS_SETUP_SCRIPT="/foss/designs/scripts/${PDK}_setup.tcl"

# Input files
SCH_FILE="${CELL_DIR}/${CELL}.sch"
GDS_FILE="${CELL_DIR}/${CELL}.gds"

# LVS run directory and output files
LVS_RUN_DIR="${CELL_DIR}/netgen_lvs_run"
LVS_NETLIST="${LVS_RUN_DIR}/${CELL}.spice"
LVS_EXT_NETLIST="${LVS_RUN_DIR}/${CELL}_layout.spice"
LVS_GDS="${LVS_RUN_DIR}/${CELL}_lvs.gds"
LVS_NETGEN_SCRIPT="${LVS_RUN_DIR}/run_lvs.tcl"
LVS_COMP_FILE="${LVS_RUN_DIR}/${CELL}_comp.out"
LVS_LOG_FILE="${LVS_RUN_DIR}/netgen.log"

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
xschem_netlisting.sh --dut --netlist_dir "$LVS_RUN_DIR" --out_file "$LVS_NETLIST" "$SCH_FILE"
# Append standard cell library include for LVS (not required)
# echo ".include /foss/designs/libs/gf180mcu_fd_sc_mcu9t5v0_symbols/lvs/gf180mcu_fd_sc_mcu9t5v0_lvs.spice" >> "$LVS_NETLIST"
echo ""

# Step 2: Prepare GDS (strip labels or copy)
echo ">>> Step 2: Copying GDS (no label stripping)..."
cp "$GDS_FILE" "$LVS_GDS"
echo ""

# Step 3: Run KLayout LVS
echo ">>> Step 3: Extracting layout for LVS from magic..."
magic -dnull -noconsole -rcfile ${LVS_EXT_SCRIPT} << EOF
gds flatglob via_dev*
gds flatglob cap_mim
gds flatglob pfet*
gds flatglob nfet*
gds flatglob *_CDNS_*
gds flatglob *Bondpad*
gds flatglob *CLAMP_COR*
gds flatglob *FILL*
gds flatglob *METAL_RAIL*
gds flatglob *NMOS_*
gds flatglob *PMOS_*
gds flatglob *POWER_RAIL_COR*
gds flatglob *_BASE*
gds flatglob *comp018green_*
gds flatglob *diode_nd2ps_06v0_*[A-Z]*
gds flatglob *diode_pd2nw_06v0_*[A-Z]*
gds flatglob *mim_*_*[A-Z]*
gds flatglob *moscap_*
gds flatglob *nmos_*_*[A-Z]*
gds flatglob *nmos_4T_metal_stack*
gds flatglob *nmos_clamp_*
gds flatglob *pmos_6p0_esd_*
gds flatglob *power_via*
gds flatglob *ppolyf_u_*[A-Z]*
gds flatglob *top_route*
gds read $LVS_GDS
load $CELL
select top cell
extract path extfiles
extract all
ext2spice lvs
ext2spice -p extfiles -o ${LVS_EXT_NETLIST}
quit -noprompt
EOF


echo ">>> Step 3: Running Netgen LVS..."

cat > ${LVS_NETGEN_SCRIPT} << EOF
# Tcl script to run LVS on $CELL

if {[catch {set PDK_ROOT \$::env(PDK_ROOT)}]} {set PDK_ROOT /usr/share/pdk}
if {[catch {set PDK \$::env(PDK)}]} {set PDK gf180mcuD}

set pdklib \${PDK_ROOT}/\${PDK}
set techlibs \${pdklib}/libs.tech
set reflibs \${pdklib}/libs.ref

set setupfile ${LVS_SETUP_SCRIPT}
set sclib \${reflibs}/gf180mcu_fd_sc_mcu9t5v0/spice/gf180mcu_fd_sc_mcu9t5v0.spice

set circuit1 [readnet spice ${LVS_EXT_NETLIST}]
set circuit2 [readnet spice \$sclib]

readnet spice ${LVS_NETLIST} \$circuit2

lvs "\$circuit1 $CELL" "\$circuit2 $CELL" \\
        \$setupfile ${LVS_COMP_FILE}
EOF

netgen -batch source ${LVS_NETGEN_SCRIPT} | tee ${LVS_LOG_FILE}

echo ""
echo "=== LVS complete ==="
