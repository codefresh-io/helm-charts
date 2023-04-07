{{/*
Renders a value that contains template.
Usage:
{{ include "cf-common-0.5.2.tplrender" ( dict "Values" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "cf-common-0.5.2.tplrender" -}}
  {{- $tpl := .Values -}}
  {{- if not (typeIs "string" $tpl) -}}
    {{- $tpl = toYaml $tpl -}}
  {{- end -}}
  {{- if contains "{{" $tpl -}}
    {{- tpl $tpl .context }}
  {{- else -}}
    {{- $tpl -}}
  {{- end -}}
{{- end -}}
