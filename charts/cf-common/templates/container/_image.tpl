{{/*
Prints full image name
Usage:
{{ include "cf-common.image.name" (dict "image" .Values.container.image "context" $) }}
*/}}
{{- define "cf-common.image.name" -}}

{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- $registryName := .image.registry -}}
{{- $repositoryName := .image.repository -}}
{{- $imageTag := .image.tag | toString -}}

{{- if $.Values.global -}}
  {{- if $.Values.global.imageRegistry -}}
    {{ $registryName = $.Values.global.imageRegistry }}
  {{- end -}}
{{- end -}}

{{- printf "%s/%s:%s" $registryName $repositoryName $imageTag -}}

{{- end -}}


{{/*
Prints full image name
Usage:
{{ include "cf-common.image.pullSecrets" . }}
*/}}
{{- define "cf-common.image.pullSecrets" -}}
  {{- $pullSecrets := list }}

  {{- if .Values.global.imagePullSecrets }}
    {{- if not (kindIs "slice" .Values.global.imagePullSecrets) -}}
    {{- fail "ERROR: imagePullSecrets block must be a list!" -}}
    {{- end -}}

    {{- range .Values.global.imagePullSecrets -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}

  {{- if .Values.imagePullSecrets }}
    {{- if not (kindIs "slice" .Values.imagePullSecrets) -}}
    {{- fail "ERROR: imagePullSecrets block must be a list!" -}}
    {{- end -}}

    {{- range .Values.imagePullSecrets -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}

  {{- if (not (empty $pullSecrets)) }}
imagePullSecrets:
    {{- range $pullSecrets }}
  - name: {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}
