{{- define "ngrok-agent.configmap" }}

{{- $templateName := printf "cf-common-%s.configmaps" (index .Subcharts "cf-common").Chart.Version -}}
{{- include $templateName . -}}

{{- end }}
