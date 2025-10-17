### Base stage ###
FROM node:22-bookworm-slim AS base
RUN corepack enable && \
    corepack prepare pnpm@10.18.3
WORKDIR /app


### Install stage ###
FROM base AS installer

COPY package.json .
COPY pnpm-lock.yaml .

RUN pnpm i --frozen-lockfile


## Build stage ###
FROM base AS builder

COPY --from=installer /app/node_modules node_modules
COPY . .

RUN pnpm build


### Run stage ###
FROM nginx:1.29-alpine
WORKDIR /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist .

