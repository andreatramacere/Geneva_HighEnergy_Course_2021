#PIP
FROM python:3.8-slim
# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook

USER root



ADD requirements_docker.txt /requirements_docker.txt

#PIPI
RUN pip install -r requirements_docker.txt
RUN apt-get update -y
RUN apt-get install -y swig
RUN apt-get install -y git
RUN apt-get install -y gcc
RUN apt-get install -y wget
RUN wget https://github.com/andreatramacere/jetset/releases/download/1.2.0rc6/pip-src-1.2.0rc6-ubuntu-latest.tar
RUN tar xfv pip-src-1.2.0rc6-ubuntu-latest.tar
WORKDIR pip-src-1.2.0rc6-ubuntu-latest
RUN tar zxfv jetset-1.2.0rc6.tar.gz
WORKDIR jetset-1.2.0rc6
RUN python setup.py install
WORKDIR /
# create user with a home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

ADD *.ipynb $HOME/notebooks/
ADD images $HOME/notebooks/images
ADD images $HOME/notebooks/jetset_slides

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}
WORKDIR ${HOME}/notebooks
CMD cd ${HOME}/notebooks
CMD ls
