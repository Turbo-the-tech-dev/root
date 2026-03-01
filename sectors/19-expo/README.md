# Expo EAS Build & OTA Updates

## Overview

This sector contains the React Native / Expo application with automated builds and over-the-air updates via EAS.

## Quick Start

### Prerequisites

- Node.js 20+
- EAS CLI: `npm install -g eas-cli`
- Expo account with EAS subscription

### Setup

```bash
# Install dependencies
npm install

# Login to EAS
eas login

# Configure project (first time only)
eas build:configure
```

## Build Profiles

| Profile | Purpose | Distribution | Channel |
|---------|---------|--------------|---------|
| `development` | Local dev with Expo Dev Client | Internal | development |
| `preview` | Test flights, QA | Internal (TestFlight/APK) | preview |
| `production` | App Store / Play Store | Public stores | production |

## Commands

### OTA Updates

```bash
# Push update to preview channel
eas update --branch preview --message "Bug fix for login flow"

# Push update to production
eas update --branch production --message "v2.1.0 - New features"

# List recent updates
eas update:list
```

### Build App

```bash
# Preview build (APK for Android, simulator for iOS)
eas build --profile preview --platform android
eas build --profile preview --platform ios

# Production build (App Store / Play Store)
eas build --profile production --platform ios
eas build --profile production --platform android
```

### Submit to Stores

```bash
# Submit to App Store
eas submit --platform ios --latest

# Submit to Google Play (internal track)
eas submit --platform android --latest
```

## CI/CD Integration

GitHub Actions workflow (`.github/workflows/eas-build-update.yml`) automates:

1. **Lint & Test** on every PR
2. **OTA Update** on merge to main/develop
3. **Full Build** on manual trigger or production merge

### Manual Trigger

```bash
# From GitHub Actions UI:
# 1. Go to Actions → EAS Build & Update
# 2. Click "Run workflow"
# 3. Select profile (preview/production)
# 4. Select platform (all/ios/android)
# 5. Add update message
```

## Code Signing

OTA updates require code signing for security:

```bash
# Generate signing certificate (first time)
npx expo-update:code-signing

# This creates:
# - code-signing/certificate.pem
# - code-signing/private-key.pem
```

**NEVER commit the private key.** Store it securely and reference in `eas.json`.

## Environment Variables

Configure in EAS dashboard:

| Variable | Purpose |
|----------|---------|
| `EXPO_PUBLIC_API_URL` | Backend API endpoint |
| `EXPO_PUBLIC_FIREBASE_KEY` | Firebase config |
| `SENTRY_DSN` | Error tracking |

## Troubleshooting

### Build fails with "Credentials not found"

```bash
# Reset credentials
eas credentials

# Or let EAS auto-manage
eas build --profile production --platform ios --auto-submit
```

### OTA update not applying

```bash
# Check update is published
eas update:list

# Force reload on device (dev mode)
# Shake device → Reload

# Clear cache
npx expo start -c
```

### Version mismatch

```bash
# Check current version
npx expo config --type introspect --json | jq '.version'

# Bump version in app.json before production build
```

## Monitoring

- **EAS Dashboard**: https://expo.dev/accounts/YOUR_ACCOUNT/projects/YOUR_PROJECT
- **Build History**: `eas build:list`
- **Update History**: `eas update:list`

---

*Last updated: 2026-02-28*
*Marcus Hale approved — Automated builds, zero manual credentials.*
