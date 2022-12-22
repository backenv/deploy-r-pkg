FROM r-base:latest

ARG REPO_USER=''
ARG REPO_URL=''
COPY deployRpkg.sh /usr/bin/deployRpkg

RUN apt update && \
    apt upgrade -y

RUN apt-get install -y --no-install-recommends \
    curl \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libjpeg-dev \
    libpng-dev \
    libssl-dev \
    libtiff5-dev \
    libxml2-dev

RUN R -q -e "install.packages('devtools')" && \
    chmod +x /usr/bin/deployRpkg && \
    mkdir -p /deploy/pkg && \
    chown -R 1000 /deploy/pkg /usr/local/lib/R/site-library

USER 1000
WORKDIR /deploy/pkg

# CMD ["/usr/bin/deployRpkg", "$@"]
