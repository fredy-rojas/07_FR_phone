FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04
# FROM nvidia/cuda:12.9.0-cudnn-runtime-ubuntu22.04
# FROM nvidia/cuda:12.9.0-cudnn-devel-ubuntu22.04

# Set up Python + DL stack
RUN apt-get update && \
    apt-get install -y python3.10 python3.10-venv python3.10-dev python3-pip git && \
    ln -sf /usr/bin/python3.10 /usr/bin/python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install jupyterlab==4.4.2

# Set up library for openCV 
RUN apt update && apt install -y libgl1 libglib2.0-0 && apt clean

# set up library for torchview
RUN apt install -y graphviz

# Set working directory
WORKDIR /workspace

# Copy your requirements.txt into the container
COPY requirements.txt .
# Install Python packages from requirements.txt
RUN pip install -r requirements.txt \
    --extra-index-url https://download.pytorch.org/whl/cu117


CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token='fredy-rojas'",  "--no-browser", "--port=8888"]
