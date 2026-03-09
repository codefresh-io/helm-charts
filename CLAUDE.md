# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a collection of Helm charts for Codefresh. The central piece is `cf-common`, a Helm **library chart** that provides reusable templates consumed by all other charts as a dependency.

## Charts

- **cf-common** — Library chart (not installable directly). Provides all the named templates other charts use.
- **cf-common-test** — Test harness for `cf-common`. Unit tests live here; uses `file://../cf-common` as a local dependency.
- **builder**, **runner** — Runtime charts (depend on an older pinned cf-common version via OCI).
- **internal-gateway**, **ngrok-agent**, **gost-agent** — Application charts with their own templates.
- **cf-vcluster** — vCluster chart with Prometheus operator plugin support.

## Commands

All tooling runs via Docker. There is no local `helm` dependency required for scripts.

### Lint

```bash
./scripts/lint.sh
```

Runs `chart-testing` (`ct lint`) against all charts using `ct.yaml` and `lintconf.yaml`.

### Generate/Update Documentation

```bash
./scripts/helm-docs.sh
```

Uses `helm-docs` via Docker. Must be run before committing when `values.yaml` or `README.md.gotmpl` changes. CI will fail if docs are outdated.

### Update Named Template Versions

```bash
./scripts/update-tpl-version.sh
```

After bumping `charts/cf-common/Chart.yaml` version, run this to update the version suffix in all `.tpl` named template definitions (e.g., `cf-common-0.31.0.*`). CI will fail if this is outdated.

## Architecture: cf-common Library Chart

Named templates follow the convention `cf-common-{VERSION}.{resource}` (e.g., `cf-common-0.31.0.all`). This versioning allows multiple versions to coexist.

Consumer charts invoke the library like this (from `cf-common-test/templates/controller.yaml`):
```yaml
{{ $templateName := printf "cf-common-%s.controller" (index .Subcharts "cf-common").Chart.Version }}
{{- include $templateName . -}}
```

### Template Organization

```
charts/cf-common/templates/
  common/       # Shared helpers: labels, names, annotations, tpl rendering
  container/    # Container spec, env vars, image, probes, ports, volumemounts
  controller/   # Deployment, StatefulSet, Job, CronJob, Rollout (Argo), pod spec, volumes
  render/       # Top-level renderers: all, configmaps, secrets, hpa, pdb, rbac, etc.
  services/     # Service rendering
  ingress/      # Ingress rendering
  persistence/  # PVC rendering
  keda/         # KEDA ScaledObject and TriggerAuthentication
  external-secrets/ # ExternalSecret rendering
  signadot/     # VirtualService for Signadot
  classic/      # Legacy helpers for classic Codefresh env var patterns
```

The entry point `cf-common-{VERSION}.all` renders controller + service + configmaps + secrets + serviceaccount + rbac + pvc. Other resources (HPA, ingress, PDB, serviceMonitor, podMonitor, KEDA, extraResources) must be included separately from consumer chart templates.

### Controller Types

`controller.type` supports: `deployment`, `statefulset`, `job`, `cronjob`, `rollout` (Argo Rollouts).

### Key Patterns

- **Helm template support**: Many values fields (env vars, volume names, ingress hosts) are passed through `tpl`, enabling Go template expressions in values.
- **Version pinning**: Each chart pins a specific `cf-common` version as a dependency. `cf-common-test` uses `"*"` (local file reference) to always test the current version.
- **Versioned template names**: When bumping `cf-common` version, run `./scripts/update-tpl-version.sh` to update all `cf-common-X.Y.Z.*` template name suffixes.

## CI / Release

- **Lint & Test** (PR): Runs `ct lint`, docs check, template version check, and `helm unittest` for all changed charts. Changed `cf-common` automatically includes `cf-common-test` in the test matrix.
- **Release** (merge to master): Uses `chart-releaser-action` to publish to GitHub Releases and uploads to `oci://quay.io/codefresh/charts`.
- **Dev builds** (PR): Changed charts are pushed to `oci://quay.io/codefresh/charts/dev` with the branch-normalized name.
- `check-version-increment: true` in `ct.yaml` means every chart change requires a version bump in `Chart.yaml`.
- `cf-common-test` is excluded from `ct lint` and release (it is not a deployable chart).
