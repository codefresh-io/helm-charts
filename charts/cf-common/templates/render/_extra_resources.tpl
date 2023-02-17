{{/*
Renders Extra objects defined at .Values.extraResources
Usage:
{{- include "cf-common.extraResources" . -}}
*/}}

{{- define "cf-common.extraResources" -}}

{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- range .Values.extraResources }}
{{ include "cf-common.tplrender" (dict "Values" . "context" $) }}
{{- end }}

{{- end -}}