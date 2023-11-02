#!/bin/bash

# Initialize version and isPreRelease variables
VERSION=${{VERSION}}
IS_PRERELEASE=${{isPreRelease}}

# Get the latest commit message
latest_commit_message=$(git log -1 --pretty=%s)

# Check if the latest commit message contains "pre-release" keyword
if [[ "$latest_commit_message" == *"[pre-release]"* ]]; then
  # Set isPreRelease to true
  IS_PRERELEASE="true"
fi

# Check if the latest commit message contains a version bump keyword, e.g., "bump"
if [[ "$latest_commit_message" == *"[bump]"* ]]; then
  # Extract the current version from the project (e.g., from a file)
  current_version=$(cat version.txt)

  # Split the version string into major, minor, and patch parts
  IFS='.' read -ra version_parts <<< "$current_version"

  # Increment the version (e.g., increment patch version)
  version_parts[2]=$((version_parts[2] + 1))

  # Reconstruct the updated version string
  VERSION="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}"
fi

# Export environment variables for use in the GitHub Actions workflow
echo "VERSION=$VERSION" >> $GITHUB_ENV
echo "IS_PRERELEASE=$IS_PRERELEASE" >> $GITHUB_ENV