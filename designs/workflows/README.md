# Scripts Directory

This directory contains utility scripts and configuration files for IC design tools and workflows.


## GDS3D Process File
`GDS3D_gf180mcu.txt` is the GDS3D process definition file with the gf180mcu layer mapping. Note that the metal and via layers are just examples and do not accurately represent the vertical metal stack dimensions.

**Usage**: 
An alias is defined in `designs/.designinit` to load the default process file.
```bash
alias GDS3D="GDS3D -p /foss/designs/scripts/GDS3D_gf180mcu.txt -i"
```
Launch GDS3D with:
```
GDS3D {gds_file}
```

## Klayout Library Management Plugin

### klayout_lib_manager.py
This script is a KLayout plugin for automatic library management and GDS file loading. The plugin
- Scans `/foss/designs/libs` for all `.gds` files
- Automatically registers a dedicated library for each gds file.
- Provides a "Reload Libraries" menu action (Ctrl+R)
- Saves library registry to `libs.json` for tracking

**Usage**
- Drag and instantiate cells from the library dropdown, don't use import gds.
- Edit gds files in different panels.
- To update the layout for all hierarchies, save the edited gds file, and click "Reload Libraries" in the menu bar.

An alias is defined in `designs/.designinit` to load the library managment plugin by default.
```bash
alias klayout='klayout -rm $DESIGNS/scripts/klayout_lib_manager.py -e'
```
Launch Klayout with:
```
klayout
```

## Notes
- The `scripts` directory is part of the system `PATH` and all the executable scripts can be invoked anywhere in the design space.
- All scripts assume the standard IIC-OSIC-TOOLS environment setup