FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN R -e "install.packages(c('tidyverse', 'mosaic', 'mosaicCore', 'MosaicData', 'openintro', 'palmerpenguins', 'olilabs', 'RColorBrewer', 'knitr', 'markdown', 'rmarkdown', 'car', 'carData', 'cherryblossom', 'datasets', 'DBI', 'dbplyr', 'network', 'DT', 'emo', 'fivethirtyeight', 'gargle', 'Lock5Data', 'MASS'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

USER $NB_USER

