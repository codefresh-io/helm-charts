{{- define "internal-gateway.pdb" -}}

{{ $templateName := printf "cf-common-%s.pdb" (index .Subcharts "cf-common").Chart.Version }}
{{- include $templateName . }}

{{- end -}}
