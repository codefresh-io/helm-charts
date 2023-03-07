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

{{/*
Merges two lists: `.Values.extraVolumeMounts[]` with `.Values.global.extraVolumeMounts[]`
Sets resulting list to `.Values.extraVolumeMounts`
Usage in templates:
volumeMounts:
{{- if .Values.extraVolumeMounts }}
  {{- include "appendextraVolumeMounts" . }}
  {{- include "cf-common.tplrender" ( dict "Values" .Values.extraVolumeMounts "context" $) | nindent 8 }}
{{- end }}
*/}}

{{- define "cf-common.appendExtraVolumeMounts" -}}

{{- $mergedExtraVolumeMounts := list -}}

{{- if .Values.extraVolumeMounts -}}
  {{- range .Values.extraVolumeMounts -}}
    {{- $mergedExtraVolumeMounts = append $mergedExtraVolumeMounts . | uniq -}}
  {{- end -}}
{{- end -}}

{{- if .Values.global.extraVolumeMounts -}}
  {{- range .Values.global.extraVolumeMounts -}}
    {{- $mergedExtraVolumeMounts = append $mergedExtraVolumeMounts . | uniq -}}
  {{- end -}}
{{- end -}}

{{- if (not (empty $mergedExtraVolumeMounts)) -}}
  {{- $_ := set .Values "extraVolumeMounts" $mergedExtraVolumeMounts -}}
{{- end -}}

{{- end -}}
