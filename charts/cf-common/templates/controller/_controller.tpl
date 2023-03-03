{{/*
Renders contoller object
Usage:
{{- include "cf-common.controller" . -}}
*/}}

{{- define "cf-common.controller" -}}

{{- if .Values.controller.enabled -}}

  {{ include "cf-common.controller.type" . }}

  {{- if eq .Values.controller.type "rollout" }}
    {{ include "cf-common.controller.rollout" . | nindent 0 }}
  {{- else if eq .Values.controller.type "deployment" }}
    {{ include "cf-common.controller.deployment" . | nindent 0 }}
  {{- else if eq .Values.controller.type "job" }}
    {{ include "cf-common.controller.job" . | nindent 0 }}
  {{- else }}
    {{ fail (printf "ERROR: %s is invalid controller type!" .Values.controller.type) }}
  {{- end }}
{{- end -}}

{{- end -}}


{{- /*
Define controller type. Merges .Values.controller (takes precedence) with .Values.global.controller
Usage:
{{ include "cf-common.controller.type" . }}
*/}}

{{- define "cf-common.controller.type" }}

  {{- $controllerDict := .Values.controller -}}
  {{- if .Values.global -}}
    {{- if .Values.global.controller -}}
      {{- $controllerDict = merge $controllerDict .Values.global.controller -}}
    {{- end -}}
  {{- end -}}
  {{- $_ := set .Values "controller" $controllerDict -}}

{{- end }}
