# Sector 18: Turbo Dev - The Nibalizer Isolation
# "Vaporize the Artisanal. Standardize the Sovereign."

FROM node:20-alpine AS base

# Install system dependencies (Imperial Arsenal)
RUN apk add --no-cache 
    bash 
    curl 
    rclone 
    git 
    openssh-client

# Install PNPM (The Shared Store)
RUN npm install -g pnpm turbo

# Set the Imperial workspace
WORKDIR /app

# Copy the purge script
COPY root/Sector-18-Turbo-Dev/imperial-purge.sh /usr/local/bin/nibalize
RUN chmod +x /usr/local/bin/nibalize

# Environment defaults (Imperative Overrides)
ENV S3_BUCKET=imperial-arsenal
ENV FIRESTORE_WEBHOOK=https://firestore.googleapis.com/v1/projects/imperial-fleet/databases/(default)/documents/events

# The Nibalizer remains dormant until summoned
ENTRYPOINT ["/usr/local/bin/nibalize"]
