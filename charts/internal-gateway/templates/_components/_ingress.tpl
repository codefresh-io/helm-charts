{{- define "internal-gateway.ingress" -}}

{{ $templateName := printf "cf-common-%s.ingress" (index .Subcharts "cf-common").Chart.Version }}
{{- include $templateName . }}

{{- end -}}
