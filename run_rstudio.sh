#!/bin/bash
docker run -it --rm \
  -e PASSWORD=csp \
  -v $(pwd):/contents \
  -w /contents \
  -p 8787:8787 \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e BROWSER='google-chrome' \
  --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
  --device="/dev/dri"\
  apis/rayshader:latest 
