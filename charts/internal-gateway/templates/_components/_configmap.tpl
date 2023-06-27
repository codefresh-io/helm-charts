{{- define "internal-gateway.configmap" -}}

{{- $vals := include "internal-gateway.default-values" . | fromYaml }}
{{- $mergedValues := mergeOverwrite $vals .Values }}
{{- $_ := set . "Values" $mergedValues }}

{{- $nginxConfig := index (include "internal-gateway.nginx-config" . | fromYaml) "nginx" "config" }}
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: {{ include "internal-gateway.fullname" . }}-config
  labels:
    {{- include "internal-gateway.labels" . | nindent 4 }}
data:
  nginx.conf: |
    worker_processes {{ $nginxConfig.workerProcesses }};
    error_log  /dev/stderr {{ $nginxConfig.errorLogLevel }};
    pid        /tmp/nginx.pid;
    worker_rlimit_nofile {{ $nginxConfig.workerRlimitNofile }};

    events {
      worker_connections  {{ $nginxConfig.workerConnections }};
    }

    http {
      client_body_temp_path /tmp/client_temp;
      proxy_temp_path       /tmp/proxy_temp_path;
      fastcgi_temp_path     /tmp/fastcgi_temp;
      uwsgi_temp_path       /tmp/uwsgi_temp;
      scgi_temp_path        /tmp/scgi_temp;

      variables_hash_max_size 2048;
      variables_hash_bucket_size 64;

      default_type application/octet-stream;
      log_format   {{ $nginxConfig.logFormat }}

      {{- if $nginxConfig.verboseLogging }}
      access_log   /dev/stderr  main;
      {{- else }}

      map $status $loggable {
        ~^[23]  0;
        default 1;
      }
      access_log   {{ $nginxConfig.accessLogEnabled | ternary "/dev/stderr  main  if=$loggable;" "off;" }}
      {{- end }}
      sendfile     on;
      tcp_nopush   on;

      map $http_upgrade $connection_upgrade {
          default upgrade;
          ''      close;
      }

      {{- if $nginxConfig.resolver }}
      resolver {{ $nginxConfig.resolver }};
      {{- else }}
      resolver {{ .Values.global.dnsService }}.{{ .Values.global.dnsNamespace }}.svc.{{ .Values.global.clusterDomain }};
      {{- end }}

      {{- with $nginxConfig.httpSnippet }}
      {{ . | nindent 6 }}
      {{- end }}

      {{- range $key, $val := $nginxConfig.httpDirectives }}
      {{ printf "%s %s;" $key $val }}
      {{- end }}

      server {
        listen 8080;

        {{- range $key, $val := $nginxConfig.locations }}
          {{- if $val.enabled }}
        location {{ $key }} {

          set $location_host {{ $val.proxy.host }};
          set $location_port {{ $val.proxy.port }};

          {{- $locationSnippet := "" }}
          {{- if hasKey $val "locationSnippet" }}
            {{- $locationSnippet = $val.locationSnippet }}
          {{- else if hasKey $nginxConfig "locationSnippet"}}
            {{- $locationSnippet = $nginxConfig.locationSnippet }}
          {{- end }}

          {{- if $locationSnippet }}
          {{ print $val.locationSnippet | nindent 10 }}
          {{- end }}

          {{- $locationDirectives := dict }}
          {{- if hasKey $val "locationDirectives" }}
            {{- $locationDirectives = $val.locationDirectives }}
          {{- else if hasKey $nginxConfig "locationDirectives"}}
            {{- $locationDirectives = $nginxConfig.locationDirectives }}
          {{- end }}

          {{- range $key, $val := $locationDirectives }}
          {{ printf "%s %s;" $key $val }}
          {{- end }}

          proxy_pass http://$location_host:$location_port;
          {{- if hasKey $val.proxy "proxyPassSnippet" }}
          {{- print $val.proxy.proxyPassSnippet | nindent 10 }}
          {{- end }}
        }
          {{- end }}
        {{- end }}
      }
    }
{{- end }}
