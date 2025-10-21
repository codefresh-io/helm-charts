{{- define "internal-gateway.location-presets" }}
authHeaderSetOtel: |
  auth_request /api/auth/otel;
authHeaderSet: |
  auth_request /api/auth/authenticate;
  auth_request_set $auth_entity $upstream_http_x_cf_auth_entity;
  proxy_set_header X-CF-Auth-Entity $auth_entity;
locationSnippet: |
  proxy_http_version 1.1;
{{- if not .Values.signadot }}
  proxy_set_header Host $host;
{{- end }}
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection $connection_upgrade;
  proxy_set_header X-Request-ID $request_id;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Original-URI $request_uri;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto $scheme;
  proxy_redirect off;
locationDirectives:
  proxy_buffer_size: "128k"
  proxy_buffers: "4 128k"
  client_max_body_size: "10M"
  client_body_buffer_size: "32k"
  proxy_connect_timeout: "5s"
  proxy_send_timeout: "60s"
  proxy_read_timeout: "60s"
{{- end }}

{{- define "internal-gateway.nginx-config-defaults" }}
  {{- $endpoints := .Values.codefresh }}
  {{- $presets := include "internal-gateway.location-presets" . | fromYaml }}
  {{- $_  := set $presets "locationDirectives" (mergeOverwrite $presets.locationDirectives .Values.nginx.config.locationDirectives) }}
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
    serverDirectives: {}
    httpSnippet: ""
    httpDirectives: {}
    locations:

      /api/auth/authenticate:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-auth" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-auth" "port" }}
          proxyPassSnippet: |
            proxy_pass_request_body off;
        locationSnippet: |
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "";
          proxy_set_header Content-Length "";
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Original-URI $request_uri;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/auth/otel:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-auth" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-auth" "port" }}
          proxyPassSnippet: |
            proxy_pass_request_body off;
        locationSnippet: |
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "";
          proxy_set_header Content-Length "";
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Original-URI $request_uri;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/auth/:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-auth" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-auth" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-endpoints" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-endpoints" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      = /api:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-endpoints" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-endpoints" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/environments-v2/argo/events:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-environments" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-environments" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/public/progress/download:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-downloadlogmanager" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-downloadlogmanager" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/gitops/resources:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-gitops-resource-receiver" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-gitops-resource-receiver" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/gitops/rollout:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-gitops-resource-receiver" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-gitops-resource-receiver" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/testReporting:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-test-reporting" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-test-reporting" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/k8s-monitor/:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-kubernetesresourcemonitor" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-kubernetesresourcemonitor" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/kubernetes:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-kubernetes-endpoints" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-kubernetes-endpoints" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/admin/:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-admin" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-admin" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/team:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-teams" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-teams" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /ws/:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfapi-ws" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfapi-ws" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "cfui" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "cfui" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /2.0/api/broadcaster/graphql:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "argo-platform-broadcaster" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "argo-platform-broadcaster" "port" }}
          proxyPassSnippet:
            {{- $presets.authHeaderSet | toYaml | nindent 12 }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/otel/collector/traces:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "otel-collector-traces" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "otel-collector-traces" "port" }}
          proxyPassSnippet:
            {{- $presets.authHeaderSetOtel | toYaml | nindent 12 }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}
      
      /api/otel/collector/metrics:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "otel-collector-metrics" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "otel-collector-metrics" "port" }}
          proxyPassSnippet:
            {{- $presets.authHeaderSetOtel | toYaml | nindent 12 }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /api/otel/collector/logs:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "otel-collector-logs" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "otel-collector-logs" "port" }}
          proxyPassSnippet:
            {{- $presets.authHeaderSetOtel | toYaml | nindent 12 }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /2.0/api/graphql:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "argo-platform-api-graphql" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "argo-platform-api-graphql" "port" }}
          proxyPassSnippet:
            {{- $presets.authHeaderSet | toYaml | nindent 12 }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /2.0/api/events:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "argo-platform-api-events" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "argo-platform-api-events" "port" }}
          proxyPassSnippet:
            {{- $presets.authHeaderSet | toYaml | nindent 12 }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /2.0/api/promotion-orchestrator:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "argo-platform-promotion-orchestrator" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "argo-platform-promotion-orchestrator" "port" }}
          proxyPassSnippet:
            {{- $presets.authHeaderSet | toYaml | nindent 12 }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /2.0:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "argo-platform-ui" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "argo-platform-ui" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /argo/hub/:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "argo-hub" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "argo-hub" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /nomios/:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "nomios" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "nomios" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

      /atlassian/:
        enabled: true
        proxy:
          host: {{ index $endpoints.serviceEndpoints "jira-addon" "svc" }}
          port: {{ index $endpoints.serviceEndpoints "jira-addon" "port" }}
        locationSnippet:
          {{- $presets.locationSnippet | toYaml | nindent 10 }}
        locationDirectives:
          {{- $presets.locationDirectives | toYaml | nindent 10 }}

{{- end }}

{{- define "internal-gateway.nginx-config" }}
{{- $configDefaults := include "internal-gateway.nginx-config-defaults" . | fromYaml }}
{{- $mergedConfig := deepCopy $configDefaults }}
  {{- if .Values.nginx }}
    {{- $mergedConfig = mergeOverwrite $configDefaults .Values }}
  {{- end }}
{{ $mergedConfig | toYaml }}
{{- end }}
