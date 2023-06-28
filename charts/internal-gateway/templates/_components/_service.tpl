{{- define "internal-gateway.service" -}}

{{ $templateName := printf "cf-common-%s.service" (index .Subcharts "cf-common").Chart.Version }}
{{- include $templateName . }}

{{- end -}}
