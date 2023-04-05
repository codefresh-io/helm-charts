{{/* Return the name of the primary(default) ingress object */}}
{{- define "cf-common-0.5.0.ingress.primary" -}}
  {{- $result := "" -}}
  {{- range $name, $ingress := .Values.ingress -}}
    {{- if and (hasKey $ingress "primary") $ingress.primary $ingress.enabled -}}
      {{- $result = $name -}}
    {{- end -}}
  {{- end -}}

  {{- if not $result -}}
    {{- $result = keys .Values.ingress | first -}}
  {{- end -}}
  {{- $result -}}
{{- end -}}
