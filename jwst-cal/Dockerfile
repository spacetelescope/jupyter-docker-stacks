# Copyright (c) Association of Universities for Research in Astronomy
# Distributed under the terms of the Modified BSD License.

FROM jupyter/scipy-notebook:dc57157d6316

# See https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html
# for a list of what comes with the base image
# python version is: 3.7.6

LABEL maintainer="Science Platforms <cbrasseur@stsci.edu>"

# Environment variables
ENV MKL_THREADING_LAYER="GNU"

#####################################################################
# Ubuntu update
#####################################################################
USER root

# Keep Ubuntu secure
RUN apt-get update -y

# Additional apt packages
RUN apt-get install curl -y

#####################################################################
# Install jwst 0.16.1 and dependencies
#####################################################################
USER $NB_UID

RUN . $CONDA_DIR/etc/profile.d/conda.sh &&\
    conda create -q -n jwst-cal --file https://ssb.stsci.edu/releases/jwstdp/0.16.1/conda_python_stable-deps.txt &&\
    conda activate jwst-cal &&\
    pip install --no-color --quiet -r https://ssb.stsci.edu/releases/jwstdp/0.16.1/reqs_stable-deps.txt &&\
    pip install --upgrade numpy &&\
    pip install matplotlib &&\
    pip install --upgrade --pre astroquery &&\
    pip install pytest &&\
    pip install ipykernel &&\
    pip install crds[aws] &&\
    pip install ipython &&\
    pip install flake8 &&\
    pip install pytest-xdist &&\
    pip install stsci-aws-utils &&\
    conda env export

# --- RUN conda create -n jwst-cal python=3.7.6
# --- # We need the pre-release version of astroquery in order to make requests of
# --- # JWST A-string MAST.
# --- RUN . $CONDA_DIR/etc/profile.d/conda.sh &&\
# ---     conda activate jwst-cal &&\
# ---     pip install --upgrade numpy &&\
# ---     pip install matplotlib &&\
# ---     pip install git+https://github.com/spacetelescope/jwst#0.16.1[test] &&\
# ---     pip install --upgrade --pre astroquery &&\
# ---     pip install pytest &&\
# ---     pip install ipykernel &&\
# ---     pip install crds[aws] &&\
# ---     pip install ipython &&\
# ---     pip install flake8 &&\
# ---     pip install pytest-xdist

#####################################################################
# Install MIRISim
#####################################################################
USER root

ENV MIRISIM_ROOT=/data/mirisim
ENV PYSYN_CDBS=$MIRISIM_ROOT/cdbs/
RUN mkdir -p /data/mirisim $MIRISIM_ROOT/cdbs &&\
   chown -R $NB_UID.$NB_GID /data/mirisim $MIRISIM_ROOT/cdbs &&\
   chmod -R 770 /data/mirisim $MIRISIM_ROOT/cdbs

USER $NB_UID

RUN curl --silent --show-error https://wiki.miricle.org/pub/Public/MirisimInstallation/mirisim_install.bash -o mirisim_install.bash &&\
    chmod +x mirisim_install.bash &&\
    ./mirisim_install.bash --version 10 &&\
    rm mirisim_install.bash

RUN . $CONDA_DIR/etc/profile.d/conda.sh &&\
    conda activate mirisim &&\
    pip install crds[aws] &&\
    pip install stsci-aws-utils &&\
    pip install ipykernel &&\
    conda env export

#####################################################################
# Install MIRaGe
#####################################################################
USER $NB_UID

ENV MIRAGE_DATA=/data/mirage
ENV WEBBPSF_PATH=/data/webbpsf

# --- COPY mirage-environment.yml /opt

# --- RUN . $CONDA_DIR/etc/profile.d/conda.sh &&\
# ---     conda env create -f /opt/mirage-environment.yml

RUN conda create -n mirage python=3.7.6 -y -q
RUN . $CONDA_DIR/etc/profile.d/conda.sh &&\
    conda activate mirage &&\
    pip install healpy==1.12.5 &&\
    pip install mirage==1.3.3 &&\
    pip install git+https://github.com/npirzkal/GRISMCONF#egg=grismconf &&\
    pip install git+https://github.com/npirzkal/NIRCAM_Gsim#egg=nircam_gsim &&\
    pip install git+https://github.com/spacetelescope/jwst#0.16.1 &&\
    pip install stsci-aws-utils &&\
    pip install crds[aws] &&\
    conda env export

#####################################################################
# conda cleanup

RUN conda clean --all -f -y -q

#####################################################################
USER root

# Setup a notebook start hook that populates the home directory.  We do this in a roundabout
# way because the EFS mount isn't available until the server actually starts in the cluster.

RUN mkdir -p /usr/local/bin/start-notebook.d
COPY apply_home_template.sh /usr/local/bin/start-notebook.d
COPY home_template /opt/home_template

# Add content to the global bashrc
COPY global_bashrc /home/jovyan
RUN cat /home/jovyan/global_bashrc >> /etc/bash.bashrc &&\
    rm /home/jovyan/global_bashrc

# Add kernel runner script that ensures conda environment is activated
COPY kernel_runner.py /opt

# Create kernel for jwst-cal environment
RUN mkdir -p /usr/local/share/jupyter/kernels/jwst-cal
COPY kernel.jwst-cal.json /usr/local/share/jupyter/kernels/jwst-cal/kernel.json
COPY logo-32x32.png /usr/local/share/jupyter/kernels/jwst-cal
COPY logo-64x64.png /usr/local/share/jupyter/kernels/jwst-cal

# Create kernel for mirisim environment
RUN mkdir -p /usr/local/share/jupyter/kernels/mirisim
COPY kernel.mirisim.json /usr/local/share/jupyter/kernels/mirisim/kernel.json
COPY logo-32x32.png /usr/local/share/jupyter/kernels/mirisim
COPY logo-64x64.png /usr/local/share/jupyter/kernels/mirisim

# Create kernel for mirage environment
RUN mkdir -p /usr/local/share/jupyter/kernels/mirage
COPY kernel.mirage.json /usr/local/share/jupyter/kernels/mirage/kernel.json
COPY logo-32x32.png /usr/local/share/jupyter/kernels/mirage
COPY logo-64x64.png /usr/local/share/jupyter/kernels/mirage

# Clean out the home directory so it mimics a fresh EFS mount (useful for developer testing)
RUN rm -rf /home/jovyan/*
RUN rm -r /home/jovyan/.[a-zA-Z_]*

COPY VERSION /opt

# USER $NB_UID

COPY import_jwst.py /opt
RUN . $CONDA_DIR/etc/profile.d/conda.sh &&\
    conda activate jwst-cal &&\
    python /opt/import_jwst.py &&\
    rm /opt/import_jwst.py

COPY import_mirisim.py /opt
RUN . $CONDA_DIR/etc/profile.d/conda.sh &&\
    conda activate mirisim &&\
    python /opt/import_mirisim.py &&\
    rm /opt/import_mirisim.py

COPY import_mirage.py /opt
RUN . $CONDA_DIR/etc/profile.d/conda.sh &&\
    conda activate mirage &&\
    python /opt/import_mirage.py &&\
    rm /opt/import_mirage.py

#####################################################################
# CRDS environment variables
#####################################################################
ENV CRDS_PATH=/home/jovyan/crds_cache
ENV CRDS_SERVER_URL=https://jwst-serverless.stsci.edu
ENV CRDS_S3_ENABLED=1
ENV CRDS_S3_RETURN_URI=0
ENV CRDS_DOWNLOAD_MODE=plugin
ENV CRDS_DOWNLOAD_PLUGIN='crds_s3_get ${SOURCE_URL} ${OUTPUT_PATH} ${FILE_SIZE} ${FILE_SHA1SUM}'
# ENV CRDS_S3_RETURN_URI=1
ENV CRDS_MAPPING_URI=s3://dmd-test-crds/mappings/jwst
ENV CRDS_REFERENCE_URI=s3://dmd-test-crds/references/jwst
ENV CRDS_CONFIG_URI=s3://dmd-test-crds/config/jwst
ENV CRDS_USE_PICKLES=0
ENV CRDS_CONTEXT=jwst_0619.pmap

