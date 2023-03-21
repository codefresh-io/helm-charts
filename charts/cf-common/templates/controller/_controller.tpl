{{/*
Renders contoller object
Usage:
{{- include "cf-common.v0.0.24.controller" . -}}
*/}}

{{- define "cf-common.v0.0.24.controller" -}}

{{- if .Values.controller.enabled -}}

  {{- $defaultControllerValues := deepCopy .Values.controller -}}
  {{- $globalControllerValues := dict -}}
  {{- if .Values.global -}}
    {{- if .Values.global.controller -}}
      {{- $globalControllerValues = deepCopy .Values.global.controller -}}
    {{- end -}}
  {{- end -}}
  {{- $mergedControllerValues := mergeOverwrite $globalControllerValues $defaultControllerValues -}}
  {{- $_ := set .Values "controller" (deepCopy $mergedControllerValues) -}}

  {{- if eq .Values.controller.type "rollout" }}
    {{ include "cf-common.v0.0.24.controller.rollout" . | nindent 0 }}
    {{- if .Values.controller.rollout.analysisTemplate.enabled }}
    {{ include "cf-common.v0.0.24.controller.analysis-template" . | nindent 0 }}
    {{- end }}
  {{- else if eq .Values.controller.type "deployment" }}
    {{ include "cf-common.v0.0.24.controller.deployment" . | nindent 0 }}
  {{- else if eq .Values.controller.type "job" }}
    {{ include "cf-common.v0.0.24.controller.job" . | nindent 0 }}
  {{- else }}
    {{ fail (printf "ERROR: %s is invalid controller type!" .Values.controller.type) }}
  {{- end }}
{{- end -}}

{{- end -}}
