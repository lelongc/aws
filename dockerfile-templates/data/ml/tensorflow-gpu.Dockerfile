# TensorFlow GPU development environment
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-dev \
    git \
    curl \
    wget \
    libcudnn8 \
    build-essential \
    cmake \
    libopencv-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Set Python aliases
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

# Install core Python data science packages
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
    numpy \
    pandas \
    scipy \
    scikit-learn \
    matplotlib \
    seaborn \
    plotly \
    jupyterlab \
    ipywidgets \
    tqdm \
    pillow \
    opencv-python \
    h5py

# Install TensorFlow with GPU support
RUN pip install --no-cache-dir tensorflow==2.12.0 keras

# Install additional deep learning frameworks
RUN pip install --no-cache-dir \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 \
    transformers \
    tensorboard \
    tensorflow-datasets \
    tensorflow-hub \
    tensorflow-addons \
    tensorflow-text \
    tensorflow-probability

# Install development tools
RUN pip install --no-cache-dir \
    pytest \
    black \
    pylint \
    flake8 \
    mypy \
    isort \
    pre-commit \
    yapf \
    pytest-cov

# Create a non-root user with UID 1000 (common on most systems)
RUN useradd -m -u 1000 ml-user
RUN mkdir -p /app /data /models /notebooks && \
    chown -R ml-user:ml-user /app /data /models /notebooks

# Set working directory and switch to non-root user
WORKDIR /app
USER ml-user

# Configure Jupyter
RUN jupyter notebook --generate-config && \
    echo "c.NotebookApp.ip = '0.0.0.0'" >> /home/ml-user/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> /home/ml-user/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.allow_root = False" >> /home/ml-user/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.allow_remote_access = True" >> /home/ml-user/.jupyter/jupyter_notebook_config.py

# Expose port for JupyterLab
EXPOSE 8888

# Define volume mount points
VOLUME ["/data", "/models", "/notebooks"]

# Set environment variables
ENV PYTHONPATH=/app:$PYTHONPATH
ENV TF_FORCE_GPU_ALLOW_GROWTH=true
ENV TF_CPP_MIN_LOG_LEVEL=2

# Start JupyterLab by default
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
