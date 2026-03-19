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
    r-dbi \
    r-dbplyr \
    r-dt \
    r-fivethirtyeight \
    r-gargle \
    r-ggally \
    r-kableextra \
    r-knitr \
    r-leaflet \
    r-learnr \
    r-mass \
    r-mosaic \
    r-mosaiccore \
    r-mosaicdata \
    r-network \
    r-rcolorbrewer \
    r-rmarkdown \
    r-skimr \
    r-tidyverse
    
RUN R -e "install.packages(c( 'cherryblossom',' Lock5Data', 'openintro', 'palmerpenguins', 'tutorial.helpers', 'RSQLite'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

RUN R -e 'devtools::install_github("hadley/emo")'

USER $NB_USER

