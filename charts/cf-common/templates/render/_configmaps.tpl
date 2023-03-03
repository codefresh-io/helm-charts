{{/*
Renders ConfigMaps templates
{{- include "cf-common.configmaps" . -}}
*/}}

{{- define "cf-common.configmaps" -}}

{{- range $configMapIndex, $configMapItem := .Values.configMaps }}

{{- if $configMapItem.enabled }}
{{ $configMapName := printf "%s-%s" (include "cf-common.names.fullname" $) $configMapIndex }}
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: {{ $configMapName }}
  labels: {{ include "cf-common.labels.standard" $ | nindent 4 }}
  {{- if $configMapItem.labels }}
  {{- include "cf-common.tplrender" (dict "Values" $configMapItem.labels "context" $) | nindent 4 }}
  {{- end }}
  {{- if $configMapItem.annotations }}
  annotations: {{- include "cf-common.tplrender" (dict "Values" $configMapItem.annotations "context" $) | nindent 4 }}
  {{- end }}
  {{- if not ( or (kindIs "map" $configMapItem.data) (kindIs "string" $configMapItem.data)) }}
    {{- fail (printf "ERROR: configMaps.%s.data must be a map or multiline string!" $configMapIndex) }}
  {{- end }}
data: {{ toYaml $configMapItem.data | nindent 2 }}
{{- end }}

{{- end }}

{{- end -}}
