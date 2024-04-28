ARG BASE_CONTAINER=ghcr.io/ucsd-ets/datascience-notebook:2024.2-stable
FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

USER root

RUN pip install 'allensdk==2.16.2' 'nilearn==0.10.3' 'scipy==1.8.0' 'fsspec==2024.2.0' 'dandi==0.61.2'
