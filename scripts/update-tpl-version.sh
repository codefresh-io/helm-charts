#!/usr/bin/env bash

# Script iterates over cf-common lib chart ".tpl" files and updates named templates versions to match version in `Chart.yaml`

set -eou pipefail

SRCROOT="$(cd "$(dirname "$0")/.." && pwd)"

CHART_PATH="./charts/cf-common/templates"
CHART_VERSION="v$(yq eval '.version' ./charts/cf-common/Chart.yaml)"

find $CHART_PATH -type f -name '*.tpl' -exec sed -i "s/\(v[0-9]\+\.[0-9]\+\.[0-9]\+\)/$CHART_VERSION/g" {} +
