FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/excalidraw/excalidraw.git && \
    cd excalidraw && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /excalidraw
COPY --from=base /git/excalidraw .
ENV NODE_ENV=production
RUN yarn && \
    yarn --cwd excalidraw-app build:app:docker

FROM pierrezemb/gostatic

COPY --from=build /excalidraw/excalidraw-app/build /srv/http
EXPOSE 8043
