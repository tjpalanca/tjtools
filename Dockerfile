FROM rocker/verse:4.0.5
MAINTAINER TJ Palanca <tj.palanca@firstcircle.com>

RUN apt-get update && \
    apt-get install -y libsodium-dev

RUN mkdir -p /src
WORKDIR /src
COPY . .
RUN install2.r remotes
RUN Rscript -e 'remotes::install_local()'

EXPOSE 3838
CMD [ \
    "Rscript", "-e", \
    "options('shiny.port'=3838,shiny.host='0.0.0.0'); tjtools::run_app()" \
]
