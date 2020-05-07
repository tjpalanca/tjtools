FROM rocker/verse:3.6.1
MAINTAINER TJ Palanca <tj.palanca@firstcircle.com>

RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site

RUN apt-get update && apt-get install -y libsodium-dev

RUN install2.r renv
COPY renv.lock renv.lock
RUN Rscript -e "renv::restore();"

RUN mkdir /src
COPY . /src
WORKDIR /src
RUN install2.r remotes
RUN Rscript -e 'remotes::install_local(upgrade="never")'

EXPOSE 3838
CMD [ \
    "Rscript", "-e", \
    "options('shiny.port'=3838,shiny.host='0.0.0.0'); tjtools::run_app()" \
]
