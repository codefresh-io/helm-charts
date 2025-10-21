{{- define "internal-gateway.default-values" }}
codefresh:
  serviceEndpoints:
    cfapi-auth:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-auth-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "cfapi-auth-port" }}
    cfapi-endpoints:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-endpoints-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "cfapi-endpoints-port" }}
    cfapi-environments:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-environments-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "cfapi-environments-port" }}
    cfapi-downloadlogmanager:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-downloadlogmanager-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "cfapi-downloadlogmanager-port" }}
    cfapi-gitops-resource-receiver:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-gitops-resource-receiver-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "cfapi-gitops-resource-receiver-port" }}
    cfapi-test-reporting:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-test-reporting-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "cfapi-test-reporting-port" }}
    cfapi-kubernetesresourcemonitor:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-kubernetesresourcemonitor-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "cfapi-kubernetesresourcemonitor-port" }}
    cfapi-kubernetes-endpoints:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-kubernetes-endpoints-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "cfapi-kubernetes-endpoints-port" }}
    cfapi-admin:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-admin-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "cfapi-admin-port" }}
    cfapi-teams:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-teams-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "cfapi-teams-port" }}
    cfapi-ws:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-ws-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "cfapi-ws-port" }}
    cfui:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfui-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "cfui-port" }}
    argo-platform-api-graphql:
      svc: '{{ index .Values.codefresh "argo-platform-api-graphql-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "argo-platform-api-graphql-port" }}
    argo-platform-api-events:
      svc: '{{ index .Values.codefresh "argo-platform-api-events-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "argo-platform-api-events-port" }}
    argo-platform-ui:
      svc: '{{ index .Values.codefresh "argo-platform-ui-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "argo-platform-ui-port" }}
    argo-platform-broadcaster:
      svc: '{{ index .Values.codefresh "argo-platform-broadcaster-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "argo-platform-broadcaster-port" }}
    argo-platform-promotion-orchestrator:
      svc: '{{ index .Values.codefresh "argo-platform-promotion-orchestrator-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "argo-platform-promotion-orchestrator-port" }}
    argo-hub:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "argo-hub-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "argo-hub-port" }}
    nomios:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "nomios-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "nomios-port" }}
    jira-addon:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "jira-addon-svc" }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "jira-addon-port" }}
    otel-collector-traces:
      svc: '{{ index .Values.codefresh "otel-collector-traces-svc" }}.{{ index .Values.codefresh "otel-collector-traces-namespace" }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "otel-collector-traces-port" }}
    otel-collector-metrics:
      svc: '{{ index .Values.codefresh "otel-collector-metrics-svc" }}.{{ index .Values.codefresh "otel-collector-metrics-namespace" }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "otel-collector-metrics-port" }}
    otel-collector-logs:
      svc: '{{ index .Values.codefresh "otel-collector-logs-svc" }}.{{ index .Values.codefresh "otel-collector-logs-namespace" }}.svc.{{ .Values.global.clusterDomain }}'
      port: {{ index .Values.codefresh "otel-collector-logs-port" }}
{{- end }}
