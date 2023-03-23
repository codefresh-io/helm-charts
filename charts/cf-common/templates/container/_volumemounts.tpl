{{/*
Renders volumeMounts list in container
Usage:
  {{- with .Values.volumeMounts }}
  volumeMounts:
  {{- include "cf-common-0.1.0.volumeMounts" (dict "Values" . "context" $) | trim | nindent 2 }}
  {{- end }}
*/}}

{{- define "cf-common-0.1.0.volumeMounts" -}}
{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- $defaultVolumeMounts := dict -}}
{{- $globalVolumeMounts := dict -}}

{{- if .Values -}}
  {{- $defaultVolumeMounts = deepCopy .Values -}}
{{- end -}}
{{- if $.Values.global -}}
  {{- if $.Values.global.container -}}
    {{- if $.Values.global.container.volumeMounts -}}
      {{- $globalVolumeMounts = deepCopy $.Values.global.container.volumeMounts -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- $mergedVolumeMounts := mergeOverwrite $globalVolumeMounts $defaultVolumeMounts -}}

{{- range $mountIndex, $mountItem := $mergedVolumeMounts }}

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
