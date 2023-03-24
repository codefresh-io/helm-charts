# internal-gateway

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![AppVersion: v0.0.1](https://img.shields.io/badge/AppVersion-v0.0.1-informational?style=flat-square)

A Helm chart for Codefresh Internal Gateway

**Homepage:** <https://github.com/codefresh-io/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| codefresh |  | <https://codefresh-io.github.io/> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://chartmuseum.codefresh.io/cf-common | cf-common | 0.1.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| codefresh | object | See below | Codefresh services parameters |
| configMaps.config.data."nginx.conf" | string | `"{{ include (printf \"cf-common-%s.tplrender\" (index .Subcharts \"cf-common\").Chart.Version) (dict \"Values\" .Values.nginx.config.file \"context\" $) | nindent 4 }}\n"` |  |
| configMaps.config.enabled | bool | `true` |  |
| container.env | object | `{}` |  |
| container.envFrom | list | `[]` |  |
| container.image.registry | string | `"docker.io"` |  |
| container.image.repository | string | `"nginxinc/nginx-unprivileged"` |  |
| container.image.tag | string | `"1.23-alpine"` |  |
| container.probes.liveness.enabled | bool | `true` |  |
| container.probes.liveness.httpGet.path | string | `"/"` |  |
| container.probes.liveness.httpGet.port | string | `"http"` |  |
| container.probes.liveness.spec.failureThreshold | int | `3` |  |
| container.probes.liveness.spec.initialDelaySeconds | int | `30` |  |
| container.probes.liveness.spec.periodSeconds | int | `5` |  |
| container.probes.liveness.spec.successThreshold | int | `1` |  |
| container.probes.liveness.spec.timeoutSeconds | int | `3` |  |
| container.probes.liveness.type | string | `"httpGet"` |  |
| container.probes.readiness.enabled | bool | `true` |  |
| container.probes.readiness.httpGet.path | string | `"/ready"` |  |
| container.probes.readiness.httpGet.port | string | `"http"` |  |
| container.probes.readiness.spec.failureThreshold | int | `3` |  |
| container.probes.readiness.spec.initialDelaySeconds | int | `15` |  |
| container.probes.readiness.spec.periodSeconds | int | `5` |  |
| container.probes.readiness.spec.successThreshold | int | `1` |  |
| container.probes.readiness.spec.timeoutSeconds | int | `3` |  |
| container.probes.readiness.type | string | `"httpGet"` |  |
| container.resources.limits.cpu | string | `"1000m"` |  |
| container.resources.limits.memory | string | `"2Gi"` |  |
| container.resources.requests.cpu | string | `"100m"` |  |
| container.resources.requests.memory | string | `"128Mi"` |  |
| container.volumeMounts.config.path[0].mountPath | string | `"/etc/nginx"` |  |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| controller.deployment.rollingUpdate.maxSurge | string | `"50%"` |  |
| controller.deployment.rollingUpdate.maxUnavailable | int | `0` |  |
| controller.deployment.strategy | string | `"RollingUpdate"` |  |
| controller.enabled | bool | `true` |  |
| controller.replicas | int | `2` |  |
| controller.type | string | `"deployment"` |  |
| global | object | `{"clusterDomain":"cluster.local","dnsNamespace":"kube-system","dnsService":"kube-dns"}` | Global parameters |
| global.clusterDomain | string | `"cluster.local"` | configures cluster domain ("cluster.local" by default) |
| global.dnsNamespace | string | `"kube-system"` | configures DNS service namespace |
| global.dnsService | string | `"kube-dns"` | configures DNS service name |
| hpa.enabled | bool | `false` |  |
| hpa.maxReplicas | int | `10` |  |
| hpa.minReplicas | int | `2` |  |
| hpa.targetCPUUtilizationPercentage | int | `70` |  |
| hpa.targetMemoryUtilizationPercentage | int | `70` |  |
| ingress.main.enabled | bool | `false` |  |
| ingress.main.hosts[0].host | string | `"{{ .Values.codefresh.url }}"` |  |
| ingress.main.hosts[0].paths[0].path | string | `"/2.0"` |  |
| ingress.main.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.main.hosts[0].paths[0].service.name | string | `"{{ include \"internal-gateway.fullname\" . }}"` |  |
| ingress.main.hosts[0].paths[0].service.port | string | `"{{ .Values.service.main.ports.http.port }}"` |  |
| ingress.main.ingressClassName | string | `"nginx"` |  |
| libraryMode | bool | `false` |  |
| nginx.config.accessLogEnabled | bool | `true` | Enables NGINX access logs |
| nginx.config.errorLogLevel | string | `"error"` | Sets the log level of the NGINX error log. One of `debug`, `info`, `notice`, `warn`, `error`, `crit`, `alert`, or `emerg` |
| nginx.config.file | string | `"worker_processes 5;  ## Default: 1\nerror_log  /dev/stderr {{ .Values.nginx.config.errorLogLevel }};\npid        /tmp/nginx.pid;\nworker_rlimit_nofile 8192;\n\nevents {\n  worker_connections  4096;  ## Default: 1024\n}\n\nhttp {\n  client_body_temp_path /tmp/client_temp;\n  proxy_temp_path       /tmp/proxy_temp_path;\n  fastcgi_temp_path     /tmp/fastcgi_temp;\n  uwsgi_temp_path       /tmp/uwsgi_temp;\n  scgi_temp_path        /tmp/scgi_temp;\n\n  default_type application/octet-stream;\n  log_format   {{ .Values.nginx.config.logFormat }}\n\n  {{- if .Values.nginx.verboseLogging }}\n  access_log   /dev/stderr  main;\n  {{- else }}\n\n  map $status $loggable {\n    ~^[23]  0;\n    default 1;\n  }\n  access_log   {{ .Values.nginx.config.accessLogEnabled | ternary \"/dev/stderr  main  if=$loggable;\" \"off;\" }}\n  {{- end }}\n  sendfile     on;\n  tcp_nopush   on;\n\n  {{- if .Values.nginx.config.resolver }}\n  resolver {{ .Values.nginx.config.resolver }};\n  {{- else }}\n  resolver {{ .Values.global.dnsService }}.{{ .Values.global.dnsNamespace }}.svc.{{ .Values.global.clusterDomain }};\n  {{- end }}\n\n  {{- with .Values.nginx.config.httpSnippet }}\n  {{ . | nindent 2 }}\n  {{- end }}\n\n  server {\n    listen 8080;\n\n    location = / {\n      return 200 'OK';\n      auth_basic off;\n    }\n\n    location = /ready {\n      return 200 'OK';\n      auth_basic off;\n    }\n\n    location /api/auth/authenticate {\n      # Authenticate through Classic CF platform\n      set $cfapi_svc {{ .Values.codefresh.cfApiEndpointsSvc }};\n      set $cfapi_port {{ .Values.codefresh.cfApiEndpointsPort }};\n      proxy_pass http://$cfapi_svc:$cfapi_port;\n      proxy_pass_request_body off; # no need to send the POST body\n      proxy_set_header Content-Length \"\";\n      proxy_set_header X-Real-IP $remote_addr;\n      proxy_set_header X-Original-URI $request_uri;\n      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n      proxy_set_header X-Forwarded-Proto $scheme;\n\n      {{- range $key, $val := .Values.nginx.config.proxyConf }}\n      {{ printf \"%s %s;\" $key $val }}\n      {{- end }}\n    }\n\n    location /2.0/api/events {\n      # Any request to this server will first be sent to this URL\n      auth_request /api/auth/authenticate;\n      # Sets the HTTP header 'x-cf-auth-entity' that old platform sends, into $auth_entity variable\n      auth_request_set $auth_entity $upstream_http_x_cf_auth_entity;\n      set $argo_platform_api_events_svc {{ .Values.codefresh.apiEventsSvc }};\n      set $argo_platform_api_events_port {{ .Values.codefresh.apiEventsPort }};\n      proxy_pass  http://$argo_platform_api_events_svc:$argo_platform_api_events_port;\n\n      proxy_http_version 1.1;\n      proxy_set_header Upgrade $http_upgrade;\n      proxy_set_header Connection \"upgrade\";\n      proxy_set_header Host $host;\n      proxy_set_header X-CF-Auth-Entity $auth_entity;\n      proxy_cache_bypass $http_upgrade;\n\n      {{- range $key, $val := .Values.nginx.config.proxyConf }}\n      {{ printf \"%s %s;\" $key $val }}\n      {{- end }}\n    }\n\n    location /2.0/api/graphql {\n      # Any request to this server will first be sent to this URL\n      auth_request /api/auth/authenticate;\n      # Sets the HTTP header 'x-cf-auth-entity' that old platform sends, into $auth_entity variable\n      auth_request_set $auth_entity $upstream_http_x_cf_auth_entity;\n      set $argo_platform_api_graphql_svc {{ .Values.codefresh.apiGraphqlSvc }};\n      set $argo_platform_api_graphql_port {{ .Values.codefresh.apiGraphqlPort }};\n      proxy_pass  http://$argo_platform_api_graphql_svc:$argo_platform_api_graphql_port;\n\n      proxy_http_version 1.1;\n      proxy_set_header Upgrade $http_upgrade;\n      proxy_set_header Connection \"upgrade\";\n      proxy_set_header Host $host;\n      proxy_set_header X-CF-Auth-Entity $auth_entity;\n      proxy_cache_bypass $http_upgrade;\n\n      {{- range $key, $val := .Values.nginx.config.proxyConf }}\n      {{ printf \"%s %s;\" $key $val }}\n      {{- end }}\n    }\n\n    location /2.0 {\n      set $argo_platform_ui_svc {{ .Values.codefresh.argoPlatformUiSvc }};\n      set $argo_platform_ui_port {{ .Values.codefresh.argoPlatformUiPort }};\n      proxy_pass  http://$argo_platform_ui_svc:$argo_platform_ui_port;\n\n      proxy_http_version 1.1;\n      proxy_set_header Upgrade $http_upgrade;\n      proxy_set_header Connection \"upgrade\";\n      proxy_set_header Host $host;\n      proxy_set_header X-CF-Auth-Entity $auth_entity;\n      proxy_cache_bypass $http_upgrade;\n\n      {{- range $key, $val := .Values.nginx.config.proxyConf }}\n      {{ printf \"%s %s;\" $key $val }}\n      {{- end }}\n    }\n\n    {{- with .Values.nginx.config.serverSnippet }}\n    {{ . | nindent 4 }}\n    {{- end }}\n  }\n}\n"` | Config file contents for Nginx. Passed through the `tpl` function to allow templating. |
| nginx.config.httpSnippet | string | `""` | Allows appending custom configuration to the http block |
| nginx.config.logFormat | string | `"main '$remote_addr - $remote_user [$time_local]  $status '\n        '\"$request\" $body_bytes_sent \"$http_referer\" '\n        '\"$http_user_agent\" \"$http_x_forwarded_for\"';"` | NGINX log format |
| nginx.config.proxyConf | object | `{"client_body_buffer_size":"16k","client_max_body_size":"5M","proxy_buffer_size":"64k","proxy_buffers":"4 64k"}` | Set proxy parameters Ref: https://nginx.org/en/docs/http/ngx_http_proxy_module.html |
| nginx.config.resolver | string | `nil` | Allows to set a custom resolver |
| nginx.config.serverSnippet | string | `""` | Allows appending custom configuration to the server block |
| nginx.config.verboseLogging | bool | `true` | Enable logging of 2xx and 3xx HTTP requests |
| pdb.enabled | bool | `false` |  |
| pdb.minAvailable | string | `"50%"` |  |
| podAnnotations.checksum/config | string | `"{{ include (printf \"cf-common-%s.tplrender\" (index .Subcharts \"cf-common\").Chart.Version) (dict \"Values\" .Values.nginx.config.file \"context\" $) | sha256sum }}"` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.fsGroup | int | `101` |  |
| podSecurityContext.runAsGroup | int | `101` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `101` |  |
| rbac.enabled | bool | `false` |  |
| service.main.enabled | bool | `true` |  |
| service.main.ports.http.port | int | `80` |  |
| service.main.ports.http.protocol | string | `"HTTP"` |  |
| service.main.ports.http.targetPort | int | `8080` |  |
| service.main.primary | bool | `true` |  |
| service.main.type | string | `"ClusterIP"` |  |
| serviceAccount.enabled | bool | `false` |  |
| topologySpreadConstraints | string | `"- maxSkew: 1\n  topologyKey: kubernetes.io/hostname\n  whenUnsatisfiable: ScheduleAnyway\n  labelSelector:\n    matchLabels:\n      {{- include \"internal-gateway.selectorLabels\" . | nindent 6 }}\n- maxSkew: 1\n  topologyKey: topology.kubernetes.io/zone\n  whenUnsatisfiable: ScheduleAnyway\n  labelSelector:\n    matchLabels:\n      {{- include \"internal-gateway.selectorLabels\" . | nindent 6 }}\n"` |  |
| volumes.config.enabled | bool | `true` |  |
| volumes.config.type | string | `"configMap"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
