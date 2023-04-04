{{/*
Return  the proper Storage Class
{{ include "cf-common-0.2.0.storageclass" ( dict "persistence" .Values.path.to.the.persistence.item "global" $) }}
*/}}
{{- define "cf-common-0.2.0.storageclass" -}}

{{- $storageClass := .persistence.storageClass -}}
{{- if .global -}}
    {{- if .global.storageClass -}}
        {{- $storageClass = .global.storageClass -}}
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
