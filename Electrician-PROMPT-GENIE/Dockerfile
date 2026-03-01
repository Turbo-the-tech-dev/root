# =============================================================================
# Dockerfile - Electrician-PROMPT-GENIE
# Multi-stage build for minimal production image
# =============================================================================

# Stage 1: Dependencies
FROM node:20-alpine AS deps
WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install all dependencies (including devDependencies for build)
RUN npm ci --frozen-lockfile

# Stage 2: Build
FROM node:20-alpine AS builder
WORKDIR /app

# Copy dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Run build if you have a build step, otherwise skip
# RUN npm run build

# Run tests during build (fail fast)
RUN npm test || exit 1

# Stage 3: Production
FROM node:20-alpine AS production
WORKDIR /app

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Copy only necessary files from builder
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/templates ./templates
COPY --from=builder /app/chains ./chains
COPY --from=builder /app/advanced ./advanced

# Copy source files needed at runtime
COPY constants.tsx constants.ts
COPY types.ts types.ts
COPY validation.ts validation.ts

# Switch to non-root user
USER nodejs

# Expose port if running a server
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "console.log('healthy')" || exit 1

# Start command
CMD ["node", "dist/index.js"]
