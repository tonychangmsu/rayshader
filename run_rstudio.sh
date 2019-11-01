#!/bin/bash
docker run -it --rm \
  -e PASSWORD=csp \
  -v $(pwd):/contents \
  -w /contents \
  -p 8787:8787 \
  -p 3838:3838 \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
  apis/rayshader:latest 
