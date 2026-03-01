#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Gemini Regeneration Script
# =============================================================================
# Purpose: Regenerate documentation, tests, or code using Google's Gemini AI
# Usage:
#   ./gemini-regenerate.sh --type docs --scope Electrical-Core-API
#   ./gemini-regenerate.sh --type tests --scope DEATHSTAR
#   ./gemini-regenerate.sh --type commit-msg
#   ./gemini-regenerate.sh --type pr-description
# =============================================================================

# Configuration
readonly SCRIPT_NAME="gemini-regenerate"
readonly SCRIPT_VERSION="1.0.0"
readonly GEMINI_API_KEY="${GEMINI_API_KEY:-}"
readonly GEMINI_MODEL="${GEMINI_MODEL:-gemini-1.5-flash}"
readonly GEMINI_API_URL="https://generativelanguage.googleapis.com/v1beta/models"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# =============================================================================
# Helper Functions
# =============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

show_help() {
    cat << EOF
${SCRIPT_NAME} v${SCRIPT_VERSION}
Regenerate documentation, tests, or code using Google's Gemini AI

USAGE:
    ${SCRIPT_NAME} --type <TYPE> --scope <SCOPE> [OPTIONS]

TYPES:
    docs            Regenerate documentation (README, docstrings, etc.)
    tests           Generate test files for existing code
    commit-msg      Generate commit message from staged changes
    pr-description  Generate PR description from diff
    code-review     Review code and suggest improvements
    refactor        Suggest refactoring improvements

SCOPE:
    Directory or file path to process
    Use "all" for workspace-wide regeneration

OPTIONS:
    -t, --type      Type of regeneration (required)
    -s, --scope     Scope/directory to process (required for most types)
    -o, --output    Output directory (default: overwrite in place)
    -d, --dry-run   Show what would be generated without writing
    -v, --verbose   Enable verbose output
    -h, --help      Show this help message

EXAMPLES:
    # Regenerate docs for Electrical-Core-API
    ${SCRIPT_NAME} --type docs --scope Electrical-Core-API

    # Generate tests for DEATHSTAR scripts
    ${SCRIPT_NAME} --type tests --scope DEATHSTAR

    # Generate commit message from staged changes
    ${SCRIPT_NAME} --type commit-msg

    # Dry-run: preview doc regeneration
    ${SCRIPT_NAME} --type docs --scope scripts/ --dry-run

ENVIRONMENT VARIABLES:
    GEMINI_API_KEY  Google AI API key (required)
    GEMINI_MODEL    Model to use (default: gemini-1.5-flash)

EOF
}

check_requirements() {
    # Check for required commands
    if ! command -v curl &> /dev/null; then
        log_error "curl is required but not installed"
        exit 1
    fi

    if ! command -v jq &> /dev/null; then
        log_error "jq is required but not installed"
        exit 1
    fi

    # Check for API key
    if [[ -z "${GEMINI_API_KEY}" ]]; then
        log_error "GEMINI_API_KEY environment variable is not set"
        log_info "Get your API key from: https://makersuite.google.com/app/apikey"
        log_info "Or set it with: export GEMINI_API_KEY='your-key-here'"
        exit 1
    fi
}

# =============================================================================
# Gemini API Functions
# =============================================================================

call_gemini_api() {
    local prompt="$1"
    local response
    local content

    log_info "Calling Gemini API (model: ${GEMINI_MODEL})..."

    response=$(curl -s -X POST "${GEMINI_API_URL}/${GEMINI_MODEL}:generateContent" \
        -H "Content-Type: application/json" \
        -H "x-goog-api-key: ${GEMINI_API_KEY}" \
        -d "$(jq -n --arg prompt "$prompt" '{
            contents: [{parts: [{text: $prompt}]}],
            generationConfig: {temperature: 0.7, maxOutputTokens: 4096}
        }')")

    # Extract content from response
    content=$(echo "${response}" | jq -r '.candidates[0].content.parts[0].text // empty')

    if [[ -z "${content}" ]]; then
        log_error "Failed to get response from Gemini API"
        log_error "Response: ${response}"
        return 1
    fi

    echo "${content}"
}

# =============================================================================
# Regeneration Functions
# =============================================================================

regenerate_docs() {
    local scope="$1"
    local output="${2:-${scope}}"
    local dry_run="$3"

    log_info "Regenerating documentation for: ${scope}"

    # Collect files to analyze
    local files_to_analyze=()
    while IFS= read -r -d '' file; do
        files_to_analyze+=("${file}")
    done < <(find "${scope}" -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.cs" -o -name "*.sh" \) -print0 2>/dev/null)

    if [[ ${#files_to_analyze[@]} -eq 0 ]]; then
        log_warning "No source files found in ${scope}"
        return 0
    fi

    log_info "Found ${#files_to_analyze[@]} source files to analyze"

    # Build prompt for documentation generation
    local prompt="Generate comprehensive documentation for the following codebase. "
    prompt+="Include: 1) Overview README, 2) API documentation, 3) Usage examples. "
    prompt+="Format as Markdown. Files to analyze:"

    for file in "${files_to_analyze[@]}"; do
        if [[ -f "${file}" ]]; then
            prompt+="\n\n--- File: ${file} ---\n"
            prompt+="$(head -100 "${file}" 2>/dev/null | tr '\n' '\\n')"
        fi
    done

    if [[ "${dry_run}" == "true" ]]; then
        log_info "[DRY-RUN] Would generate documentation with prompt length: ${#prompt}"
        return 0
    fi

    # Call Gemini API
    local docs
    docs=$(call_gemini_api "${prompt}")

    # Write output
    local output_file="${output}/GENERATED_DOCS.md"
    echo "${docs}" > "${output_file}"
    log_success "Documentation written to: ${output_file}"
}

generate_tests() {
    local scope="$1"
    local output="${2:-${scope}}"
    local dry_run="$3"

    log_info "Generating tests for: ${scope}"

    # Find source files without corresponding tests
    local files_to_test=()
    while IFS= read -r -d '' file; do
        local test_file
        test_file="${file%.*}.test.${file##*.}"
        if [[ ! -f "${test_file}" ]]; then
            files_to_test+=("${file}")
        fi
    done < <(find "${scope}" -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" \) -print0 2>/dev/null)

    if [[ ${#files_to_test[@]} -eq 0 ]]; then
        log_info "All files already have tests or no testable files found"
        return 0
    fi

    log_info "Found ${#files_to_test[@]} files needing tests"

    for file in "${files_to_test[@]}"; do
        log_info "Generating tests for: ${file}"

        local prompt="Generate comprehensive unit tests for the following code. "
        prompt+="Use appropriate testing framework for the language. "
        prompt+="Include edge cases, error handling, and integration tests where applicable.\n\n"
        prompt+="--- Code: ${file} ---\n"
        prompt+="$(cat "${file}" 2>/dev/null | tr '\n' '\\n')"

        if [[ "${dry_run}" == "true" ]]; then
            log_info "[DRY-RUN] Would generate tests for ${file}"
            continue
        fi

        local tests
        tests=$(call_gemini_api "${prompt}")

        local test_output="${file%.*}.test.${file##*.}"
        echo "${tests}" > "${test_output}"
        log_success "Tests written to: ${test_output}"
    done
}

generate_commit_msg() {
    local dry_run="${1:-false}"

    log_info "Generating commit message from staged changes..."

    # Get staged changes
    local diff
    diff=$(git diff --cached 2>/dev/null || echo "")

    if [[ -z "${diff}" ]]; then
        log_error "No staged changes found"
        return 1
    fi

    local prompt="Generate a conventional commit message for these changes. "
    prompt+="Format: type(scope): brief message\\n\\nLonger description. "
    prompt+="Use types: feat, fix, docs, refactor, chore, test.\\n\\n"
    prompt+="--- Git Diff ---\\n${diff}\\n--- End Diff ---"

    if [[ "${dry_run}" == "true" ]]; then
        log_info "[DRY-RUN] Would generate commit message"
        return 0
    fi

    local commit_msg
    commit_msg=$(call_gemini_api "${prompt}")

    echo "${commit_msg}"
    log_success "Commit message generated"
}

generate_pr_description() {
    local base_branch="${1:-main}"
    local dry_run="${2:-false}"

    log_info "Generating PR description (comparing to ${base_branch})..."

    # Get diff from base branch
    local diff
    diff=$(git diff "${base_branch}"...HEAD 2>/dev/null || echo "")

    if [[ -z "${diff}" ]]; then
        log_error "No differences found from ${base_branch}"
        return 1
    fi

    local prompt="Generate a comprehensive Pull Request description. "
    prompt+="Include: 1) Summary of changes, 2) Motivation, 3) Testing done, "
    prompt+="4) Related issues, 5) Checklist. Format as Markdown.\\n\\n"
    prompt+="--- Git Diff ---\\n${diff}\\n--- End Diff ---"

    if [[ "${dry_run}" == "true" ]]; then
        log_info "[DRY-RUN] Would generate PR description"
        return 0
    fi

    local pr_desc
    pr_desc=$(call_gemini_api "${prompt}")

    echo "${pr_desc}"
    log_success "PR description generated"
}

code_review() {
    local scope="$1"
    local dry_run="${2:-false}"

    log_info "Performing code review for: ${scope}"

    local files_to_review=()
    while IFS= read -r -d '' file; do
        files_to_review+=("${file}")
    done < <(find "${scope}" -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.cs" -o -name "*.sh" \) -print0 2>/dev/null)

    if [[ ${#files_to_review[@]} -eq 0 ]]; then
        log_warning "No source files found in ${scope}"
        return 0
    fi

    local prompt="Perform a thorough code review of the following code. "
    prompt+="Identify: 1) Bugs, 2) Security issues, 3) Performance problems, "
    prompt+="4) Code style violations, 5) Suggested improvements. "
    prompt+="Format as Markdown with severity levels.\\n\\n"

    for file in "${files_to_review[@]}"; do
        prompt+="--- File: ${file} ---\\n"
        prompt+="$(head -200 "${file}" 2>/dev/null | tr '\n' '\\n')\\n\\n"
    done

    if [[ "${dry_run}" == "true" ]]; then
        log_info "[DRY-RUN] Would review ${#files_to_review[@]} files"
        return 0
    fi

    local review
    review=$(call_gemini_api "${prompt}")

    local review_file="${scope}/CODE_REVIEW.md"
    echo "${review}" > "${review_file}"
    log_success "Code review written to: ${review_file}"
}

# =============================================================================
# Main
# =============================================================================

main() {
    local type=""
    local scope=""
    local output=""
    local dry_run="false"
    local verbose="false"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -t|--type)
                type="$2"
                shift 2
                ;;
            -s|--scope)
                scope="$2"
                shift 2
                ;;
            -o|--output)
                output="$2"
                shift 2
                ;;
            -d|--dry-run)
                dry_run="true"
                shift
                ;;
            -v|--verbose)
                verbose="true"
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # Validate required arguments
    if [[ -z "${type}" ]]; then
        log_error "--type is required"
        show_help
        exit 1
    fi

    # Check requirements
    check_requirements

    # Execute based on type
    case "${type}" in
        docs)
            if [[ -z "${scope}" ]]; then
                log_error "--scope is required for docs regeneration"
                exit 1
            fi
            regenerate_docs "${scope}" "${output:-${scope}}" "${dry_run}"
            ;;
        tests)
            if [[ -z "${scope}" ]]; then
                log_error "--scope is required for test generation"
                exit 1
            fi
            generate_tests "${scope}" "${output:-${scope}}" "${dry_run}"
            ;;
        commit-msg)
            generate_commit_msg "${dry_run}"
            ;;
        pr-description)
            generate_pr_description "main" "${dry_run}"
            ;;
        code-review)
            if [[ -z "${scope}" ]]; then
                log_error "--scope is required for code review"
                exit 1
            fi
            code_review "${scope}" "${dry_run}"
            ;;
        refactor)
            log_warning "Refactor suggestions not yet implemented"
            exit 1
            ;;
        *)
            log_error "Unknown type: ${type}"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
