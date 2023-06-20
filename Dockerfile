FROM nvidia/cuda:11.8.0-devel-ubuntu20.04

# Set bash as default shell
ENV SHELL=/bin/bash

# Create a working directory
WORKDIR /app/

# Build with some basic utilities
RUN apt-get update && apt-get install -y \
    python3-pip \
    apt-utils \
    vim \
    git \
    wget

# alias python='python3'
RUN ln -s /usr/bin/python3 /usr/bin/python
ENV CONDA_DIR /opt/conda

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
		/bin/bash ~/miniconda.sh -b -p /opt/conda

ENV PATH=$CONDA_DIR/bin:$PATH

### Jupyter deps & utilities
RUN conda install -c conda-forge jupyterlab neptune-client matplotlib ipywidgets
### Pytorch base deps
RUN conda install pytorch==1.12.0 torchvision==0.13.0 torchaudio==0.12.0 cudatoolkit=11.6 -c pytorch -c conda-forge
### pytorch lightning utilities
RUN conda install -c conda-forge pytorch-lightning py pygraphviz
RUN conda install pyg==2.0.4 -c pyg

## Pip deps for torch-geometric-temporal
RUN pip install torch-geometric-temporal==0.5.3

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser"]
EXPOSE 8888
