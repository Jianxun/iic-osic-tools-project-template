import subprocess
import os
import sys
import yaml

# --- Configuration ---
TB_ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
SIM_OUT_DIR = os.path.join(TB_ROOT_DIR, 'simulations')
TESTBENCHES_DIR = os.path.join(TB_ROOT_DIR, 'testbenches')

# --- Main Script ---
def main():
    """
    Runs an ngspice simulation for a given test.
    The test name is provided as a command-line argument.
    """
    # 1. Get test name from command-line arguments
    if len(sys.argv) < 2:
        print("Error: No test name provided.")
        print("Usage: python3 tb_sim.py <test_name>")
        sys.exit(1)
    test_name = sys.argv[1]
    print(f"--- Running simulation for test: {test_name} ---")

    # 2. Define paths based on the test name
    sim_dir = os.path.join(SIM_OUT_DIR, test_name)
    netlist_path = os.path.join(sim_dir, 'tb_netlist.spice')
    config_path = os.path.join(TESTBENCHES_DIR, test_name, 'config.yaml')

    if not os.path.isfile(netlist_path):
        print(f"Error: Netlist not found at '{netlist_path}'")
        print("Please run the netlist generator first (tb_gen.py).")
        sys.exit(1)

    # 3. Read the config to know which output file to expect
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)
    output_file = config['parameters'].get('output_file', 'results.raw')
    output_path = os.path.join(sim_dir, output_file)

    # 4. Run the simulation using subprocess
    print(f"Executing ngspice on: {netlist_path}")
    process = subprocess.run(
        ["/foss/tools/ngspice/bin/ngspice", "-b", netlist_path],
        capture_output=True,
        text=True,
        cwd=sim_dir  # Run ngspice from the simulation directory
    )

    # 5. Check for simulation errors and existence of output file
    if process.returncode != 0 or not os.path.exists(output_path):
        print("❌ Simulation Failed!")
        if process.returncode != 0:
            print(f"  - ngspice exited with a non-zero return code: {process.returncode}")
        if not os.path.exists(output_path):
            print(f"  - Expected output file not found at: {output_path}")

        print("\n--- NGSPICE STDOUT ---")
        print(process.stdout)
        print("\n--- NGSPICE STDERR ---")
        print(process.stderr)
        sys.exit(1)
    else:
        print(f"✅ Simulation completed successfully. Output at {output_path}")

    print("--- Simulation run complete ---")

if __name__ == "__main__":
    main()