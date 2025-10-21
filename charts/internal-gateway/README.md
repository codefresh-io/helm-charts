# internal-gateway

![Version: 0.12.1](https://img.shields.io/badge/Version-0.12.1-informational?style=flat-square) ![AppVersion: v0.0.0](https://img.shields.io/badge/AppVersion-v0.0.0-informational?style=flat-square)

A Helm chart for Codefresh Internal Gateway

**Homepage:** <https://github.com/codefresh-io/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| codefresh |  | <https://codefresh-io.github.io/> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://quay.io/codefresh/charts | cf-common | 0.28.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| codefresh | object | See below | Codefresh platform settings List of services endpoints and port |
| codefresh.serviceEndpoints | object | `{"argo-platform-api-events":{},"argo-platform-api-graphql":{},"argo-platform-ui":{},"cfapi-admin":{},"cfapi-auth":{},"cfapi-downloadlogmanager":{},"cfapi-endpoints":{},"cfapi-environments":{},"cfapi-gitops-resource-receiver":{},"cfapi-kubernetes-endpoints":{},"cfapi-kubernetesresourcemonitor":{},"cfapi-teams":{},"cfapi-test-reporting":{},"cfapi-ws":{},"cfui":{}}` | Override defaults here! |
| container | object | See below | Main container parameters |
| containerSecurityContext | object | See below | Container security context parameters |
| controller | object | See below | Controller parameters |
| global | object | See below | Global parameters |
| global.clusterDomain | string | `"cluster.local"` | configures cluster domain ("cluster.local" by default) |
| global.dnsNamespace | string | `"kube-system"` | configures DNS service namespace |
| global.dnsService | string | `"kube-dns"` | configures DNS service name |
| hpa | object | See below | HPA parameters |
| ingress | object | See below | Ingress parameters |
| keda.enabled | bool | `false` |  |
| libraryMode | bool | `false` |  |
| nginx.config.accessLogEnabled | bool | `true` | Enables NGINX access logs |
| nginx.config.errorLogLevel | string | `"error"` | Sets the log level of the NGINX error log. One of `debug`, `info`, `notice`, `warn`, `error`, `crit`, `alert`, or `emerg` |
| nginx.config.file | string | See below | Config file contents for Nginx. Passed through the `tpl` function to allow templating. !! Moved into separate template at `templates/nginx/configmap.yaml` |
| nginx.config.httpDirectives | object | `{}` | Allows appending custom directives to the http block (map) |
| nginx.config.httpSnippet | string | `""` | Allows appending custom configuration to the http block (string) |
| nginx.config.locationDirectives | object | `{}` | Allows appending custom directives to the location blocks (map) |
| nginx.config.locationSnippet | string | `""` | Allows appending custom configuration to the location blocks (string) |
| nginx.config.locations | object | `{}` | Allow add custom locations |
| nginx.config.logFormat | string | `"main escape=json '{ \"time\": \"$time_iso8601\", \"remote_addr\": \"$proxy_protocol_addr\", \"x-forward-for\": \"$proxy_add_x_forwarded_for\", \"remote_user\": \"$remote_user\", \"bytes_sent\": $bytes_sent, \"request_time\": $request_time, \"status\": $status, \"vhost\": \"$host\", \"request_proto\": \"$server_protocol\", \"path\": \"$uri\", \"request_query\": \"$args\", \"request_length\": $request_length, \"duration\": $request_time, \"method\": \"$request_method\", \"http_referrer\": \"$http_referer\", \"http_user_agent\": \"$http_user_agent\", \"http_x_github_delivery\": \"$http_x_github_delivery\", \"http_x_hook_uuid\": \"$http_x_hook_uuid\", \"metadata\": { \"correlationId\": \"$request_id\", \"service\": \"ingress\", \"time\": \"$time_iso8601\" } }';"` | NGINX log format |
| nginx.config.resolver | string | `nil` | Allows to set a custom resolver |
| nginx.config.rootDirectives | object | `{"load_module":"modules/ngx_http_js_module.so"}` | Allows appending custom directives to the root block (map) |
| nginx.config.rootSnippet | string | `""` | Allows appending custom directives to the root block (string) |
| nginx.config.serverDirectives | object | `{}` | Allows appending custom directives to the server block (map) |
| nginx.config.serverSnippet | string | `""` | Allows appending custom configuration to the server block (string) |
| nginx.config.verboseLogging | bool | `false` | Enable logging of 2xx and 3xx HTTP requests |
| nginx.config.workerConnections | string | `"16384"` | Sets the maximum number of simultaneous connections that can be opened by a worker process. |
| nginx.config.workerProcesses | string | `"8"` | Defines the number of worker processes. |
| nginx.config.workerRlimitNofile | string | `"1047552"` | Changes the limit on the largest size of a core file (RLIMIT_CORE) for worker processes. Used to increase the limit without restarting the main process. |
| nginx.extraConfigsPatterns | list | `[]` |  |
| nginx.scriptFilesPatterns | list | `[]` | Path to NJS scripts |
| pdb | object | See below | PDB parameters |
| podAnnotations | object | See below | Pod annotations |
| podSecurityContext | object | See below | Pod Security Context parameters |
| rbac | object | See below | RBAC parameters |
| service | object | See below | Service parameters |
| serviceAccount | object | See below | Service Account parameters |
| signadot | bool | `false` | Misc signadot configuration |
| topologySpreadConstraints | string | See below | Topologe Spread Constraints parameters |
| volumes | object | See below | Volumes parameters |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.9.1](https://github.com/norwoodj/helm-docs/releases/v1.9.1)
