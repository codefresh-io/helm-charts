{{/*
Return the primary service object
Usage:
{{ include "cf-common-0.5.0.service.primary" (dict "values" .Values.service) }}
*/}}
{{- define "cf-common-0.5.0.service.primary" -}}
  {{- $result := "" -}}

  {{- range $name, $service := .values -}}
    {{- if and (hasKey $service "primary") $service.primary $service.enabled -}}
      {{- $result = $name -}}
    {{- end -}}
  {{- end -}}

  {{- if not $result -}}
    {{- $result = keys .values | first -}}
  {{- end -}}
  {{- $result -}}

{{- end -}}
