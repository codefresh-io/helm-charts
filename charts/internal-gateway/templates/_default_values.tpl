{{- define "internal-gateway.default-values" }}
codefresh:
  serviceEndpoints:
    cfapi-endpoints:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-endpoints-svc" }}'
      port: {{ index .Values.codefresh "cfapi-endpoints-port" }}
    cfapi-environments:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-environments-svc" }}'
      port: {{ index .Values.codefresh "cfapi-environments-port" }}
    cfapi-downloadlogmanager:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-downloadlogmanager-svc" }}'
      port: {{ index .Values.codefresh "cfapi-downloadlogmanager-port" }}
    cfapi-gitops-resource-receiver:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-gitops-resource-receiver-svc" }}'
      port: {{ index .Values.codefresh "cfapi-gitops-resource-receiver-port" }}
    cfapi-test-reporting:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-test-reporting-svc" }}'
      port: {{ index .Values.codefresh "cfapi-test-reporting-port" }}
    cfapi-kubernetesresourcemonitor:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-kubernetesresourcemonitor-svc" }}'
      port: {{ index .Values.codefresh "cfapi-kubernetesresourcemonitor-port" }}
    cfapi-kubernetes-endpoints:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-kubernetes-endpoints-svc" }}'
      port: {{ index .Values.codefresh "cfapi-kubernetes-endpoints-port" }}
    cfapi-admin:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-admin-svc" }}'
      port: {{ index .Values.codefresh "cfapi-admin-port" }}
    cfapi-teams:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-teams-svc" }}'
      port: {{ index .Values.codefresh "cfapi-teams-port" }}
    cfapi-ws:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfapi-ws-svc" }}'
      port: {{ index .Values.codefresh "cfapi-ws-port" }}
    cfui:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "cfui-svc" }}'
      port: {{ index .Values.codefresh "cfui-port" }}
    argo-platform-api-graphql:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "argo-platform-api-graphql-svc" }}'
      port: {{ index .Values.codefresh "argo-platform-api-graphql-port" }}
    argo-platform-api-events:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "argo-platform-api-events-svc" }}'
      port: {{ index .Values.codefresh "argo-platform-api-events-port" }}
    argo-platform-ui:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "argo-platform-ui-svc" }}'
      port: {{ index .Values.codefresh "argo-platform-ui-port" }}
    argo-hub:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "argo-hub-svc" }}'
      port: {{ index .Values.codefresh "argo-hub-port" }}
    nomios:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "nomios-svc" }}'
      port: {{ index .Values.codefresh "nomios-port" }}
    jira-addon:
      svc: '{{ .Release.Name }}-{{ index .Values.codefresh "jira-addon-svc" }}'
      port: {{ index .Values.codefresh "jira-addon-port" }}
{{- end }}
