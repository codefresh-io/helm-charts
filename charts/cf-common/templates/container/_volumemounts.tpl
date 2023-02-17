{{/*
Renders volumeMounts list in container
Usage:
  {{- with .Values.volumeMounts }}
  volumeMounts:
  {{- include "cf-common.volumeMounts" . | trim | nindent 2 }}
  {{- end }}
*/}}

{{- define "cf-common.volumeMounts" -}}

{{- range $mountIndex, $mountItem := . }}

{{- if not (kindIs "slice" $mountItem.path) }}
  {{ fail (printf "ERROR: volumeMounts.%s.path block must be a list!" $mountIndex ) }}
{{- end }}

{{- range $pathIndex, $pathItem := $mountItem.path }}
- name: {{ $mountIndex }}
  mountPath: {{ required "mountPath is required for volumeMount!" $pathItem.mountPath }}
  {{- with $pathItem.subPath }}
  subPath: {{ . }}
  {{- end }}
  {{- with $pathItem.readOnly }}
  readOnly: {{ . }}
  {{- end }}

{{- end }}

{{- end }}

{{- end -}}
