{{/*
Renders rollout template
Usage:
{{ include "cf-common-0.1.2.controller.rollout" . | nindent 0 }}
*/}}
{{- define "cf-common-0.1.2.controller.rollout" -}}

{{- $strategy := .Values.controller.rollout.strategy -}}
{{- $fullName:= include "cf-common-0.1.2.names.fullname" . }}

{{- if and (ne $strategy "Canary") (ne $strategy "BlueGreen") -}}
  {{- fail (printf "ERROR: %s is invalid Rollout strategy!" $strategy) -}}
{{- end -}}

{{- $rolloutName := include "cf-common-0.1.2.names.fullname" . -}}
{{- if and (hasKey .Values.controller "nameOverride") .Values.controller.nameOverride -}}
  {{- $rolloutName = printf "%v-%v" $rolloutName .Values.controller.nameOverride -}}
{{- end -}}

---
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: {{ $rolloutName }}
  labels: {{ include "cf-common-0.1.2.labels.standard" . | nindent 4 }}
  {{- if .Values.controller.labels }}
  {{- include "cf-common-0.1.2.tplrender" (dict "Values" .Values.controller.labels "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.controller.annotations }}
  annotations:
  {{- include "cf-common-0.1.2.tplrender" (dict "Values" .Values.controller.annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  revisionHistoryLimit: {{ .Values.controller.revisionHistoryLimit | int | default 5 }}
  {{- if (ne .Values.hpa.enabled true) }}
  replicas: {{ coalesce .Values.controller.replicas .Values.replicaCount | int | default 1 }}
  {{- end }}
  selector:
    matchLabels: {{ include "cf-common-0.1.2.labels.matchLabels" . | nindent 6 }}
    {{- with .Values.controller.rollout }}
  analysis: {{ .analysis | toYaml | nindent 4 }}
    {{- end }}
  strategy:
    {{- if eq $strategy "Canary" }}
      {{- with .Values.controller.rollout }}
    canary:
      maxUnavailable: {{ .canary.maxUnavailable }}
      maxSurge: {{ .canary.maxSurge }}
      stableMetadata: {{ .canary.stableMetadata| toYaml | nindent 8 }}
      canaryMetadata: {{ .canary.canaryMetadata| toYaml | nindent 8 }}
      steps: {{ .canary.steps | toYaml | nindent 6 }}
      {{- if .analysisTemplate.enabled }}
      - analysis:
          templates:
            - templateName: error-rate-{{ $fullName }}
      {{- end }}
      {{- end }}
    {{- end }}
  template:
    metadata:
      labels: {{ include "cf-common-0.1.2.labels.matchLabels" . | nindent 8 }}
      {{- if .Values.podLabels }}
      {{- include "cf-common-0.1.2.tplrender" (dict "Values" .Values.podLabels "context" $) | nindent 8 }}
      {{- end }}
      {{- if .Values.podAnnotations }}
      annotations:
      {{- include "cf-common-0.1.2.tplrender" (dict "Values" .Values.podAnnotations "context" $) | nindent 8 }}
      {{- end }}
    spec: {{- include "cf-common-0.1.2.controller.pod" . | trim | nindent 6 -}}
{{- end -}}
