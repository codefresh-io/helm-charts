{{- define "internal-gateway.rbac" -}}

{{ $templateName := printf "cf-common-%s.rbac" (index .Subcharts "cf-common").Chart.Version }}
{{- include $templateName . }}

{{- end -}}
