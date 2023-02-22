{{/*
Renders rollout template
Usage:
{{ include "cf-common.controller.rollout" . | nindent 0 }}
*/}}
{{- define "cf-common.controller.rollout" -}}

{{- $strategy := default .Values.global.rollout.strategy .Values.controller.rollout.strategy -}}

{{- if and (ne $strategy "Canary") (ne $strategy "BlueGreen") -}}
  {{- fail (printf "ERROR: %s is invalid Rollout strategy!" $strategy) -}}
{{- end -}}

---
apiVersion: argoproj.io/v1alpha1
kind: Rollout
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
    {{- with .Values.controller.rollout }}
  analysis: {{ include "cf-common.tplrender" (dict "Values" .analysis "context" $) | nindent 4 }}
    {{- end }}
  strategy:
    {{- with .Values.controller.rollout.canary }}
      {{- if eq $strategy "Canary" }}
    canary: 
      maxUnavailable: {{ default $.Values.global.rollout.canary.maxUnavailable .maxUnavailable }}
      maxSurge: {{ default $.Values.global.rollout.canary.maxSurge .maxSurge }}
      steps: {{ include "cf-common.tplrender" (dict "Values" .steps "context" $) | indent 6 }}
      {{- end }}
    {{- end }}
  template:
    metadata:
      labels: {{ include "cf-common.labels.matchLabels" . | nindent 8 }}
      {{- if .Values.podLabels }}
      {{- include "cf-common.tplrender" (dict "Values" .Values.podLabels "context" $) | nindent 8 }}
      {{- end }}
      {{- if .Values.podAnnotations }}
      annotations:
      {{- include "cf-common.tplrender" (dict "Values" .Values.podAnnotations "context" $) | nindent 8 }}
      {{- end }}
    spec: {{- include "cf-common.controller.pod" . | trim | nindent 6 -}}
{{- end -}}
