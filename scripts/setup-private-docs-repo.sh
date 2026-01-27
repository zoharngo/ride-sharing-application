#!/usr/bin/env bash
#
# setup-private-docs-repo.sh
#
# Creates a private GitHub repository for RideIL technical documentation
# and pushes the docs that were split out of the public repo.
#
# Prerequisites:
#   - GitHub CLI (gh) installed and authenticated
#   - The private docs content at ../rideil-docs-private/
#
# Usage:
#   ./scripts/setup-private-docs-repo.sh [github-org-or-user]
#
# Example:
#   ./scripts/setup-private-docs-repo.sh zoharngo

set -euo pipefail

OWNER="${1:-zoharngo}"
REPO_NAME="rideil-docs-private"
DOCS_SOURCE="$(cd "$(dirname "$0")/.." && pwd)/../rideil-docs-private"

if ! command -v gh &>/dev/null; then
  echo "Error: GitHub CLI (gh) is required. Install from https://cli.github.com/"
  exit 1
fi

if [ ! -d "$DOCS_SOURCE" ]; then
  echo "Error: Docs source directory not found at $DOCS_SOURCE"
  echo "Expected the rideil-docs-private directory next to ride-sharing-application."
  exit 1
fi

echo "Creating private repository: ${OWNER}/${REPO_NAME} ..."
gh repo create "${OWNER}/${REPO_NAME}" \
  --private \
  --description "Internal technical documentation for the RideIL ride-sharing platform" \
  --confirm 2>/dev/null || {
    echo "Repository may already exist, continuing..."
  }

cd "$DOCS_SOURCE"

if [ ! -d .git ]; then
  git init -b main
  git add -A
  git commit -m "Initial commit: migrate technical docs from public repo

Moved FRD, FRS, Development Plan, and Privacy Policy from
the public ride-sharing-application repository into this
dedicated private documentation repository."
fi

git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/${OWNER}/${REPO_NAME}.git"
git push -u origin main

echo ""
echo "Done! Private docs repository created at:"
echo "  https://github.com/${OWNER}/${REPO_NAME}"
echo ""
echo "Documents included:"
echo "  - docs/FRD.md                (Functional Requirements Document)"
echo "  - docs/FRS.md                (Functional Requirements Specification)"
echo "  - docs/DEVELOPMENT_PLAN.md   (Development Plan)"
echo "  - docs/PRIVACY_POLICY.md     (Privacy Policy)"
