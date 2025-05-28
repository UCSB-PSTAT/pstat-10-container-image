FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt update && \
    apt install -y texlive-full lmodern libbz2-dev nano && \
    apt clean

RUN conda install -y -c conda-forge \
    markdown \
    r-car \
    r-cardata \
    r-cherryblossom \
    r-dbi \
    r-dbplyr \
    r-dt \
    r-fivethirtyeight \
    r-gargle \
    r-kableextra \ 
    r-knitr \
    r-learnr \
    r-mass \
    r-mosaic \
    r-mosaiccore \
    r-mosaicdata \
    r-network \
    r-openintro \
    r-palmerpenguins \
    r-rcolorbrewer \
    r::r-lock5data \
    r-rmarkdown \
    r-rsqlite \
    r-tidyverse
    
RUN R -e "install.packages(c( 'tutorial.helpers', 'RSQLite'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

RUN R -e 'devtools::install_github("hadley/emo")'

USER $NB_USER

