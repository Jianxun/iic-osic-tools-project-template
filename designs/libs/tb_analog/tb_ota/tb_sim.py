import subprocess
import os

# get the script directory
script_dir = os.path.dirname(os.path.abspath(__file__))

# get the simulation directory
sim_dir = os.path.join(script_dir, 'simulations', 'sim_dc')

# Run the simulation
print("Running simulation...")
# run ngspice with subprocess
subprocess.run(["ngspice", "-b", "-q", os.path.join(sim_dir, 'tb_netlist.spice')], stdout=subprocess.PIPE, stderr=subprocess.PIPE)