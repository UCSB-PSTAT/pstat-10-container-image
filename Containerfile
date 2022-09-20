FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y texlive-full lmodern libbz2-dev nano && \
    apt-get clean

RUN R -e "install.packages(c('tidyverse', 'mosaic', 'mosaicCore', 'MosaicData', 'openintro', 'palmerpenguins', 'RColorBrewer', 'knitr', 'markdown', 'rmarkdown', 'car', 'carData', 'cherryblossom', 'datasets', 'DBI', 'dbplyr', 'network', 'DT', 'fivethirtyeight', 'gargle', 'Lock5Data', 'MASS', 'stats', 'graphics', 'datasets'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

RUN R -e 'devtools::install_github("hadley/emo")'

USER $NB_USER

