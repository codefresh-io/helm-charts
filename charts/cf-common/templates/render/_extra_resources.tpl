{{/*
Renders Extra objects defined at .Values.extraResources
Usage:
{{- include "cf-common.v0.0.24.extraResources" . -}}
*/}}

{{- define "cf-common.v0.0.24.extraResources" -}}

{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- range .Values.extraResources }}
{{ include "cf-common.v0.0.24.tplrender" (dict "Values" . "context" $) }}
{{- end }}

{{- end -}}
