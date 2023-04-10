{{- define "internal-gateway.deployment" -}}

{{ $templateName := printf "cf-common-%s.controller" (index .Subcharts "cf-common").Chart.Version }}
{{- include $templateName . }}

{{- end -}}
