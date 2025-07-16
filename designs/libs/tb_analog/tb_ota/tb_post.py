import wave_view as wv
import os
import sys
import glob

# --- Configuration ---
TB_ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
SIM_OUT_DIR = os.path.join(TB_ROOT_DIR, 'simulations')
TESTBENCHES_DIR = os.path.join(TB_ROOT_DIR, 'testbenches')

# --- Main Script ---
def main():
    """
    Loads simulation results and generates plots based on all *.yaml
    specifications found in the test's 'plots' subdirectory.
    Usage: python3 tb_post.py <test_name> [--save-fig]
    """
    # 1. Get test name and options from command-line arguments
    if len(sys.argv) < 2:
        print("Error: No test name provided.")
        print("Usage: python3 tb_post.py <test_name> [--save-fig]")
        sys.exit(1)
    test_name = sys.argv[1]
    save_figure = "--save-fig" in sys.argv
    print(f"--- Post-processing results for test: {test_name} ---")

    # 2. Define paths
    sim_dir = os.path.join(SIM_OUT_DIR, test_name)
    results_path = os.path.join(sim_dir, 'results.raw')
    plots_dir = os.path.join(TESTBENCHES_DIR, test_name, 'plots')

    if not os.path.isfile(results_path):
        print(f"Error: Results file not found at '{results_path}'")
        sys.exit(1)
    
    if not os.path.isdir(plots_dir):
        print(f"Info: No 'plots' directory found at '{plots_dir}'. Nothing to process.")
        return

    # 3. Discover all plot specification files
    plot_spec_files = glob.glob(os.path.join(plots_dir, '*.yaml'))
    if not plot_spec_files:
        print(f"Info: No plot specification (*.yaml) files found in '{plots_dir}'.")
        return
        
    print(f"Found {len(plot_spec_files)} plot specifications.")

    # 4. Load simulation data (only once)
    print(f"Loading simulation data from: {results_path}")
    data, metadata = wv.load_spice_raw(results_path)

    # 5. Process each plot specification
    for spec_file in plot_spec_files:
        spec_name = os.path.splitext(os.path.basename(spec_file))[0]
        print(f"\n--- Processing plot spec: {spec_name} ---")
        try:
            # Create plot from specification file
            spec = wv.PlotSpec.from_file(spec_file)
            fig = wv.plot(data, spec) # This returns a plotly go.Figure object
            print(f"Plot '{spec.title}' generated successfully.")

            # Show or save the plot
            if save_figure:
                output_plot_path = os.path.join(sim_dir, f'{spec_name}.html')
                print(f"Saving plot to: {output_plot_path}")
                fig.write_html(output_plot_path)
                print("✅ Plot saved.")
            else:
                print("Displaying plot. Close the window to continue.")
                fig.show()
        except Exception as e:
            print(f"❌ Error processing spec file {spec_file}: {e}")

    print("\n--- All post-processing complete ---")

if __name__ == "__main__":
    main()