{{/*
Kubernetes standard labels
*/}}
{{- define "cf-common.labels.standard" -}}
app.kubernetes.io/name: {{ include "cf-common.names.name" . }}
helm.sh/chart: {{ include "cf-common.names.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "cf-common.labels.matchLabels" -}}
app.kubernetes.io/name: {{ include "cf-common.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


{{/*
Extra labels
Usage:
{{ include "cf-common.labels.extraLabels" ( dict "Values" .Values.path.to.the.labels "context" $) }}
*/}}
{{- define "cf-common.labels.extraLabels" -}}
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
{{ include "cf-common.annotations" ( dict "Values" .Values.path.to.the.annotations "context" $) }}
*/}}
{{- define "cf-common.annotations" -}}
  {{- if not (kindIs "map" .Values) -}}
  {{- fail "ERROR: annotations block must be a map" -}}
  {{- end -}}
  {{- with .Values -}}
    {{- toYaml . -}}
  {{- end -}}
{{- end -}}