# =============================================================================
# Flutter Web Build — Dockerfile
# Multi-stage build for Flutter web deployment
# =============================================================================

# Stage 1: Build
FROM ghcr.io/cirruslabs/flutter:3.19.0 AS build

WORKDIR /app

# Copy pubspec and install dependencies
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy source code
COPY . .

# Run analysis (fail on errors)
RUN flutter analyze

# Run tests
RUN flutter test

# Build web release
RUN flutter build web --release \
    --dart-define=FLAVOR=production \
    --dart-define=SENTRY_DSN=${SENTRY_DSN} \
    --tree-shake-icons \
    --wasm

# Stage 2: Nginx serving
FROM nginx:alpine AS production

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built web app
COPY --from=build /app/build/web /usr/share/nginx/html

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# Expose port
EXPOSE 80

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
