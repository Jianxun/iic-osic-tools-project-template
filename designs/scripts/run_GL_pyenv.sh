#!/bin/bash
set -e  # Exit on error

# === Step 1: Basic environment setup ===
unset PYTHONPATH
unset LD_LIBRARY_PATH

# Define base directory for conda installation
BASE_DIR="$HOME/glayout-env"
ENV_NAME="GLdev"

#export PATH="$MINICONDA_DIR/bin:$PATH"

# === Step 2: Check if environment is already set up ===
if [ -d "$BASE_DIR/envs/$ENV_NAME" ]; then
    echo "Existing $ENV_NAME environment detected. Skipping setup."
else
    echo "$ENV_NAME environment not found. Starting setup..."

    # Create base directory
    mkdir -p "$BASE_DIR"

    # Download and install pyenv
    if [ -d $HOME/.pyenv ]; then
	      echo "pyenv already installed"
    else
	      curl -fsSL https://pyenv.run | bash
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
        echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
        echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc
    fi

    # Source Conda
    source "$HOME/.bashrc"

    # Create the environment
    cd "$BASE_DIR"

    if [ -d $HOME/.pyenv/versions/3.10.20 ]; then
	  echo "Python version already installed"
    else
        export MAKEOPTS="-j$(nproc)"
        pyenv install -v 3.10.20
    fi

    # Activate the environment
    pyenv local 3.10

    # Install packages
    pip install jupyter jupyterlab notebook nbclassic \
        jupyter_server_ydoc jupyter_server_fileid \
        numpy==1.24 matplotlib
        

    # Register the kernel
    python -m ipykernel install --user --name="$ENV_NAME"

    # Pip packages

    # Check if glayout is cloned
    
    if [ -d /foss/designs/${GLAYOUT_PATH}/${GLAYOUT_FOLDER} ]; then
        echo "gLayout folder found under /foss/designs/${GLAYOUT_PATH}/${GLAYOUT_FOLDER}"
        pip install -e /foss/designs/${GLAYOUT_PATH}/${GLAYOUT_FOLDER}
    else
        echo "gLayout repo not found, please make sure you have cloned it under designs/${GLAYOUT_PATH} foler"
    fi 

    pip install "klayout>=0.28,<0.29"
    pip install svgutils

    echo "Setup complete!"
fi

# === Step 3: Launch Jupyter ===
echo "Launching Jupyter Lab..."
#source "$MINICONDA_DIR/etc/profile.d/conda.sh"
#conda activate "$ENV_NAME"
jupyter lab --ip=0.0.0.0 --no-browser --port=8888

