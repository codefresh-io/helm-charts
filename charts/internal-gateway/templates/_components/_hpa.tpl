{{- define "internal-gateway.hpa" -}}

{{ $templateName := printf "cf-common-%s.hpa" (index .Subcharts "cf-common").Chart.Version }}
{{- include $templateName . }}

{{- end -}}
