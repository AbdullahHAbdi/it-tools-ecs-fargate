# Stage 1: Build stage
FROM node:22-alpine AS builder

WORKDIR /app

RUN npm install -g pnpm

COPY app/package.json app/pnpm-lock.yaml ./

RUN pnpm install

COPY app/ .

RUN pnpm run build

# Stage 2: Serve stage
FROM nginx:stable-alpine

COPY --from=builder /app/dist /usr/share/nginx/html

RUN addgroup -S appgroup && adduser -S nonrootuser -G appgroup

RUN mkdir -p /var/cache/nginx /var/run /var/log/nginx && \
    chown -R nonrootuser:appgroup /var/cache/nginx /var/run /var/log/nginx && \
    chown -R nonrootuser:appgroup /usr/share/nginx/html
    
RUN touch /var/run/nginx.pid && \
    chown nonrootuser:appgroup /var/run/nginx.pid

USER nonrootuser

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
