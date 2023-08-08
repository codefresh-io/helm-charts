{{/*
Kubernetes standard labels
*/}}
{{- define "cf-common-0.12.3.labels.standard" -}}
app.kubernetes.io/name: {{ include "cf-common-0.12.3.names.name" . }}
helm.sh/chart: {{ include "cf-common-0.12.3.names.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "cf-common-0.12.3.labels.matchLabels" -}}
app.kubernetes.io/name: {{ include "cf-common-0.12.3.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


{{/*
Extra labels
Usage:
{{ include "cf-common-0.12.3.labels.extraLabels" ( dict "Values" .Values.path.to.the.labels "context" $) }}
*/}}
{{- define "cf-common-0.12.3.labels.extraLabels" -}}
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
{{ include "cf-common-0.12.3.annotations" ( dict "Values" .Values.path.to.the.annotations "context" $) }}
*/}}
{{- define "cf-common-0.12.3.annotations" -}}
  {{- if not (kindIs "map" .Values) -}}
  {{- fail "ERROR: annotations block must be a map" -}}
  {{- end -}}
  {{- with .Values -}}
    {{- toYaml . -}}
  {{- end -}}
{{- end -}}
