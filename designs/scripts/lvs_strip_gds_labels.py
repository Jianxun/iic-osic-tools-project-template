#!/usr/bin/env python3
# lvs_strip_gds_labels.py
#
# Strips text labels from all non-top cells for LVS.
# Usage: python lvs_strip_gds_labels.py <input.gds>
# Output: {input_basename}_lvs.gds

import pya
import os
import sys

if len(sys.argv) != 2:
    print("Usage: python lvs_strip_gds_labels.py <input.gds>")
    sys.exit(1)

IN_GDS = sys.argv[1]

# Derive top cell name and output filename from input basename
base_name = os.path.splitext(os.path.basename(IN_GDS))[0]
dir_name = os.path.dirname(IN_GDS) or "."
TOP_CELL_NAME = base_name
OUT_GDS = os.path.join(dir_name, f"{base_name}_lvs.gds")

print(f"Reading layout: {IN_GDS}")
src_layout = pya.Layout()
src_layout.read(IN_GDS)

src_top = src_layout.cell(TOP_CELL_NAME)
if src_top is None:
    print(f"Error: Top cell '{TOP_CELL_NAME}' not found in {IN_GDS}")
    sys.exit(1)

# New layout that will host a fully self-contained copy (no library links)
new_layout = pya.Layout()
new_layout.dbu = src_layout.dbu

# Create top cell in new layout and copy full hierarchy into it
new_top = new_layout.create_cell(TOP_CELL_NAME)
# copy_tree duplicates the whole cell tree into this layout, including shapes
new_top.copy_tree(src_top)

print("Hierarchy copied into new layout. Stripping lower-level labels...")

# Now strip text from all non-top cells in the *new* layout
for cell in new_layout.each_cell():
    is_top = (cell.name == TOP_CELL_NAME)
    if is_top:
        continue  # keep all labels on the top cell

    # Iterate all layer indexes in this layout
    for li in range(new_layout.layers()):
        shapes = cell.shapes(li)
        if shapes.is_empty():
            continue

        to_delete = []
        for s in shapes.each():
            if s.is_text():
                to_delete.append(s)

        for s in to_delete:
            s.delete()

print(f"Writing cleaned layout: {OUT_GDS}")
new_layout.write(OUT_GDS)
print("Done.")
