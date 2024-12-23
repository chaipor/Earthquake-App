# Stage 1: Build the Vite frontend
FROM oven/bun AS frontend-builder

WORKDIR /app/frontend

COPY frontend/package.json ./
RUN bun install

COPY frontend/ .
RUN bun run build

# Stage 2: Set up the Express backend and bundle the Vite build
FROM oven/bun AS backend

WORKDIR /app

COPY backend/package.json backend/package-lock.json ./
RUN bun install --production

COPY backend/ .
COPY --from=frontend-builder /app/frontend/dist ./public


EXPOSE 3000
CMD ["bun", "server.js"]