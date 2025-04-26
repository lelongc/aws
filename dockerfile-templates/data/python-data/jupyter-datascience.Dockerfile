# Jupyter Notebook Data Science environment with Python, R, and Julia
FROM jupyter/datascience-notebook:latest

USER root

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    graphviz \
    libgraphviz-dev \
    pkg-config \
    ffmpeg \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER $NB_UID

# Install additional Python packages for data science
RUN pip install --no-cache-dir \
    tensorflow \
    keras \
    torch \
    torchvision \
    transformers \
    prophet \
    plotly \
    dash \
    streamlit \
    pyspark \
    pycaret \
    xgboost \
    lightgbm \
    catboost \
    shap \
    lime \
    mlflow \
    dask \
    pyarrow \
    fastapi \
    uvicorn \
    databricks-cli \
    awscli \
    google-cloud-bigquery \
    google-cloud-storage \
    azure-storage-blob \
    requests-html \
    beautifulsoup4 \
    geopy \
    geopandas \
    folium \
    pygraphviz \
    opencv-python-headless \
    sqlalchemy \
    psycopg2-binary \
    pymongo \
    redis \
    elasticsearch \
    networkx \
    spacy

# Install JupyterLab extensions
RUN jupyter labextension install \
    @jupyter-widgets/jupyterlab-manager \
    jupyterlab-plotly \
    @jupyterlab/toc

# Install spaCy language models
RUN python -m spacy download en_core_web_sm
RUN python -m spacy download en_core_web_md

# Set up work directory
WORKDIR /home/$NB_USER/work

# Configure Jupyter
COPY jupyter_notebook_config.py /etc/jupyter/

# Expose port for Jupyter
EXPOSE 8888

# Start Jupyter Lab
# WARNING: Running without a token in production is insecure
# For production, use: CMD ["start-notebook.sh"]
CMD ["start-notebook.sh", "--NotebookApp.token=''"]
