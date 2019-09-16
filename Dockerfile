# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/datascience-notebook
FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

USER root

# basic linux commands
RUN apt-get update && apt-get -qq install -y \
        curl \
        rsync \
        unzip \
        less nano vim \
        openssh-client \
        wget

# Debian packages required by course configuration
RUN apt-get update && apt-get -qq install -y \
	hdf5-tools

USER $NB_UID

RUN pip install --no-cache PyQt5 

RUN pip install datascience
RUN pip install okpy

# Pre-generate font cache so the user does not see fc-list warning when
# importing datascience. https://github.com/matplotlib/matplotlib/issues/5836
RUN python -c 'import matplotlib.pyplot'

# Remove pyqt and qt, since we do not need them with notebooks
RUN conda remove --quiet --yes --force qt pyqt PyQt5 || true
RUN conda clean -tipsy

########################
# Pruned from user-containers/datahub/install-extensions.bash

# nbgrader
RUN conda install nbgrader
RUN jupyter nbextension install --symlink --sys-prefix --py nbgrader
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension enable --sys-prefix --py nbgrader

# disable formgrader, create-assignments for all.  grader and assignment maker will run below with 'enable --user' instead of 'disable --sys-prefix'
RUN jupyter nbextension disable --sys-prefix formgrader/main --section=tree
RUN jupyter serverextension disable --sys-prefix nbgrader.server_extensions.formgrader
RUN jupyter nbextension disable --sys-prefix create_assignment/main

# ipywidgets!
RUN pip install ipywidgets
RUN jupyter nbextension enable --sys-prefix --py widgetsnbextension

# replace nbpuller with nbgitpuller
RUN pip install git+https://github.com/data-8/gitautosync
RUN jupyter serverextension enable --py nbgitpuller --sys-prefix

# nbresuse to show users memory usage
RUN pip install git+https://github.com/data-8/nbresuse.git
RUN jupyter serverextension enable --sys-prefix --py nbresuse
RUN jupyter nbextension install --sys-prefix --py nbresuse
RUN jupyter nbextension enable --sys-prefix --py nbresuse

#########################
# course-specific studd
RUN pip install allensdk 
