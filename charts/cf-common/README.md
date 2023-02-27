# cf-common

Codefresh library chart

![Version: 0.0.14](https://img.shields.io/badge/Version-0.0.14-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square) ![AppVersion: v0.0.0](https://img.shields.io/badge/AppVersion-v0.0.0-informational?style=flat-square)

## Installing the Chart

This is a [Helm Library Chart](https://helm.sh/docs/topics/library_charts/#helm).

**WARNING: THIS CHART IS NOT MEANT TO BE INSTALLED DIRECTLY**

## Using this library

Include this chart as a dependency in your `Chart.yaml` e.g.

```yaml
# Chart.yaml
dependencies:
- name: cf-common
  version: 0.0.14
  repository: https://chartmuseum.codefresh.io/cf-common
```

**Read through the [values.yaml](./values.yaml) file.**

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalContainers | list | `[]` | Array of extra (sidecar) containers to add |
| affinity | object | `{}` | Set affinity constrains |
| automountServiceAccountToken | bool | `true` | Specifies whether a service account token should be automatically mounted. |
| configMaps | object | See below | Create configMap with the values you provide. Additional configMaps can be added by adding a dictionary key similar to the 'config' object. |
| configMaps.config | object | `{"annotations":{},"data":{},"enabled":false,"labels":{}}` | ConfigMap name. Make sure to use the same name in `volumes` and `container.volumeMounts` |
| configMaps.config.annotations | object | `{}` | Add additional annotations to the configMap |
| configMaps.config.data | object | `{}` | ConfigMap data content. |
| configMaps.config.enabled | bool | `false` | Enable the configMap |
| configMaps.config.labels | object | `{}` | Add additional labels to the configMap |
| container | object | See below | Main Container parameters |
| container.args | list | `[]` | Override args for the container |
| container.command | list | `[]` | Override commands for the container |
| container.containerSecurityContext | object | `{}` | Set security context for container |
| container.env | object | `{}` | Set environments variables. Helm template supported. |
| container.envFrom | list | `[]` | Set Secrets or ConfigMaps loaded as environment variables. |
| container.image | object | `{"pullPolicy":null,"registry":null,"repository":null,"tag":null}` | Image parameters |
| container.image.pullPolicy | string | `nil` | Set image pull policy (`Always`, `Never`, `IfNotPresent`) |
| container.image.registry | string | `nil` | Set image registry |
| container.image.repository | string | `nil` | Set image repository |
| container.image.tag | string | `nil` | Set image tag |
| container.lifecycle | object | `{}` | Set the lifecycle hooks for container |
| container.probes.liveness.enabled | bool | `false` | Enable liveness probe |
| container.probes.liveness.exec.command | list | `[]` | Set exec probe commands |
| container.probes.liveness.httpGet.path | string | `nil` | Set httpGet probe path |
| container.probes.liveness.httpGet.port | string | `nil` | Set httpGet probe port (name ) |
| container.probes.liveness.spec.failureThreshold | string | `nil` | Set failure threshold for probe |
| container.probes.liveness.spec.initialDelaySeconds | string | `nil` | Set initial delay seconds for probe |
| container.probes.liveness.spec.periodSeconds | string | `nil` | Set period seconds for probe |
| container.probes.liveness.spec.successThreshold | string | `nil` | Set success threshold for probe |
| container.probes.liveness.spec.timeoutSeconds | string | `nil` | Set timeout seconds for probe |
| container.probes.liveness.type | string | `nil` | Set liveness probe type (httpGet/exec) |
| container.resources | object | `{"limits":{},"requests":{}}` | Set the resources (requests/limits) for the container |
| container.volumeMounts | object | `{}` | Set volume mounts for container |
| controller | object | See below | Controller parameters |
| controller.annotations | object | `{}` | Set annotations on controller |
| controller.deployment.rollingUpdate.maxSurge | string | `nil` | Set RollingUpdate max surge (absolute number or percentage) |
| controller.deployment.rollingUpdate.maxUnavailable | string | `nil` | Set RollingUpdate max unavailable (absolute number or percentage) |
| controller.deployment.strategy | string | `nil` | Set deployment upgrade strategy (`RollingUpdate`/`Recreate`) |
| controller.labels | object | `{}` | Set labels on controller |
| controller.replicas | string | `nil` | Set number of pods |
| controller.revisionHistoryLimit | string | `nil` | Set ReplicaSet revision history limit |
| controller.type | string | `nil` | Define the controller type (`deployment` \ `rollout`) |
| extraResources | list | `[]` | Array of extra objects to deploy with the release |
| global | object | `{"controller":{"rollout":{"analysis":{"successfulRunHistoryLimit":null,"unsuccessfulRunHistoryLimit":null},"canary":{"maxSurge":null,"maxUnavailable":null,"steps":[{"setWeight":null},{"pause":{"duration":null}},{"setWeight":null},{"pause":{"duration":null}}]},"strategy":null},"type":null},"env":{},"imagePullSecrets":[],"imageRegistry":""}` | Global parameters |
| global.controller.type | string | `nil` | Define the controller type (`deployment` \ `rollout`) |
| global.env | object | `{}` | Global Env vars. NO precedence over `.Values.container.env` |
| global.imagePullSecrets | list | `[]` | Global Docker registry secret names as array |
| global.imageRegistry | string | `""` | Global Docker image registry |
| hpa | object | See below | Configure autoscaling (Horizontal Pod Autoscaler) |
| hpa.enabled | bool | `false` | Enable HPA |
| hpa.maxReplicas | string | `nil` | Set maximum autoscaling replicas |
| hpa.metrics | list | `[]` | Set custom metrics |
| hpa.minReplicas | string | `nil` | Set minimum autoscaling replicas |
| hpa.targetCPUUtilizationPercentage | string | `nil` | Set target CPU utilization percentage |
| imagePullSecrets | list | `[]` | Set image pull secrets as array |
| ingress | object | See below | Configure the Ingresses for the chart. Additional Ingresses can be added by adding a dictionary key similar to the 'main' ingress. |
| ingress.main.annotations | object | `{}` | Add additional annotations for ingress. |
| ingress.main.enabled | bool | `false` | Enables or disables the ingress |
| ingress.main.hosts[0].host | string | `"domain.example.com"` | Host address. Helm template can be passed. |
| ingress.main.hosts[0].paths[0].path | string | `"/"` | Path. Helm template can be passed. |
| ingress.main.hosts[0].paths[0].pathType | string | `nil` | Path Type (`Prefix`/`ImplementationSpecific`(default)/`Exact`) |
| ingress.main.hosts[0].paths[0].service.name | string | `nil` | Set the service name reference for this path. Helm template can be passed. |
| ingress.main.hosts[0].paths[0].service.port | string | `nil` | Set the service port reference for this path. Helm template can be passed. |
| ingress.main.ingressClassName | string | `nil` | Set the ingressClass that is used for the ingress. |
| ingress.main.labels | object | `{}` | Add additional labels for ingress. |
| ingress.main.tls | list | `[]` | Configure TLS for the ingress. Both secretName and hosts can process a Helm template. |
| initContainers | list | `[]` | Array of init containers to add |
| nodeSelector | object | `{}` | Set node selection constrains |
| pdb | object | See below | Configure Pod Disruption Budget |
| pdb.enabled | bool | `false` | Enable PDB |
| pdb.maxUnavailable | string | `""` | Set number of pods that are unavailable after eviction as number of percentage |
| pdb.minAvailable | string | `""` | Set number of pods that are available after eviction as number of percentage |
| podAnnotations | object | `{}` | Set additional pod annotations |
| podLabels | object | `{}` | Set additional pod labels |
| podSecurityContext | object | `{}` | Set security context for the pod |
| rbac | object | See below | Configure RBAC parameters |
| rbac.enabled | bool | `false` | Enable RBAC resources |
| rbac.rules | list | `[]` | Create custom rules |
| secrets.secret | object | `{"annotation":{},"data":{},"enabled":false,"labels":{},"stringData":{},"type":"Opaque"}` | Secret name. Make sure to use the same name in `volumes` and `container.volumeMounts` |
| secrets.secret.annotation | object | `{}` | Add additional annotations to the secret |
| secrets.secret.enabled | bool | `false` | Enable the secret |
| secrets.secret.labels | object | `{}` | Add additional labels to the secret |
| secrets.secret.stringData | object | `{}` | Secret data content. Plain text (not base64). Helm template supported. Passed through `tpl`, should be configured as string |
| secrets.secret.type | string | `"Opaque"` | Set secret type (`Opaque`/`kubernetes.io/tls`) |
| service | object | See below | Configure services fo the chart. Additional services can be added by adding a dictionary key similar to the 'main' service. |
| service.main | object | `{"annotations":{},"enabled":false,"extraSelectorLabels":{},"labels":{},"ports":{"http":{"port":null,"protocol":"HTTP","targetPort":null}},"primary":true,"type":"ClusterIP"}` | Service name |
| service.main.annotations | object | `{}` | Add additional annotations for the service |
| service.main.enabled | bool | `false` | Enabled the service |
| service.main.extraSelectorLabels | object | `{}` | Allow adding additional match labels |
| service.main.labels | object | `{}` | Add additional labels for the service |
| service.main.ports | object | `{"http":{"port":null,"protocol":"HTTP","targetPort":null}}` | Configure ports for the service |
| service.main.ports.http | object | `{"port":null,"protocol":"HTTP","targetPort":null}` | Port name |
| service.main.ports.http.port | string | `nil` | Port number |
| service.main.ports.http.protocol | string | `"HTTP"` | Port protocol (`HTTP`/`HTTPS`/`TCP`/`UDP`) |
| service.main.ports.http.targetPort | string | `nil` | Set a service targetPort if you wish to differ the service port from the application port. |
| service.main.primary | bool | `true` | Make this the primary service (used in probes, notes, etc...). If there is more than 1 service, make sure that only 1 service is marked as primary. |
| service.main.type | string | `"ClusterIP"` | Set the service type |
| serviceAccount | object | See below | Configure Service Account |
| serviceAccount.annotations | object | `{}` | Set annotations for Service Account |
| serviceAccount.enabled | bool | `false` | Enable and create Service Account |
| serviceAccount.nameOverride | string | `""` | Override Service Account name (by default, name is generated with `fullname` template) |
| tolerations | list | `[]` | Set tolerations constrains |
| topologySpreadConstraints | list | `[]` | Set topologySpreadConstraints rules. Helm template supported. Passed through `tpl`, should be configured as string |
| volumes | object | See below | Configure volume for the controller. Additional items can be added by adding a dictionary key similar to the 'config'/`secret` key. |
| volumes.config | object | `{"enabled":false,"type":"configMap"}` | Volume name. Make sure to use the same name in `configMaps`/`secrets` and `container.volumeMounts` |
| volumes.config.enabled | bool | `false` | Enable the volume |
| volumes.config.type | string | `"configMap"` | Volume type (configMap/secret) |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.9.1](https://github.com/norwoodj/helm-docs/releases/v1.9.1)