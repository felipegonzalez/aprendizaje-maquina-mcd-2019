FROM rocker/verse:3.6.0

RUN cat /etc/os-release 

RUN apt-get update \ 
    && apt-get install -y libudunits2-dev 

RUN \
  apt-get install -y build-essential libssl-dev libffi-dev python3 python3-dev && \
  apt-get install -y python3-pip 
  
RUN \
  pip3 install --upgrade tensorflow && \
  pip3 install --upgrade keras numpy scipy h5py pyyaml requests Pillow pandas matplotlib

RUN r -e 'devtools::install_github("bmschmidt/wordVectors")'

RUN install2.r --error \
    reticulate \
    tensorflow \
    keras \
    glmnet \
    ROCR \
    tabplot \
    gganimate \
    kknn \
    splines2 \
    imager \
    gridExtra \
    ranger \
    irlba \
    ggrepel \
    tsne \
    feather

RUN apt-get install -y ffmpeg