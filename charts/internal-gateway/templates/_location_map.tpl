{{- define "internal-gateway.location-presets" }}
authHeaderSet: |
  auth_request /api/auth/authenticate;
  auth_request_set $auth_entity $upstream_http_x_cf_auth_entity;
  proxy_set_header X-CF-Auth-Entity $auth_entity;
locationSnippet: |
  proxy_http_version 1.1;
  proxy_set_header Connection $connection_upgrade;
  proxy_set_header Host $host;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection $connection_upgrade;
  proxy_set_header X-Request-ID $request_id;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Original-URI $request_uri;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto $scheme;
locationDirectives:
  proxy_buffer_size: "64k"
  proxy_buffers: "4 64k"
  client_max_body_size: "5M"
  client_body_buffer_size: "16k"
  proxy_connect_timeout: "5s"
  proxy_send_timeout: "60s"
  proxy_read_timeout: "60s"
{{- end }}

{{- define "internal-gateway.platform-endpoints-defaults" }}
serviceEndpoints:
  cfapi-endpoints:
    svc: cfapi-endpoints
    port: 80
  cfapi-environments:
    svc: cfapi-environments
    port: 80
  cfapi-downloadlogmanager:
    svc: cfapi-downloadlogmanager
    port: 80
  cfapi-gitops-resource-receiver:
    svc: cfapi-gitops-resource-receiver
    port: 80
  cfapi-test-reporting:
    svc: cfapi-test-reporting
    port: 80
  cfapi-kubernetesresourcemonitor:
    svc: cfapi-kubernetesresourcemonitor
    port: 80
  cfapi-kubernetes-endpoints:
    svc: cfapi-kubernetes-endpoints
    port: 80
  cfapi-admin:
    svc: cfapi-admin
    port: 80
  cfapi-teams:
    svc: cfapi-teams
    port: 80
  cfapi-ws:
    svc: cfapi-ws
    port: 80
  cfui:
    svc: cfui
    port: 80
  argo-platform-api-graphql:
    svc: argo-platform-api-graphql
    port: 80
  argo-platform-api-events:
    svc: argo-platform-api-events
    port: 80
  argo-platform-ui: 
    svc: argo-platform-ui
    port: 4200
  argo-hub:
    svc: argo-hub-platform
    port: 80
  nomios:
    svc: nomios
    port: 80
  jira-addon:
    svc: cf-jira-addon
    port: 9000
{{- end }}

{{- define "internal-gateway.platform-endpoints" }}
{{- $endpointDefaults := include "internal-gateway.platform-endpoints-defaults" . | fromYaml}}
{{- $mergedEndpoints := deepCopy $endpointDefaults }}
  {{- if .Values.codefresh.serviceEndpoints }}
    {{- $mergedEndpoints = mergeOverwrite $endpointDefaults .Values.codefresh }}
  {{- end }}
{{ $mergedEndpoints | toYaml }}
{{- end }}

{{- define "internal-gateway.nginx-config-defaults"}}
  {{- $endpoints := include "internal-gateway.platform-endpoints" . | fromYaml }}
  {{- $presets := include "internal-gateway.location-presets" . | fromYaml }}
nginx:
  config:
    workerProcesses: "8"
    workerConnections: "16384"
    workerRlimitNofile: "1047552"
    verboseLogging: false
    logFormat: |-
        main escape=json '{ "time": "$time_iso8601", "remote_addr": "$proxy_protocol_addr", "x-forward-for": "$proxy_add_x_forwarded_for", "remote_user": "$remote_user", "bytes_sent": $bytes_sent, "request_time": $request_time, "status": $status, "vhost": "$host", "request_proto": "$server_protocol", "path": "$uri", "request_query": "$args", "request_length": $request_length, "duration": $request_time, "method": "$request_method", "http_referrer": "$http_referer", "http_user_agent": "$http_user_agent", "http_x_github_delivery": "$http_x_github_delivery", "http_x_hook_uuid": "$http_x_hook_uuid", "metadata": { "correlationId": "$request_id", "service": "ingress", "time": "$time_iso8601" } }';
    errorLogLevel: error
    accessLogEnabled: true
    serverSnippet: ""
    httpSnippet: ""
    httpDirectives: {}
    locations:
      /api/auth/authenticate:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-endpoints" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-endpoints" "port" }}
          proxyPassSnippet: |
            proxy_pass_request_body off;
        locationSnippet: |
          proxy_set_header Content-Length "";
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Original-URI $request_uri;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}
{{- end }}

{{- define "internal-gateway.nginx-config" }}
{{- $configDefaults := include "internal-gateway.nginx-config-defaults" . | fromYaml}}
{{- $mergedConfig := deepCopy $configDefaults }}
  {{- if .Values.nginx }}
    {{- $mergedConfig = mergeOverwrite $configDefaults .Values }}
  {{- end }}
{{ $mergedConfig | toYaml }}
{{- end }}