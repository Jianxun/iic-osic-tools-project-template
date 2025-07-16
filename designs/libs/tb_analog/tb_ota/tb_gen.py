import yaml
from jinja2 import Environment, FileSystemLoader
import os

# Get the directory of the current script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Configuration
config_path = os.path.join(script_dir, 'sim_config.yaml')
template_dir = os.path.join(script_dir, 'templates')
template_name = 'sim_dc.j2'
# get the template base name
template_base_name = os.path.splitext(template_name)[0]
# append the template base name to the output path
output_path = os.path.join(script_dir, 'simulations', template_base_name, 'tb_netlist.spice')

# Load YAML configuration
with open(config_path, 'r') as f:
    config = yaml.safe_load(f)

# Set up Jinja2 environment
env = Environment(loader=FileSystemLoader(template_dir))
template = env.get_template(template_name)

config['parameters']['root'] = script_dir + '/'
# Render the template
output_content = template.render(parameters=config['parameters'])
# Write the output file
# Create the directory if it doesn't exist
os.makedirs(os.path.dirname(output_path), exist_ok=True)
with open(output_path, 'w') as f:
    f.write(output_content)

print(f"Successfully rendered template to {output_path}") 


# # render the run simulation script
# template_run_sim = env.get_template('run_sim.j2')
# str_run_sim = template_run_sim.render(parameters=config['parameters'])

# # Write the run simulation script
# with open(os.path.join(script_dir, 'simulations', template_base_name, 'run_sim.sh'), 'w') as f:
#     f.write(str_run_sim)
# # make the run simulation script executable
# os.chmod(os.path.join(script_dir, 'simulations', template_base_name, 'run_sim.sh'), 0o755)
# print(f"Successfully rendered run simulation script to {os.path.join(script_dir, 'simulations', template_base_name, 'run_sim.sh')}") 