import wave_view as wv
import os
# get the script directory
script_dir = os.path.dirname(os.path.abspath(__file__))

# get the simulation directory
sim_dir = os.path.join(script_dir, 'simulations', 'sim_dc')

data, metadata = wv.load_spice_raw(os.path.join(sim_dir, 'results.raw'))
#print(data)
spec = wv.PlotSpec.from_yaml("""
title: "DC Analysis"
x: 
  label: "Input Voltage (V)"
  signal: "v(v-sweep)"
y:
  - label: "Output Voltage (V)"
    signals:
      OUT: "v(out)"
      IN:  "v(in)"
""")

fig = wv.plot(data, spec)
fig.show()