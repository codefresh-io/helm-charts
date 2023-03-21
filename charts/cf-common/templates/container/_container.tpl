{{/*
Renders main container in pod template
Usage:
{{ include "cf-common.v0.1.0.container" (dict "Values" .Values.container "context" $) }}
*/}}
{{-  define "cf-common.v0.1.0.container" -}}

{{/* Restoring root $ context */}}
{{- $ := .context -}}

- name: {{ include "cf-common.v0.1.0.names.fullname" $ }}
  image: {{ include "cf-common.v0.1.0.image.name" (dict "image" .Values.image "context" $) }}
  imagePullPolicy: {{ .Values.image.pullPolicy | default "Always" }}

  {{- with .Values.command }}
    {{- if not (kindIs "slice" .) }}
      {{- fail "ERROR: container.command block must be a list!" }}
    {{- end }}
  command: {{- include "cf-common.v0.1.0.tplrender" (dict "Values" . "context" $) | nindent 2 }}
  {{- end }}

  {{- with .Values.args }}
    {{- if not (kindIs "slice" .) }}
      {{- fail "ERROR: container.args block must be a list!" }}
    {{- end }}
  args: {{ toYaml . | nindent 2 }}
  {{- end }}

  {{- with .Values.containerSecurityContext }}
    {{- if not (kindIs "map" .) }}
      {{- fail "ERROR: container.containerSecurityContext block must be a map!" }}
    {{- end }}
  securityContext: {{ toYaml . | nindent 4 }}
  {{- end }}

  {{- with .Values.lifecycle }}
    {{- if not (kindIs "map" .) }}
      {{- fail "ERROR: container.lifecycle block must be a map!" }}
    {{- end }}
  lifecycle: {{ toYaml . | nindent 4 }}
  {{- end }}

  {{- if or .Values.envFrom $.Values.secrets }}
  envFrom:
    {{- with .Values.envFrom }}
      {{- if not (kindIs "slice" .) }}
        {{ fail "ERROR: container.envFrom block must be a list!"}}
      {{- end }}
      {{- include "cf-common.v0.1.0.tplrender" (dict "Values" . "context" $) | trim | nindent 4 }}
    {{- end }}
    {{- range $secretName, $_ := $.Values.secrets }}
    - secretRef:
        name: {{ printf "%s-%s" (include "cf-common.v0.1.0.names.fullname" $) $secretName }}
    {{- end }}
  {{- end }}

  {{- if or (.Values.env) ($.Values.global.env) }}
    {{- $mergedEnv := .Values.env }}
{{- /*
For backward compatibility (.Values.env takes precedence over .Values.container.env)
*/}}
    {{- if $.Values.env }}
  {{- $mergedEnv = mergeOverwrite $mergedEnv $.Values.env }}
    {{- end }}
    {{- if $.Values.global.env }}
  {{- $mergedEnv = merge $mergedEnv $.Values.global.env }}
    {{- end }}
  env:
  {{- include "cf-common.v0.1.0.env-vars" (dict "Values" $mergedEnv "context" $) | trim | nindent 2 }}
  {{- end }}

  ports: {{- include "cf-common.v0.1.0.ports" $ | trim | nindent 2 }}

  {{- with .Values.volumeMounts }}
  volumeMounts:
  {{- include "cf-common.v0.1.0.volumeMounts" (dict "Values" . "context" $) | trim | nindent 2 }}
  {{- end }}

  {{- with .Values.probes }}
  {{- include "cf-common.v0.1.0.probes" . | trim | nindent 2 }}
  {{- end }}

  {{- with .Values.resources }}
    {{- if not (kindIs "map" .) }}
      {{- fail "ERROR: container.resources block must be a map!" }}
    {{- end }}
    {{- if $.Values.resources }}
  resources: {{ toYaml $.Values.resources | nindent 4 }}
    {{- else }}
  resources: {{ toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}

{{- end -}}
