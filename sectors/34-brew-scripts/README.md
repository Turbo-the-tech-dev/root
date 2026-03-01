# Sector 34 — Imperial Homebrew Scripts

> "One Command to Install Them All." — The Imperial Tap

---

## 🍺 Overview

**Homebrew formulas for all Imperial CLI tools.**

Purpose:
- One-command installation
- Automatic dependency management
- Version tracking and updates
- Cross-platform support (macOS, Linux)

---

## 📦 Available Formulas

### Core CLI Tools

| Formula | Description | Dependencies |
|---------|-------------|--------------|
| **leo** | Law Enforcement CLI | node, npm |
| **med** | Hospital API CLI | node, npm |
| **med-mars** | Earth-Mars medical sync | node, npm |
| **solarnet** | Solar system medical network | node, npm |
| **icewall** | Ice Wall construction CLI | python3 |
| **pyramid** | Egyptian pyramid analysis | python3 |
| **wall** | Great Wall engineering CLI | python3 |
| **bug-bounty** | Security scanner | python3, jq |
| **alert** | Security alert system | bash, curl |
| **yolo** | AWS deployment script | awscli, bash |

### Infrastructure Tools

| Formula | Description | Dependencies |
|---------|-------------|--------------|
| **imperial-arsenal** | Terraform deployment | terraform, awscli |
| **imperial-purge** | Infrastructure destruction | terraform, bash |
| **sector-search** | Imperial navigation | bash, awk |
| **init-env** | Environment setup | bash, git |

---

## 🚀 Installation

### Step 1: Add Imperial Tap

```bash
# Add the Imperial Homebrew tap
brew tap Turbo-the-tech-dev/imperial

# Verify tap is added
brew tap | grep imperial
```

### Step 2: Install CLI Tools

```bash
# Install individual tools
brew install leo
brew install med
brew install bug-bounty
brew install yolo

# Install all tools at once
brew install imperial-all

# Install by category
brew install imperial-security  # bug-bounty, alert
brew install imperial-medical   # med, med-mars, solarnet
brew install imperial-law       # leo
brew install imperial-climate   # icewall, pyramid, wall
```

### Step 3: Verify Installation

```bash
# Check versions
leo --version
med --version
bug-bounty --version

# Run help
leo --help
med --help
```

---

## 📝 Formula Templates

### leo.rb (Law Enforcement CLI)

```ruby
class Leo < Formula
  desc "Law Enforcement Officer Software — Imperial CLI Tools"
  homepage "https://github.com/Turbo-the-tech-dev/root/tree/master/sectors/25-leo-cli"
  url "https://github.com/Turbo-the-tech-dev/root/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "CHANGE_ME_TO_ACTUAL_SHA256"
  license "MIT"

  depends_on "node" => :recommended
  depends_on "npm" => :recommended

  def install
    cd "sectors/25-leo-cli" do
      system "npm", "install"
      bin.install "src/leo.js" => "leo"
    end
  end

  test do
    output = shell_output("#{bin}/leo --version")
    assert_match "1.0.0", output
  end
end
```

### med.rb (Hospital API CLI)

```ruby
class Med < Formula
  desc "Hospital Management API & CLI — MedTech Imperial"
  homepage "https://github.com/Turbo-the-tech-dev/root/tree/master/sectors/26-hospital-api"
  url "https://github.com/Turbo-the-tech-dev/root/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "CHANGE_ME_TO_ACTUAL_SHA256"
  license "MIT"

  depends_on "node" => :recommended
  depends_on "npm" => :recommended

  def install
    cd "sectors/26-hospital-api" do
      system "npm", "install"
      bin.install "src/med.js" => "med"
    end
  end

  test do
    output = shell_output("#{bin}/med --version")
    assert_match "1.0.0", output
  end
end
```

### bug-bounty.rb (Security Scanner)

```ruby
class BugBounty < Formula
  desc "Imperial Security Scanner — Vulnerability Detection"
  homepage "https://github.com/Turbo-the-tech-dev/root/tree/master/sectors/09-security"
  url "https://github.com/Turbo-the-tech-dev/root/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "CHANGE_ME_TO_ACTUAL_SHA256"
  license "MIT"

  depends_on "python@3.9" => :recommended
  depends_on "jq" => :recommended
  depends_on "requests" => :python

  def install
    cd "sectors/09-security" do
      bin.install "bug-bounty.py" => "bug-bounty"
      chmod 0755, bin/"bug-bounty"
    end
  end

  test do
    output = shell_output("#{bin}/bug-bounty --version")
    assert_match "2.0", output
  end
end
```

### yolo.rb (AWS Deployment)

```ruby
class Yolo < Formula
  desc "AWS YOLO Deployment — Imperial Production Protocol"
  homepage "https://github.com/Turbo-the-tech-dev/root/tree/master/sectors/08-aws"
  url "https://github.com/Turbo-the-tech-dev/root/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "CHANGE_ME_TO_ACTUAL_SHA256"
  license "MIT"

  depends_on "awscli" => :recommended
  depends_on "bash" => :recommended

  def install
    cd "sectors/08-aws" do
      bin.install "aws-yolo.sh" => "yolo"
      chmod 0755, bin/"yolo"
    end
  end

  test do
    output = shell_output("#{bin}/yolo --help")
    assert_match "AWS YOLO", output
  end
end
```

### imperial-all.rb (Meta-Package)

```ruby
class ImperialAll < Formula
  desc "Imperial CLI Tools — Complete Installation"
  homepage "https://github.com/Turbo-the-tech-dev/root"
  url "https://github.com/Turbo-the-tech-dev/root/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "CHANGE_ME_TO_ACTUAL_SHA256"
  license "MIT"

  depends_on "leo"
  depends_on "med"
  depends_on "bug-bounty"
  depends_on "yolo"
  depends_on "sector-search"
  depends_on "init-env"

  def install
    # Meta-package, no installation needed
    prefix.install "README.md"
  end

  test do
    assert File.exist?(prefix/"README.md")
  end
end
```

---

## 🔧 Creating New Formulas

### Step 1: Generate Formula Template

```bash
# Generate formula template
brew create --no-fetch https://github.com/Turbo-the-tech-dev/root/archive/refs/tags/v1.0.0.tar.gz
```

### Step 2: Edit Formula

```bash
# Open formula for editing
brew edit leo

# Add dependencies, install steps, test
```

### Step 3: Test Formula Locally

```bash
# Install from local formula
brew install --build-from-source ./leo.rb

# Run tests
brew test leo
```

### Step 4: Submit to Tap

```bash
# Commit formula to tap repository
git add Formula/leo.rb
git commit -m "leo 1.0.0: New formula"
git push origin main
```

---

## 📊 Formula Structure

### Required Fields

```ruby
class FormulaName < Formula
  desc "Description (required)"
  homepage "URL (required)"
  url "Download URL (required)"
  sha256 "SHA256 hash (required)"
  license "License identifier (required)"
  
  # Optional
  version "1.0.0"
  
  # Dependencies
  depends_on "dependency"
  
  # Installation
  def install
    # Build steps
  end
  
  # Testing
  test do
    # Test commands
  end
end
```

### Dependency Types

| Type | Syntax | Example |
|------|--------|---------|
| **Homebrew** | `depends_on "formula"` | `depends_on "node"` |
| **Python** | `depends_on "package" => :python` | `depends_on "requests" => :python` |
| **Optional** | `depends_on "formula" => :optional` | `depends_on "awscli" => :optional` |
| **Recommended** | `depends_on "formula" => :recommended` | `depends_on "jq" => :recommended` |

---

## 🍎 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| **macOS** | ✅ Full Support | Intel + Apple Silicon |
| **Linux (Homebrew)** | ✅ Full Support | Ubuntu, Debian, Fedora |
| **Termux** | ⚠️ Partial | Use pkg/apt instead |

---

## 📋 Maintenance

### Updating Formulas

```bash
# Check for outdated formulas
brew outdated

# Update all formulas
brew update

# Upgrade installed formulas
brew upgrade

# Upgrade specific formula
brew upgrade leo
```

### Version Bumping

```bash
# Edit formula with new version
brew edit leo

# Update URL and sha256
url "https://.../v1.1.0.tar.gz"
sha256 "NEW_SHA256_HASH"

# Commit and push
git commit -m "leo 1.1.0: Version bump"
git push
```

### Removing Formulas

```bash
# Uninstall formula
brew uninstall leo

# Remove from tap
git rm Formula/leo.rb
git commit -m "leo: Remove formula"
git push
```

---

## 🔍 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| **Formula not found** | Run `brew tap Turbo-the-tech-dev/imperial` |
| **SHA256 mismatch** | Update sha256 in formula |
| **Dependency missing** | Add `depends_on` declaration |
| **Install fails** | Run `brew install --verbose --debug formula` |
| **Test fails** | Check `test do` block |

### Debug Commands

```bash
# Verbose installation
brew install --verbose formula

# Debug mode
brew install --debug formula

# Show formula source
brew cat formula

# Audit formula
brew audit --strict formula

# Test formula
brew test formula
```

---

## 📦 Complete Formula List

### Security Category

```bash
brew install bug-bounty    # Security scanner
brew install alert         # Alert system
```

### Medical Category

```bash
brew install med           # Hospital CLI
brew install med-mars      # Earth-Mars sync
brew install solarnet      # Solar medical network
```

### Law Enforcement Category

```bash
brew install leo           # LEO CLI tools
```

### Climate Engineering Category

```bash
brew install icewall       # Ice Wall CLI
brew install pyramid       # Pyramid analysis
brew install wall          # Great Wall CLI
```

### Infrastructure Category

```bash
brew install yolo          # AWS deployment
brew install imperial-arsenal  # Terraform deploy
brew install sector-search     # Navigation
brew install init-env          # Environment setup
```

---

## 🔗 Related Sectors

| Sector | Purpose |
|--------|---------|
| **09-Security** | bug-bounty, alert formulas |
| **25-LEO-CLI** | leo formula |
| **26-Hospital-API** | med formula |
| **08-AWS** | yolo, imperial-arsenal formulas |
| **31-Ice-Wall** | icewall formula |

---

*Last Updated: 2026-02-28*
*The Imperial Tap approved — "One Command to Install Them All."*
