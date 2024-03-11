FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/excalidraw/excalidraw.git && \
    cd excalidraw && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:20-alpine AS build

WORKDIR /excalidraw
COPY --from=base /git/excalidraw .
RUN yarn --network-timeout 1000000 && \
    export NODE_ENV=production && \
    yarn --cwd excalidraw-app build:app:docker

FROM lipanski/docker-static-website

COPY --from=build /excalidraw/build .
