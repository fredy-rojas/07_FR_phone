FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04
# FROM nvidia/cuda:12.9.0-cudnn-runtime-ubuntu22.04
# FROM nvidia/cuda:12.9.0-cudnn-devel-ubuntu22.04

# Set up Python + DL stack
RUN apt-get update && \
    apt-get install -y python3.10 python3.10-venv python3.10-dev python3-pip git && \
    ln -sf /usr/bin/python3.10 /usr/bin/python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install jupyterlab==4.5.3

# Set up library for openCV 
RUN apt update && apt install -y libgl1 libglib2.0-0 && apt clean

# set up library for torchview
RUN apt install -y graphviz


# Install ffmpeg (required for torchcodec)
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy your requirements.txt into the container
COPY requirements.txt .

# Install PyTorch with CUDA 126 support first (special handling)
RUN pip install --no-cache-dir torch==2.10.0 torchvision==0.25.0 torchaudio==2.10.0 --extra-index-url https://download.pytorch.org/whl/cu126 && \
    pip install --no-cache-dir torchcodec==0.10.0

# Install remaining requirements
RUN pip install --no-cache-dir -r requirements.txt

# # Install Python packages from requirements.txt
# RUN pip install -r requirements.txt \
#     --extra-index-url https://download.pytorch.org/whl/cu117

#================
# CONSIDER TO MODIFY THE CUDA TORCH VERSION TO INSTALL TORCH VERSION 
#   compatible with transformer version 
# pip install torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 --index-url https://download.pytorch.org/whl/cu121


CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token='fredy-rojas'",  "--no-browser", "--port=8888"]
