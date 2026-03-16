import json
import os
from pya import Application, Action, Library

def find_gds_files(root_dir):
    """Find all GDS files under the specified directory."""
    gds_files = {}
    for dirpath, dirnames, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith('.gds'):
                full_path = os.path.join(dirpath, filename)
                parent_dir = os.path.basename(os.path.dirname(dirpath))
                library_name = f"{parent_dir}_{filename.split('.')[0]}"
                gds_files[library_name] = full_path
    return gds_files

def load_libraries(libs):
    for name, path in libs.items():
        if not name.strip() or not os.path.exists(path):
            continue
        lib = Library()
        lib.layout().read(path)
        lib.description = ""
        lib.register(name)

def reload_libraries():
    root_dir = "/foss/designs/libs"
    libs = find_gds_files(root_dir)
    # Load libraries directly from gds_files
    load_libraries(libs)
    load_libraries(libs) # load twice to refresh all library linked cells.
    
    # Save to libs.json for record
    json_path = os.path.join(root_dir, "libs.json")
    try:
        with open(json_path, "w") as f:
            json.dump(libs, f, indent=2)
        print(f"Saved {json_path} with {len(libs)} entries.")
    except Exception as e:
        print(f"Error writing {json_path}: {e}")
        return

reload_action = Action()
reload_action.title = "Reload Libraries"
reload_action.shortcut = "Ctrl+R"
reload_action.on_triggered = reload_libraries

app = Application.instance()
menu = app.main_window().menu()
menu.insert_item("@toolbar.end", "reload_libraries", reload_action)