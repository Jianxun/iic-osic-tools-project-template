import yaml
from jinja2 import Environment, FileSystemLoader
import os
import sys

# --- Configuration ---
TB_ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
TESTBENCHES_DIR = os.path.join(TB_ROOT_DIR, 'testbenches')
SIM_OUT_DIR = os.path.join(TB_ROOT_DIR, 'simulations')

# --- Main Script ---
def main():
    """
    Generates a SPICE netlist for a given test.
    The test name is provided as a command-line argument.
    """
    # 1. Get test name from command-line arguments
    if len(sys.argv) < 2:
        print("Error: No test name provided.")
        print("Usage: python3 tb_gen.py <test_name>")
        sys.exit(1)
    test_name = sys.argv[1]
    print(f"--- Generating netlist for test: {test_name} ---")

    # 2. Define paths based on the test name
    test_dir = os.path.join(TESTBENCHES_DIR, test_name)
    config_path = os.path.join(test_dir, 'config.yaml')
    template_path = os.path.join(test_dir, 'template.j2')
    output_dir = os.path.join(SIM_OUT_DIR, test_name)
    output_netlist_path = os.path.join(output_dir, 'tb_netlist.spice')

    if not os.path.isdir(test_dir):
        print(f"Error: Testbench directory not found at '{test_dir}'")
        sys.exit(1)

    # 3. Load YAML configuration
    print(f"Loading config from: {config_path}")
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)

    # 4. Add the root path to the parameters
    config['parameters']['root'] = f"{TB_ROOT_DIR}/"
    print(f"Injecting 'root' parameter: {config['parameters']['root']}")
    
    # 5. Ensure the simulation output directory exists
    print(f"Ensuring output directory exists: {output_dir}")
    os.makedirs(output_dir, exist_ok=True)

    # 6. Set up Jinja2 environment and render the template
    print(f"Loading template from: {template_path}")
    env = Environment(loader=FileSystemLoader(os.path.dirname(template_path)), trim_blocks=True, lstrip_blocks=True)
    template = env.get_template(os.path.basename(template_path))
    
    output_content = template.render(parameters=config['parameters'])

    # 7. Write the output file
    with open(output_netlist_path, 'w') as f:
        f.write(output_content)

    print(f"✅ Successfully rendered template to: {output_netlist_path}")
    print("--- Netlist generation complete ---")

if __name__ == "__main__":
    main() 