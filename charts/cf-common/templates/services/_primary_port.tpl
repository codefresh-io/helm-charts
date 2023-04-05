{{/*
Return the primary port for a given Service object.
Usage:
{{ include "cf-common-0.5.0.service.primaryPort" (dict "values" .Values.service.main.ports ) }}
*/}}
{{- define "cf-common-0.5.0.service.primaryPort" -}}
  {{- $result := "" -}}
  {{- range $name, $port := .values -}}
    {{- if and (hasKey $port "primary") $port.primary -}}
      {{- $result = $name -}}
    {{- end -}}
  {{- end -}}

  {{- if not $result -}}
    {{- $result = keys .values | first -}}
  {{- end -}}
  {{- $result -}}
{{- end -}}
