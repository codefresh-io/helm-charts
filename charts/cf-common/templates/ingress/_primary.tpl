{{/*
Return the name of the primary ingress object.
Called from ingress template.
Usage:
{{ include "cf-common-0.28.0.ingress.primary" (dict "values" .Values.ingress ) }}
*/}}
{{- define "cf-common-0.28.0.ingress.primary" -}}
  {{- $result := "" -}}
  {{- range $name, $ingress := .values -}}
    {{- if and (hasKey $ingress "primary") $ingress.primary $ingress.enabled -}}
      {{- $result = $name -}}
    {{- end -}}
  {{- end -}}

  {{- if not $result -}}
    {{- $result = keys .values | first -}}
  {{- end -}}
  {{- $result -}}
{{- end -}}
