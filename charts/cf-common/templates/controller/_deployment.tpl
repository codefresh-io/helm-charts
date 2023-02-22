{{/*
Renders deployment template
Usage:
{{ include "cf-common.controller.deployment" . | nindent 0 }}
*/}}

{{- define "cf-common.controller.deployment" -}}

{{- $strategy := default "RollingUpdate" .Values.controller.deployment.strategy -}}

{{- if and (ne $strategy "RollingUpdate") (ne $strategy "Recreate") -}}
  {{- fail (printf "ERROR: %s is invalid Deployment strategy!" $strategy) -}}
{{- end -}}

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "cf-common.names.fullname" . }}
  labels: {{ include "cf-common.labels.standard" . | nindent 4 }}
  {{- if .Values.controller.labels }}
  {{- include "cf-common.tplrender" (dict "Values" .Values.controller.labels "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.controller.annotations }}
  annotations:
  {{- include "cf-common.tplrender" (dict "Values" .Values.controller.annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  revisionHistoryLimit: {{ .Values.controller.revisionHistoryLimit | int | default 5 }}
  {{- if (ne .Values.hpa.enabled true) }}
  replicas: {{ coalesce .Values.controller.replicas .Values.replicaCount | int | default 1 }}
  {{- end }}
  selector:
    matchLabels: {{ include "cf-common.labels.matchLabels" . | nindent 6 }}
  strategy:
    type: {{ $strategy }}
    {{- with .Values.controller.deployment.rollingUpdate }}
      {{- if eq $strategy "RollingUpdate" }}
    rollingUpdate:
        {{- with .maxUnavailable }}
      maxUnavailable: {{ . }}
        {{- end }}
        {{- with .maxSurge }}
      maxSurge: {{ . }}
        {{- end }}
      {{- end }}
    {{- end }}
  template:
    metadata:
      labels: {{ include "cf-common.labels.matchLabels" . | nindent 8 }}
      {{- if .Values.podLabels }}
      {{- include "cf-common.tplrender" (dict "Values" .Values.podLabels "context" $) | nindent 8 }}
      {{- end }}
      {{- with include "cf-common.annotations.podAnnotations" . }}
      annotations:
        {{- . | nindent 8}}
      {{- end }}
    spec: {{- include "cf-common.controller.pod" . | trim | nindent 6 -}}
{{- end -}}
