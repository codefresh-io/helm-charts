{{/*
Renders Extra objects defined at .Values.extraResources
Usage:
{{- include "cf-common.v0.0.25.extraResources" . -}}
*/}}

{{- define "cf-common.v0.0.25.extraResources" -}}

{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- range .Values.extraResources }}
{{ include "cf-common.v0.0.25.tplrender" (dict "Values" . "context" $) }}
{{- end }}

{{- end -}}
