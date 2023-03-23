#!/usr/bin/env bash

# Script iterates over cf-common lib chart ".tpl" files and updates named templates versions to match version in `Chart.yaml`

set -eoux pipefail

SRCROOT="$(cd "$(dirname "$0")/.." && pwd)"

LIB_CHART_PATH="./charts/cf-common/templates"
CHART_VERSION="$(yq eval '.version' ./charts/cf-common/Chart.yaml)"
SEMVER_REGEXP="[0-9]\+\.[0-9]\+\.[0-9]\+"

find $LIB_CHART_PATH -type f -name '*.tpl' -exec sed -i "s/\(v$SEMVER_REGEXP\)/v$CHART_VERSION/g" {} +
