#!/bin/bash
# check_netlisting.sh
# Batch netlist all schematic files under specified directory
# All netlists are saved to designs/simulations/netlists_check
# Usage:
#   ./check_netlisting.sh [directory]
#   Default directory: . (current directory)

# Get the script's directory for relative path calculations
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Get target directory from argument or default to current directory
TARGET_DIR="${1:-.}"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: Directory '$TARGET_DIR' not found"
  exit 1
fi

# Output directory for all netlists
NETLIST_DIR="$SCRIPT_DIR/../simulations/netlists_check"
mkdir -p "$NETLIST_DIR"

echo "Searching in: $(cd "$TARGET_DIR" && pwd)"
echo "Generating netlists to: $NETLIST_DIR"
echo ""

# Change to target directory
cd "$TARGET_DIR"

# Counters
total=0
errors=0
has_libs_prefix=false

# Use process substitution to avoid subshell issue with pipe
while read -r sch_file; do
  ((total++))
  base_name=$(basename "$sch_file" .sch)
  
  # Capture output from netlisting
  output=$("$SCRIPT_DIR/xschem_netlisting.sh" --netlist_dir "$NETLIST_DIR" "$sch_file" 2>&1)
  
  # Check for errors (case insensitive)
  error_lines=$(echo "$output" | grep -i -E "symbol not found|error")
  
  if [[ -n "$error_lines" ]]; then
    ((errors++))
    echo "✗ $sch_file"
    echo "$error_lines" | sed 's/^/  /'
    echo ""
    
    # Check if any error mentions "libs"
    if echo "$error_lines" | grep -q "libs"; then
      has_libs_prefix=true
    fi
  else
    echo "✓ $sch_file"
  fi
done < <(find . -name "*.sch" -type f)

echo ""
echo "Netlisting complete."

# Suggest using remove_libs_prefix.sh if libs/ prefix detected
if [[ "$has_libs_prefix" == true ]]; then
  echo ""
  echo "  WARNING: Detected 'libs/' prefix in symbol paths."
  echo "    Run this script to fix the symbol paths in the schematic files:"
  echo "    remove_libs_prefix.sh"
fi

