{{/*
Kubernetes standard labels
*/}}
{{- define "cf-common.v0.0.24.labels.standard" -}}
app.kubernetes.io/name: {{ include "cf-common.v0.0.24.names.name" . }}
helm.sh/chart: {{ include "cf-common.v0.0.24.names.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "cf-common.v0.0.24.labels.matchLabels" -}}
app.kubernetes.io/name: {{ include "cf-common.v0.0.24.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


{{/*
Extra labels
Usage:
{{ include "cf-common.v0.0.24.labels.extraLabels" ( dict "Values" .Values.path.to.the.labels "context" $) }}
*/}}
{{- define "cf-common.v0.0.24.labels.extraLabels" -}}
  {{- if not (kindIs "map" .Values) -}}
  {{- fail "ERROR: labels block must be a map" -}}
  {{- end -}}
  {{- with .Values -}}
    {{- toYaml . -}}
  {{- end -}}
{{- end -}}

{{/*
Annotations
Usage:
{{ include "cf-common.v0.0.24.annotations" ( dict "Values" .Values.path.to.the.annotations "context" $) }}
*/}}
{{- define "cf-common.v0.0.24.annotations" -}}
  {{- if not (kindIs "map" .Values) -}}
  {{- fail "ERROR: annotations block must be a map" -}}
  {{- end -}}
  {{- with .Values -}}
    {{- toYaml . -}}
  {{- end -}}
{{- end -}}
