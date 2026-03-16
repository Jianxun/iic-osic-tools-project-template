#!/usr/bin/env python3
"""
Render xschem rectangular symbol from YAML definition.

Usage:
    python render_symbol.py symbol_def.yaml [--pins-sch]
    
    --pins-sch: Generate a _pins.sch file with all pin declarations
"""

import yaml
import argparse
from pathlib import Path


def generate_pins_schematic(sch_path, pins):
    """Generate xschem schematic file with pin declarations."""
    lines = []
    lines.append('v {xschem version=3.4.7 file_version=1.2}')
    lines.append('G {}')
    lines.append('K {}')
    lines.append('V {}')
    lines.append('S {}')
    lines.append('E {}')
    
    # Group pins by direction
    dir_to_symbol = {
        'in': 'ipin.sym',
        'out': 'opin.sym',
        'inout': 'iopin.sym'
    }
    
    # Layout pins in columns by direction
    y_start = 0
    y_spacing = 20
    x_col = 0
    x_spacing = 300
    
    current_dir = None
    y_pos = y_start
    
    for pin in pins:
        pin_dir = pin['dir']
        pin_name = pin['name']
        
        # Start new column if direction changes
        if current_dir != pin_dir:
            if current_dir is not None:
                x_col += x_spacing
            current_dir = pin_dir
            y_pos = y_start
        
        # Get the symbol for this pin direction
        symbol = dir_to_symbol.get(pin_dir, 'iopin.sym')
        
        # Add pin component
        lines.append(f'C {{{symbol}}} {x_col} {y_pos} 0 0 {{name=p{len(lines)-5} lab={pin_name}}}')
        
        y_pos += y_spacing
    
    # Write output
    with open(sch_path, 'w') as f:
        f.write('\n'.join(lines))
        f.write('\n')


def render_symbol(yaml_path, generate_pins_sch=False):
    """Generate xschem symbol from YAML definition."""
    # Read YAML
    with open(yaml_path, 'r') as f:
        config = yaml.safe_load(f)
    
    symbol_name = config.get('symbol_name', 'output.sym')
    output_path = yaml_path.parent / symbol_name
    margins = config.get('margins', {})
    m_top = margins.get('top', 10)
    m_left = margins.get('left', 10)
    m_right = margins.get('right', 10)
    m_bottom = margins.get('bottom', 10)
    
    pins_config = config.get('pins', {})
    pins_top = pins_config.get('top', [])
    pins_bottom = pins_config.get('bottom', [])
    pins_left = pins_config.get('left', [])
    pins_right = pins_config.get('right', [])
    
    # Pin spacing
    spacing = 20
    
    # Calculate dimensions
    width = max(len(pins_top), len(pins_bottom)) * spacing + m_left + m_right
    height = max(len(pins_left), len(pins_right)) * spacing + m_top + m_bottom
    
    # Default minimum dimensions
    width = max(width, 100)
    height = max(height, 100)
    
    # Collect all pins with positions
    pins = []
    pinlist = []
    
    def parse_pin(pin_def):
        """Parse pin definition (can be dict with single key or just string)."""
        if pin_def is None:
            return None, None
        if isinstance(pin_def, dict):
            pin_name = list(pin_def.keys())[0]
            pin_dir = pin_def[pin_name].get('dir', 'inout')
            return pin_name, pin_dir
        return str(pin_def), 'inout'
    
    # Top pins
    for i, pin_def in enumerate(pins_top):
        pin_name, pin_dir = parse_pin(pin_def)
        if pin_name is not None:
            x = m_left + (i + 0.5) * spacing
            y = 0
            pins.append({'name': pin_name, 'dir': pin_dir, 'x': x, 'y': y, 'side': 'top'})
            pinlist.append(pin_name)
    
    # Left pins
    for i, pin_def in enumerate(pins_left):
        pin_name, pin_dir = parse_pin(pin_def)
        if pin_name is not None:
            x = 0
            y = m_top + (i + 0.5) * spacing
            pins.append({'name': pin_name, 'dir': pin_dir, 'x': x, 'y': y, 'side': 'left'})
            pinlist.append(pin_name)
    
    # Right pins
    for i, pin_def in enumerate(pins_right):
        pin_name, pin_dir = parse_pin(pin_def)
        if pin_name is not None:
            x = width
            y = m_top + (i + 0.5) * spacing
            pins.append({'name': pin_name, 'dir': pin_dir, 'x': x, 'y': y, 'side': 'right'})
            pinlist.append(pin_name)
    
    # Bottom pins
    for i, pin_def in enumerate(pins_bottom):
        pin_name, pin_dir = parse_pin(pin_def)
        if pin_name is not None:
            x = m_left + (i + 0.5) * spacing
            y = height
            pins.append({'name': pin_name, 'dir': pin_dir, 'x': x, 'y': y, 'side': 'bottom'})
            pinlist.append(pin_name)
    
    # Generate xschem symbol
    lines = []
    lines.append('v {xschem version=3.4.7 file_version=1.2}')
    lines.append('G {}')
    lines.append('K {type=subcircuit')
    lines.append(f'format="@name @pinlist @symname"')
    lines.append('template="name=x1"')
    lines.append('}')
    lines.append('V {}')
    lines.append('S {}')
    lines.append('E {}')
    
    # Pin boxes (5x5 squares centered at pin position)
    for pin in pins:
        x, y = pin['x'], pin['y']
        lines.append(f"B 5 {x-2.5:.1f} {y-2.5:.1f} {x+2.5:.1f} {y+2.5:.1f} {{name={pin['name']} dir={pin['dir']}}}")
    
    # Rectangle body
    lines.append(f'P 4 5 0 0 {width:.0f} 0 {width:.0f} {height:.0f} 0 {height:.0f} 0 0 {{}}')
    
    # Text labels - outside top right corner
    lines.append(f'T {{@symname}} {width+10:.0f} -5 0 0 0.2 0.2 {{}}')
    lines.append(f'T {{@name}} {width+10:.0f} 5 0 0 0.2 0.2 {{}}')
    
    # Pin labels
    for pin in pins:
        x, y = pin['x'], pin['y']
        side = pin['side']
        if side == 'top':
            # Rotated 90° CCW, inside symbol, left-aligned with offset
            tx, ty, rotation, anchor = x + 5, y + 8, 1, 0
        elif side == 'bottom':
            # Rotated 90° CCW, inside symbol, center-aligned with offset
            tx, ty, rotation, anchor = x + 5, y - 8, 1, 2
        elif side == 'left':
            # Horizontal, right of pin (inside)
            tx, ty, rotation, anchor = x + 8, y - 4, 0, 0
        else:  # right
            # Horizontal, left of pin (inside)
            tx, ty, rotation, anchor = x - 8, y - 4, 0, 1
        lines.append(f"T {{{pin['name']}}} {tx:.0f} {ty:.0f} {rotation} {anchor} 0.2 0.2 {{}}")
    
    # Write output
    with open(output_path, 'w') as f:
        f.write('\n'.join(lines))
        f.write('\n')
    
    print(f"Generated {output_path} with {len(pins)} pins")
    print(f"Dimensions: {width}x{height}")
    
    # Generate pins schematic if requested
    if generate_pins_sch:
        pins_sch_name = symbol_name.replace('.sym', '_pins.sch')
        pins_sch_path = yaml_path.parent / pins_sch_name
        generate_pins_schematic(pins_sch_path, pins)
        print(f"Generated {pins_sch_path} with pin declarations")


def main():
    parser = argparse.ArgumentParser(description='Render xschem rectangular symbol from YAML')
    parser.add_argument('yaml_file', help='Input YAML definition file')
    parser.add_argument('--pins-sch', action='store_true', 
                        help='Generate a _pins.sch schematic file with pin declarations')
    
    args = parser.parse_args()
    
    yaml_path = Path(args.yaml_file).resolve()
    
    if not yaml_path.exists():
        print(f"Error: YAML file not found: {yaml_path}")
        return 1
    
    render_symbol(yaml_path, generate_pins_sch=args.pins_sch)


if __name__ == '__main__':
    main()

