#!/bin/bash
# =============================================================================
# 8-Hour Sprint YOLO Timer
# "8 Hours. Zero Excuses. Maximum Output."
# =============================================================================
#
# USAGE: ./sprint-yolo.sh --target "Ship v1.0 to production"
#
# This script:
# 1. Sets up sprint environment
# 2. Tracks each hour
# 3. Enforces break schedule
# 4. Logs deliverables
# 5. Generates retro report
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Configuration
SPRINT_TARGET="${SPRINT_TARGET:-}"
SPRINT_LOG="sprint-$(date +%Y%m%d-%H%M%S).log"
BREAK_DURATION_SHORT=600  # 10 minutes
BREAK_DURATION_LONG=1800  # 30 minutes

# =============================================================================
# Helper Functions
# =============================================================================

log_info() {
    echo -e "${CYAN}[INFO]${NC} $1" | tee -a "$SPRINT_LOG"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$SPRINT_LOG"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$SPRINT_LOG"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$SPRINT_LOG"
}

log_hour() {
    echo -e "${MAGENTA}[HOUR $1]${NC} $2" | tee -a "$SPRINT_LOG"
}

log_break() {
    echo -e "${YELLOW}[BREAK]${NC} $1 minutes - $2" | tee -a "$SPRINT_LOG"
}

# =============================================================================
# Sprint Setup
# =============================================================================

setup_sprint() {
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          8-HOUR SPRINT YOLO — LET'S GO!                   ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Get target if not set
    if [[ -z "$SPRINT_TARGET" ]]; then
        echo -e "${YELLOW}What will you ship in 8 hours?${NC}"
        read -r SPRINT_TARGET
    fi
    
    log_info "Sprint Target: $SPRINT_TARGET"
    log_info "Sprint Log: $SPRINT_LOG"
    echo ""
    
    # Pre-flight checks
    log_info "Pre-flight checks..."
    
    # Check for required tools
    if ! command -v date &> /dev/null; then
        log_error "date command not found"
        exit 1
    fi
    
    log_success "Pre-flight checks passed"
    echo ""
    
    # Display rules
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════╗
║                    THE 10 COMMANDMENTS                    ║
╠═══════════════════════════════════════════════════════════╣
║  1. Thou shalt not check email                            ║
║  2. Thou shalt not respond to Slack                       ║
║  3. Thou shalt not attend meetings                        ║
║  4. Thou shalt have ONE clear target                      ║
║  5. Thou shalt ship at 80%                                ║
║  6. Thou shalt not refactor prematurely                   ║
║  7. Thou shalt take breaks (90 min cycles)                ║
║  8. Thou shalt document as thou goest                     ║
║  9. Thou shalt test before deploy                         ║
║  10. Thou shalt celebrate the win                         ║
╚═══════════════════════════════════════════════════════════╝

EOF
    
    echo -e "${YELLOW}Ready to begin? (y/n)${NC}"
    read -r confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        log_info "Sprint cancelled"
        exit 0
    fi
    
    log_success "Sprint starting NOW!"
    echo ""
}

# =============================================================================
# Hour Functions
# =============================================================================

run_hour_0() {
    log_hour "0" "PREP - Before the Clock Starts"
    
    cat << 'EOF'
    
    Prep Checklist:
    □ Calendar blocked (8 hours + buffer)
    □ Slack/Teams status: DO NOT DISTURB
    □ Email auto-reply on
    □ Phone in another room
    □ Coffee/tea prepared
    □ Water bottle filled
    □ Snacks ready
    □ All tabs/apps open
    □ Music playlist ready
    □ Timer visible
    
EOF
    
    echo -e "${YELLOW}Prep complete? (y/n)${NC}"
    read -r confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        log_warn "Prep incomplete - consider finishing first"
    fi
    
    log_success "Hour 0 complete"
}

run_hour_1() {
    log_hour "1" "FOUNDATION - Define Target & Build Skeleton"
    
    cat << 'EOF'
    
    Minutes 0-15: Define the Target
    - Write down: "In 8 hours, I will have shipped: ______"
    
    Minutes 15-45: Gather Intelligence
    - Review existing code/docs
    - Identify dependencies
    - List all known blockers
    
    Minutes 45-60: Build the Skeleton
    - Create file structure
    - Set up build system
    - Get "hello world" working
    
EOF
    
    start_timer 3600  # 1 hour
    
    log_success "Hour 1 complete - Deliverable: Working skeleton"
}

run_hour_2_3() {
    log_hour "2-3" "CORE BUILD - One Feature, Complete It"
    
    cat << 'EOF'
    
    The Rule: One feature. Complete it. No switching.
    
    □ Start with the ONE thing that matters
    □ Build it end-to-end
    □ Test it works
    □ Commit when done
    □ Move to next (if time)
    
    Anti-Distraction Rules:
    - No email
    - No Slack
    - No "quick research"
    - No refactoring (yet)
    - No perfecting (ship first)
    
EOF
    
    start_timer 7200  # 2 hours
    
    log_success "Hours 2-3 complete - Deliverable: First core feature"
}

run_break_short() {
    log_break "10" "Short Break - Walk, stretch, hydrate"
    
    cat << 'EOF'
    
    Break Rules:
    - No social media
    - No email "quick check"
    - Move your body
    - Hydrate
    - Don't think about the sprint
    
EOF
    
    countdown_timer "$BREAK_DURATION_SHORT"
    
    log_success "Break complete - Back to work!"
}

run_hour_4_5() {
    log_hour "4-5" "EXPAND & INTEGRATE - Add More Functionality"
    
    cat << 'EOF'
    
    Now you can add more:
    □ Feature 2 (if time allows)
    □ Integration points
    □ Basic error handling
    □ Logging/monitoring
    
    The 80% Rule:
    - Don't polish to 100%
    - Ship at 80%
    - Iterate later
    
EOF
    
    start_timer 7200  # 2 hours
    
    log_success "Hours 4-5 complete - Deliverable: Core functionality"
}

run_hour_6() {
    log_hour "6" "TEST & POLISH - QA Mode"
    
    cat << 'EOF'
    
    Switch to QA mode:
    □ Run through user journey
    □ Fix critical bugs
    □ Add missing error messages
    □ Update README
    □ Add basic tests (if not done)
    
    Bug Triage:
    | Severity  | Action                    |
    |-----------|---------------------------|
    | Critical  | Fix now                   |
    | Major     | Fix if <30 min            |
    | Minor     | Document, ship anyway     |
    | Cosmetic  | Backlog                   |
    
EOF
    
    start_timer 3600  # 1 hour
    
    log_success "Hour 6 complete - Deliverable: Tested, documented, shippable"
}

run_break_long() {
    log_break "30" "Long Break - Meal, no screens"
    
    cat << 'EOF'
    
    Long Break Rules:
    - Eat something nutritious
    - NO SCREENS
    - Walk if possible
    - Breathe
    - You're halfway there!
    
EOF
    
    countdown_timer "$BREAK_DURATION_LONG"
    
    log_success "Long break complete - Final push!"
}

run_hour_7() {
    log_hour "7" "DEPLOY - Ship It!"
    
    cat << 'EOF'
    
    Ship it:
    □ Final build
    □ Deploy to production/staging
    □ Verify deployment
    □ Smoke test live
    □ Monitor for errors
    
    Deployment Checklist:
    - [ ] Build passes
    - [ ] Tests pass
    - [ ] Deployed
    - [ ] Live URL works
    - [ ] No errors in logs
    - [ ] Team notified
    
EOF
    
    start_timer 3600  # 1 hour
    
    log_success "Hour 7 complete - Deliverable: LIVE IN PRODUCTION"
}

run_hour_8() {
    log_hour "8" "REVIEW & RETRO - Celebrate & Learn"
    
    cat << 'EOF'
    
    Celebrate first:
    □ Acknowledge what you shipped
    □ Take a screenshot
    □ Share with team/stakeholders
    □ Feel the win
    
    Then learn:
    □ What went well? (list 3)
    □ What blocked you? (list 3)
    □ What would you do differently? (list 3)
    □ What's next?
    
EOF
    
    echo -e "${YELLOW}Take 30 minutes for retro. Press enter when done.${NC}"
    read -r
    
    # Generate retro report
    generate_retro
    
    log_success "Hour 8 complete - Sprint COMPLETE!"
}

# =============================================================================
# Timer Functions
# =============================================================================

start_timer() {
    local duration=$1
    local start_time=$(date +%s)
    local end_time=$((start_time + duration))
    
    while [[ $(date +%s) -lt $end_time ]]; do
        local remaining=$((end_time - $(date +%s)))
        local hours=$((remaining / 3600))
        local minutes=$(((remaining % 3600) / 60))
        local seconds=$((remaining % 60))
        
        printf "\rTime remaining: %02d:%02d:%02d" $hours $minutes $seconds
        
        sleep 1
    done
    
    echo ""
}

countdown_timer() {
    local duration=$1
    
    log_info "Break starting now..."
    start_timer "$duration"
    log_info "Break over!"
}

# =============================================================================
# Retro Generation
# =============================================================================

generate_retro() {
    local retro_file="retro-$(date +%Y%m%d-%H%M%S).md"
    
    cat > "$retro_file" << EOF
# Sprint Retrospective

**Date:** $(date +%Y-%m-%d)
**Target:** $SPRINT_TARGET
**Duration:** 8 hours

## What Shipped

<!-- Describe what you shipped -->

## Wins (3+)

1.
2.
3.

## Blockers (3+)

1.
2.
3.

## What I'd Do Differently (3+)

1.
2.
3.

## Next Sprint Target


## Sprint Scorecard

| Criteria | Score (1-10) |
|----------|--------------|
| Focus (no distractions) | |
| Velocity | |
| Quality | |
| Completion | |
| Energy | |
| Ship | |
| **TOTAL** | /60 |

---
*Generated by Sprint YOLO Timer*
EOF
    
    log_info "Retro saved to: $retro_file"
}

# =============================================================================
# Main Execution
# =============================================================================

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --target)
                SPRINT_TARGET="$2"
                shift 2
                ;;
            --help)
                echo "Usage: $0 --target \"Your sprint target\""
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Run sprint
    setup_sprint
    run_hour_0
    run_hour_1
    run_hour_2_3
    run_break_short
    run_hour_4_5
    run_break_long
    run_hour_6
    run_hour_7
    run_hour_8
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              SPRINT COMPLETE — YOU DID IT!                ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    log_success "Sprint log saved to: $SPRINT_LOG"
}

# Run main
main "$@"
