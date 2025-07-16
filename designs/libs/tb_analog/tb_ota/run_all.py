import os
import sys
import subprocess

# --- Configuration ---
TB_ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
TESTBENCHES_DIR = os.path.join(TB_ROOT_DIR, 'testbenches')

# --- Main Script ---
def run_command(command, test_name):
    """Runs a command and checks for errors."""
    print(f"\n--- Running {command[1]} for test '{test_name}' ---")
    process = subprocess.run(command, capture_output=True, text=True)
    if process.returncode != 0:
        print(f"❌ Error running {command[1]} for test '{test_name}'.")
        print("--- STDOUT ---")
        print(process.stdout)
        print("--- STDERR ---")
        print(process.stderr)
        return False
    print(process.stdout)
    return True

def main():
    """
    Main orchestrator to run the simulation workflow.
    - Scans for tests in the 'testbenches' directory.
    - Runs gen, sim, and post-processing for specified (or all) tests.
    """
    # 1. Discover available tests
    try:
        available_tests = [d for d in os.listdir(TESTBENCHES_DIR) if os.path.isdir(os.path.join(TESTBENCHES_DIR, d))]
    except FileNotFoundError:
        print(f"Error: 'testbenches' directory not found at {TESTBENCHES_DIR}")
        sys.exit(1)

    # 2. Determine which tests to run
    args = sys.argv[1:]
    run_post_processing = "--no-plots" not in args
    if not run_post_processing:
        args.remove("--no-plots")
        print("--- Post-processing will be skipped. ---")

    tests_to_run = args if args else available_tests
    
    invalid_tests = [t for t in tests_to_run if t not in available_tests]
    if invalid_tests:
        print(f"Error: The following specified tests do not exist: {', '.join(invalid_tests)}")
        print(f"Available tests are: {', '.join(available_tests)}")
        sys.exit(1)

    print(f"--- Starting simulation workflow for tests: {', '.join(tests_to_run)} ---")
    
    # 3. Run the workflow for each test
    for test in tests_to_run:
        print(f"\n=============================================")
        print(f"====== Starting Test: {test.upper()}")
        print(f"=============================================")

        # --- Generation Step ---
        gen_success = run_command(["python3", "tb_gen.py", test], test)
        if not gen_success:
            continue # Move to next test if generation fails

        # --- Simulation Step ---
        sim_success = run_command(["python3", "tb_sim.py", test], test)
        if not sim_success:
            continue # Move to next test if simulation fails

        # --- Post-Processing Step ---
        if run_post_processing:
            post_command = ["python3", "tb_post.py", test, "--save-fig"]
            run_command(post_command, test)
        else:
            print(f"\n--- Skipping post-processing for test '{test}' as requested. ---")

    print("\n=============================================")
    print("====== Workflow Complete ======")
    print("=============================================")

if __name__ == "__main__":
    main() 