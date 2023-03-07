{{/*
Renders volumes in controller template

Usage:
volumes:
{{ include "cf-common.volumes" (dict "Values" .Values.volumes "context" $) }}
{{ include "cf-common.volumes" (dict "Values" .Values.existingVolumes "context" $) }}
*/}}

{{- define "cf-common.volumes" }}

{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- range $volumeIndex, $volumeItem := .Values }}

{{- if $volumeItem.enabled }}
- name: {{ $volumeIndex }}
  {{- if or (eq $volumeItem.type "configMap") (eq $volumeItem.type "secret") }}

  {{- $volumeName := printf "%s-%s" (include "cf-common.names.fullname" $) $volumeIndex -}}

  {{- if and (hasKey $volumeItem "existingName") $volumeItem.existingName  }}
  {{- $volumeName = include "cf-common.tplrender" (dict "Values" $volumeItem.existingName "context" $) -}}
  {{- end }}

  {{- if eq $volumeItem.type "configMap" }}
  configMap:
    name: {{ $volumeName }}
  {{- with $volumeItem.optional }}
    optional: {{ . }}
  {{- end }}
  {{- end }}

  {{- if eq $volumeItem.type "secret" }}
  secret:
    secretName: {{ $volumeName }}
  {{- with $volumeItem.optional }}
    optional: {{ . }}
  {{- end }}
  {{- with $volumeItem.defaultMode }}
    defaultMode: {{ . }}
  {{- end }}
  {{- with $volumeItem.items }}
    items: {{ toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}

  {{- else }}
    {{ fail (printf "ERROR: %s is invalid volume type for volume %s!" $volumeItem.type $volumeIndex) }}
  {{- end }}
{{- end }}

{{- end }}

{{- end }}



{{/*
Merges two lists: `.Values.extraVolumes[]` with `.Values.global.extraVolumes[]`
Sets resulting list to `.Values.extraVolumes`
Usage in templates:
volumes:
{{- if .Values.extraVolumes }}
  {{- include "appendExtraVolumes" . }}
  {{- include "cf-common.tplrender" ( dict "Values" .Values.extraVolumes "context" $) | nindent 8 }}
{{- end }}
*/}}

{{- define "cf-common.appendExtraVolumes" -}}

{{- $mergedExtraVolumes := list -}}

{{- if .Values.extraVolumes -}}
  {{- range .Values.extraVolumes -}}
    {{- $mergedExtraVolumes = append $mergedExtraVolumes . | uniq -}}
  {{- end -}}
{{- end -}}

{{- if .Values.global.extraVolumes -}}
  {{- range .Values.global.extraVolumes -}}
    {{- $mergedExtraVolumes = append $mergedExtraVolumes . | uniq -}}
  {{- end -}}
{{- end -}}

{{- if (not (empty $mergedExtraVolumes)) -}}
  {{- $_ := set .Values "extraVolumes" $mergedExtraVolumes -}}
{{- end -}}

{{- end -}}
