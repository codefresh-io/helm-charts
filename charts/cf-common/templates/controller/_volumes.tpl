{{/*
Renders volumes in controller template
Usage:
  {{- with .Values.volumes }}
  volumes:
  {{ include "cf-common-0.1.2.volumes" (dict "Values" . "context" $) | trim }}
  {{- end }}
*/}}

{{- define "cf-common-0.1.2.volumes" -}}
{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- $defaultVolumes := dict -}}
{{- $globalVolumes := dict -}}

{{- if .Values -}}
  {{- $defaultVolumes = deepCopy .Values -}}
{{- end -}}
{{- if $.Values.global -}}
  {{- if $.Values.global.volumes -}}
    {{- $globalVolumes = deepCopy $.Values.global.volumes -}}
  {{- end -}}
{{- end -}}
{{- $mergedVolumes := mergeOverwrite $globalVolumes $defaultVolumes -}}

{{- range $volumeIndex, $volumeItem := $mergedVolumes }}

{{- if $volumeItem.enabled }}
- name: {{ $volumeIndex }}
  {{- if or (eq $volumeItem.type "configMap") (eq $volumeItem.type "secret") }}

  {{- $volumeName := printf "%s-%s" (include "cf-common-0.1.2.names.fullname" $) $volumeIndex -}}

  {{- if and (hasKey $volumeItem "existingName") $volumeItem.existingName  }}
  {{- $volumeName = include "cf-common-0.1.2.tplrender" (dict "Values" $volumeItem.existingName "context" $) -}}
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

  {{- if eq $volumeItem.type "pvc" }}
  persistentVolumeClaim:
    claimName: {{ $volumeName }}
  {{- end }}

  {{- else }}
    {{ fail (printf "ERROR: %s is invalid volume type for volume %s!" $volumeItem.type $volumeIndex) }}
  {{- end }}
{{- end }}

{{- end }}

{{- end -}}
