{{- define "internal-gateway.configmap" -}}
kind: ConfigMap
apiVersion: v1
metadata:
  name: {{ include "internal-gateway.fullname" . }}-config
  labels:
    {{- include "internal-gateway.labels" . | nindent 4 }}
data:
  nginx.conf: |
    worker_processes {{ .Values.nginx.config.workerProcesses }};
    error_log  /dev/stderr {{ .Values.nginx.config.errorLogLevel }};
    pid        /tmp/nginx.pid;
    worker_rlimit_nofile {{ .Values.nginx.config.workerRlimitNofile }};

    events {
      worker_connections  {{ .Values.nginx.config.workerConnections }};
    }

    http {
      client_body_temp_path /tmp/client_temp;
      proxy_temp_path       /tmp/proxy_temp_path;
      fastcgi_temp_path     /tmp/fastcgi_temp;
      uwsgi_temp_path       /tmp/uwsgi_temp;
      scgi_temp_path        /tmp/scgi_temp;

      default_type application/octet-stream;
      log_format   {{ .Values.nginx.config.logFormat }}

      {{- if .Values.nginx.config.verboseLogging }}
      access_log   /dev/stderr  main;
      {{- else }}

      map $status $loggable {
        ~^[23]  0;
        default 1;
      }
      access_log   {{ .Values.nginx.config.accessLogEnabled | ternary "/dev/stderr  main  if=$loggable;" "off;" }}
      {{- end }}
      sendfile     on;
      tcp_nopush   on;

      map $http_upgrade $connection_upgrade {
          default upgrade;
          ''      close;
      }

      {{- if .Values.nginx.config.resolver }}
      resolver {{ .Values.nginx.config.resolver }};
      {{- else }}
      resolver {{ .Values.global.dnsService }}.{{ .Values.global.dnsNamespace }}.svc.{{ .Values.global.clusterDomain }};
      {{- end }}

      {{- with .Values.nginx.config.httpSnippet }}
      {{ . | nindent 2 }}
      {{- end }}

      {{- range $key, $val := .Values.nginx.config.httpDirectives }}
      {{ printf "%s %s;" $key $val }}
      {{- end }}

      server {
        listen 8080;

        {{- range $key, $val := .Values.nginx.config.serverDirectives }}
        {{ printf "%s %s;" $key $val }}
        {{- end }}


        location = / {
          return 200 'OK';
          auth_basic off;
        }

        location = /ready {
          return 200 'OK';
          auth_basic off;
        }

        location /api/auth/authenticate {
          # Authenticate through Classic CF platform
          set $cfapi_svc {{ index .Values.codefresh "cfapi-endpoints-svc" }};
          set $cfapi_port {{ index .Values.codefresh "cfapi-endpoints-port" }};
          proxy_pass http://$cfapi_svc:$cfapi_port;
          proxy_pass_request_body off; # no need to send the POST body
          proxy_set_header Content-Length "";
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Original-URI $request_uri;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "";
        }

        location /2.0/api/events {
          # Any request to this server will first be sent to this URL
          auth_request /api/auth/authenticate;
          # Sets the HTTP header 'x-cf-auth-entity' that old platform sends, into $auth_entity variable
          auth_request_set $auth_entity $upstream_http_x_cf_auth_entity;
          set $argo_platform_api_events_svc {{ index .Values.codefresh "argo-platform-api-events-svc" }};
          set $argo_platform_api_events_port {{ index .Values.codefresh "argo-platform-api-events-port" }};
          proxy_pass  http://$argo_platform_api_events_svc:$argo_platform_api_events_port;

          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_set_header Host $host;
          proxy_set_header X-CF-Auth-Entity $auth_entity;
          proxy_cache_bypass $http_upgrade;
        }

        location /2.0/api/graphql {
          # Any request to this server will first be sent to this URL
          auth_request /api/auth/authenticate;
          # Sets the HTTP header 'x-cf-auth-entity' that old platform sends, into $auth_entity variable
          auth_request_set $auth_entity $upstream_http_x_cf_auth_entity;
          set $argo_platform_api_graphql_svc {{ index .Values.codefresh "argo-platform-api-graphql-svc" }};
          set $argo_platform_api_graphql_port {{ index .Values.codefresh "argo-platform-api-graphql-port" }};
          proxy_pass  http://$argo_platform_api_graphql_svc:$argo_platform_api_graphql_port;

          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_set_header Host $host;
          proxy_set_header X-CF-Auth-Entity $auth_entity;
          proxy_cache_bypass $http_upgrade;
        }

        location /2.0 {
          set $argo_platform_ui_svc {{ index .Values.codefresh "argo-platform-ui-svc" }};
          set $argo_platform_ui_port {{ index .Values.codefresh "argo-platform-ui-port" }};
          proxy_pass  http://$argo_platform_ui_svc:$argo_platform_ui_port;

          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_set_header Host $host;
          proxy_set_header X-CF-Auth-Entity $auth_entity;
          proxy_cache_bypass $http_upgrade;
        }

        location /api/environments-v2/argo/events {
          set $cfapi_environments_svc {{ index .Values "codefresh" "cfapi-environments-svc" }};
          set $cfapi_environments_port {{ index .Values "codefresh" "cfapi-environments-port" }};

          proxy_pass http://$cfapi_environments_svc:$cfapi_environments_port;
        }

        location /api/public/progress/download {
          set $cfapi_downloadlogmanager_svc {{ index .Values "codefresh" "cfapi-downloadlogmanager-svc" }};
          set $cfapi_downloadlogmanager_port {{ index .Values "codefresh" "cfapi-downloadlogmanager-port" }};

          proxy_pass http://$cfapi_downloadlogmanager_svc:$cfapi_downloadlogmanager_port;
        }

        location /api/progress/download {
          set $cfapi_downloadlogmanager_svc {{ index .Values "codefresh" "cfapi-downloadlogmanager-svc" }};
          set $cfapi_downloadlogmanager_port {{ index .Values "codefresh" "cfapi-downloadlogmanager-port" }};

          proxy_pass http://$cfapi_downloadlogmanager_svc:$cfapi_downloadlogmanager_port;
        }

        location /api/gitops/resources {
          set $cfapi_gitops_resource_receiver_svc {{ index .Values "codefresh" "cfapi-gitops-resource-receiver-svc" }};
          set $cfapi_gitops_resource_receiver_port {{ index .Values "codefresh" "cfapi-gitops-resource-receiver-port" }};

          proxy_pass http://$cfapi_gitops_resource_receiver_svc:$cfapi_gitops_resource_receiver_port;
        }

        location /api/gitops/rollout {
          set $cfapi_gitops_resource_receiver_svc {{ index .Values "codefresh" "cfapi-gitops-resource-receiver-svc" }};
          set $cfapi_gitops_resource_receiver_port {{ index .Values "codefresh" "cfapi-gitops-resource-receiver-port" }};

          proxy_pass http://$cfapi_gitops_resource_receiver_svc:$cfapi_gitops_resource_receiver_port;
        }

        location /api/testReporting {
          set $cfapi_test_reporting_svc {{ index .Values "codefresh" "cfapi-test-reporting-svc" }};
          set $cfapi_test_reporting_port {{ index .Values "codefresh" "cfapi-test-reporting-port" }};

          proxy_pass http://$cfapi_test_reporting_svc:$cfapi_test_reporting_port;
        }

        location /api/k8s-monitor/ {
          set $cfapi_kubernetesresourcemonitor_svc {{ index .Values "codefresh" "cfapi-kubernetesresourcemonitor-svc" }};
          set $cfapi_kubernetesresourcemonitor_port {{ index .Values "codefresh" "cfapi-kubernetesresourcemonitor-port" }};

          proxy_pass http://$cfapi_kubernetesresourcemonitor_svc:$cfapi_kubernetesresourcemonitor_port;
        }

        location /api/kubernetes {
          set $cfapi_kubernetes_endpoints_svc {{ index .Values "codefresh" "cfapi-kubernetes-endpoints-svc" }};
          set $cfapi_kubernetes_endpoints_port {{ index .Values "codefresh" "cfapi-kubernetes-endpoints-port" }};

          proxy_pass http://$cfapi_kubernetes_endpoints_svc:$cfapi_kubernetes_endpoints_port;
        }

        location /api/admin/ {
          set $cfapi_admin_svc {{ index .Values "codefresh" "cfapi-admin-svc" }};
          set $cfapi_admin_port {{ index .Values "codefresh" "cfapi-admin-port" }};

          proxy_pass http://$cfapi_admin_svc:$cfapi_admin_port;
        }

        location /api/team {
          set $cfapi_teams_svc {{ index .Values "codefresh" "cfapi-teams-svc" }};
          set $cfapi_teams_port {{ index .Values "codefresh" "cfapi-teams-port" }};

          proxy_pass http://$cfapi_teams_svc:$cfapi_teams_port;
        }

        location /api/ {
          set $cfapi_endpoints_svc {{ index .Values "codefresh" "cfapi-endpoints-svc" }};
          set $cfapi_endpoints_port {{ index .Values "codefresh" "cfapi-endpoints-port" }};

          proxy_pass http://$cfapi_endpoints_svc:$cfapi_endpoints_port;
        }

        location /ws/ {
          set $cfapi_ws_svc {{ index .Values "codefresh" "cfapi-ws-svc" }};
          set $cfapi_ws_port {{ index .Values "codefresh" "cfapi-ws-port" }};

          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;
          proxy_pass http://$cfapi_ws_svc:$cfapi_ws_port;
        }

        location /nomios/ {
          set $nomios_svc {{ index .Values "codefresh" "nomios-svc" }};
          set $nomios_port {{ index .Values "codefresh" "nomios-port" }};

          proxy_pass http://$nomios_svc:$nomios_port;
        }

        location /atlassian/ {
          set $jira_addon_svc {{ index .Values "codefresh" "jira-addon-svc" }};
          set $jira_addon_port {{ index .Values "codefresh" "jira-addon-port" }};

          proxy_pass http://$jira_addon_svc:$jira_addon_port;
        }

        location / {
          set $cfui_svc {{ index .Values "codefresh" "cfui-svc" }};
          set $cfui_port {{ index .Values "codefresh" "cfui-port" }};

          proxy_pass http://$cfui_svc:$cfui_port;
        }

        {{- with .Values.nginx.config.serverSnippet }}
        {{ . | nindent 8 }}
        {{- end }}

      }
    }
{{- end }}
