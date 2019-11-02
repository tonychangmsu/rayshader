FROM rocker/geospatial:latest
RUN apt-get update 
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -qqy xorg libx11-dev libglu1-mesa-dev x11-apps mesa-utils mesa-utils-extra
RUN R -e "install.packages('rayshader', dependencies=TRUE)"
RUN R -e "install.packages('rgl', dependencies=TRUE)"

