#!/usr/bin/env bash
# This script iterates over cf-common lib chart ".tpl" files and updates named templates versions to match version in `Chart.yaml`

set -eoux pipefail

yq() {
  docker run --rm -i -v "${PWD}":/workdir mikefarah/yq "$@"
}

SRCROOT="$(cd "$(dirname "$0")/.." && pwd)"

LIB_CHART_PATH="./charts/cf-common/templates"
CHART_VERSION="$(yq eval '.version' ./charts/cf-common/Chart.yaml)"
SEMVER_REGEXP="[0-9]\+\.[0-9]\+\.[0-9]\+"

docker run --rm -v "${SRCROOT}":/workdir -w /workdir alpine sh -c "find $LIB_CHART_PATH -type f -name '*.tpl' -exec sed -i 's/\(-$SEMVER_REGEXP\)/-$CHART_VERSION/g' {} +"
