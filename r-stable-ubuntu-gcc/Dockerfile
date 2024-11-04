# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04
ENV R_VERSION=4.4.2
ENV DEBIAN_FRONTEND=noninteractive

LABEL org.label-schema.license="Apache-2.0" \
    org.label-schema.vcs-url="https://github.com/pachadotdev/rdocker" \
    org.label-schema.vendor="Pacha" \
    maintainer="Pacha <m.sepulveda@mail.utoronto.ca>"

# Install R dependencies
RUN sed -i.bak "/^#.*deb-src.*universe$/s/^# //g" /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y wget locales passwd sudo make automake && \
    apt-get install -y r-base

# Docker non-root user
RUN useradd -s /bin/bash -m docker && \
    usermod -a -G staff docker && \
    echo 'docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    getent group sudo || groupadd sudo && \
    if ! id -u docker >/dev/null 2>&1; then useradd -rm -d /home/docker -s /bin/bash -g root -G sudo -u 1001 docker && echo 'docker:password' | chpasswd; fi && \
    echo 'docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    mkdir -p /usr/local/lib/R/site-library && \
    chown root:staff "/usr/local/lib/R/site-library" && \
    chmod g+ws "/usr/local/lib/R/site-library"

# Set the locale and timezone
RUN echo "en_CA.UTF-8 UTF-8" >> /etc/locale.gen && \
    localedef -i en_CA -f UTF-8 en_CA.UTF-8 && \
    /usr/sbin/update-locale LANG=en_CA.UTF-8

ENV LC_ALL=en_CA.UTF-8
ENV LANG=en_CA.UTF-8
ENV TZ=America/Toronto

# R packages directory
RUN mkdir -p /etc/R && \
    echo 'options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))' >> /etc/R/Rprofile.site  && \
    echo 'options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))' >> /root/.Rprofile

RUN apt-get install -y libssl-dev libcurl4-openssl-dev libgit2-dev \
    libfontconfig1-dev libfreetype-dev libpng-dev libtiff-dev libjpeg-dev \
    libxml2-dev libharfbuzz-dev libfribidi-dev && \
    apt-get -y autoremove && \
    apt-get -y autoclean

#############################################

USER docker

# Create Makevars file with necessary flags
RUN cd ~ && \
    mkdir -p /home/docker/.R && \
    echo 'options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))' >> /home/docker/.Rprofile && \
    Rscript -e 'install.packages("remotes")' && \
    Rscript -e 'remotes::install_github("RcppCore/Rcpp")' && \
    Rscript -e 'remotes::install_github("pachadotdev/pkgload")' && \
    Rscript -e 'install.packages("devtools")' && \
    Rscript -e 'if(!require("devtools")) stop("devtools not found")'
