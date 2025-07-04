{{/*
Return  the proper Storage Class.
Called from pvc template. Root $ context must be passed.
{{ include "cf-common-0.28.0.storageclass" ( dict "persistence" .Values.persistence.data "context" $) }}
*/}}
{{- define "cf-common-0.28.0.storageclass" -}}

{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- $storageClass := .persistence.storageClass -}}
{{- if $.Values.global -}}
    {{- if $.Values.global.storageClass -}}
        {{- $storageClass = $.Values.global.storageClass -}}
    {{- end -}}
{{- end -}}

{{- if $storageClass -}}
  {{- if (eq "-" $storageClass) -}}
      {{- printf "storageClassName: \"\"" -}}
  {{- else }}
      {{- printf "storageClassName: %s" $storageClass -}}
  {{- end -}}
{{- end -}}

{{- end -}}
