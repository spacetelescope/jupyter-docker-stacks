# Copyright (c) Association of Universities for Research in Astronomy
# Distributed under the terms of the Modified BSD License.

# FROM jupyter/scipy-notebook:a238993ad594
FROM jupyter/scipy-notebook:dc57157d6316

# See https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html
# for a list of what comes with the base image
# python version is: 3.7.6

LABEL maintainer="Science Platforms <cbrasseur@stsci.edu>"

# Environment Variables
ENV MKL_THREADING_LAYER="GNU"

# Installing all the unix stuff
USER root
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y gcc \
   g++ \
   gfortran \
   vim \
   ssh \
   htop \
   sysstat \
   imagemagick \
   curl \
   libcurl4-openssl-dev \
   libxml2 \
   libxml2-dev \
   libxslt1.1 \
   libxslt1-dev \
   python-libxml2 \
   python-libxslt1 \
   python-dev \
   python-setuptools \
   file \
   libcfitsio-bin \
   libcfitsio-dev

RUN easy_install lxml

# IMPORTANT
RUN apt-get install -y build-essential
USER $NB_UID

# Add astropy, astroconda, and conda-forge channels
RUN conda config -q --add channels astropy
RUN conda config -q --add channels http://ssb.stsci.edu/astroconda
RUN conda config -q --add channels conda-forge

# Install conda packages
RUN conda update -q -y \
   conda

RUN conda install -q -y \
   numpy \
   astropy \
   mkl-service \
   plotly \
   pymc3 \
   boto3 \
   emcee \
   starry \
   ginga

# Problematic pip install due to pybind11 issues
RUN conda install -q -y -c conda-forge \
    pybind11 \
    george
RUN conda install -q -y -c conda-forge \
    celerite

# pip packages
RUN pip install --no-color  --upgrade pip
RUN pip install --no-color  ipyevents
RUN pip install --no-color  --pre astroquery --upgrade
RUN pip install --no-color  exoplanet
RUN pip install --no-color  astrocut
RUN pip install --no-color  eleanor
RUN pip install --no-color  tele-scope
RUN pip install --no-color  corner
RUN pip install --no-color  bls.py
RUN pip install --no-color  k2flix
RUN pip install --no-color  lightkurve[all]

RUN pip install --no-color  Pyriod
RUN pip install --no-color  juliet
RUN pip install --no-color  pyvo
RUN pip install --no-color  pyvodb
RUN pip install --no-color  allesfitter
RUN pip install --no-color  astroML
RUN pip install --no-color  astroML_addons
RUN pip install --no-color  requests
RUN pip install --no-color  panel
RUN pip install --no-color  tqdm
RUN pip install --no-color  jax
RUN pip install --no-color  jaxlib
RUN pip install --no-color  radvel
RUN pip install --no-color  tensorflow
RUN pip install --no-color  keras
RUN pip install --no-color  torch
RUN pip install --no-color  everest-pipeline
RUN pip install --no-color  batman-package
RUN pip install --no-color  tvguide
RUN pip install --no-color  astrobase
RUN pip install --no-color  reproject
RUN pip install --no-color  ellc

# ---------------------------------------------------------------
# JupyterLab extensions
RUN jupyter nbextension enable --py --sys-prefix ipyevents
# RUN jupyter labextension install jupyterlab_bokeh  # ?? broken, but part of base image
RUN jupyter lab build

# ---------------------------------------------------------------
# VARTOOLS Light Curve Analysis Program

USER root
RUN curl --silent --show-error https://www.astro.princeton.edu/~jhartman/vartools/vartools-1.38.tar.gz -o vartools-1.38.tar.gz && \
   tar zxf vartools-1.38.tar.gz &&\
   cd vartools-1.38 &&\
   ./configure &&\
   make &&\
   make install &&\
   cd .. &&\
   rm -rf vartools-1.38 vartools-1.38.tar.gz


# ---------------------------------------------------------------
# Test package imports
USER root
COPY test_imports.py /opt
RUN python3 /opt/test_imports.py  && rm /opt/test_imports.py

# ---------------------------------------------------------------
# conda cleanup

RUN conda clean --all -f -y -q

# ---------------------------------------------------------------
# Git repos

USER root
RUN mkdir /opt/tessworkshop_tutorials
RUN chmod 777 /opt/tessworkshop_tutorials

RUN mkdir /opt/notebooks
RUN chmod 777 /opt/notebooks

USER $NB_UID
RUN git clone https://github.com/spacetelescope/tessworkshop_tutorials.git /opt/tessworkshop_tutorials
RUN git clone https://github.com/spacetelescope/notebooks.git /opt/notebooks

# README
COPY platform_readme.txt /opt/README

COPY VERSION /opt
