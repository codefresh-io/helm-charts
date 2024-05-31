{{- define "cf-common-0.19.0.keda.scaled-object" }}
{{- if and (index .Values "keda" "scaled-object" "enabled") }}

{{- $controllerName := include "cf-common-0.19.0.names.fullname" . -}}
  {{- if and (hasKey .Values.controller "nameOverride") .Values.controller.nameOverride -}}
    {{- $controllerName = printf "%v-%v" $controllerName .Values.controller.nameOverride -}}
  {{- end -}}
{{- $containerName := include "cf-common-0.19.0.names.fullname" . -}}
  {{- if and (hasKey .Values.container "nameOverride") .Values.container.nameOverride }}
    {{- $containerName = include "cf-common-0.19.0.tplrender" (dict "Values" .Values.container.nameOverride "context" .) -}}
  {{- end }}

apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: {{ include "cf-common-0.19.0.names.fullname" . }}
  labels: {{ include "cf-common-0.19.0.labels.standard" . | nindent 4 }}
  annotations:
  {{- with (index .Values "keda" "scaled-object" "annotations" ) }}
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- with index .Values "keda" "scaled-object" "scaleTargetRef" }}
  scaleTargetRef: {{ toYaml . | nindent 4 }}
  {{- else }}
  scaleTargetRef:
    {{- if eq .Values.controller.type "rollout" }}
    apiVersion: argoproj.io/v1alpha1
    kind: Rollout
    {{- else if eq .Values.controller.type "deployment" }}
    apiVersion: apps/v1
    kind: Deployment
    {{- else }}
    {{- required "Controller type is required! Only rollout/deploymeny is allowed!" .Values.controller.type }}
    {{- end }}
    name: {{ $controllerName }}
    envSourceContainerName: {{ index .Values "keda" "scaled-object" "envSourceContainerName" | default $containerName }}
  {{- end }}
  pollingInterval: {{ index .Values "keda" "scaled-object" "pollingInterval" | default 30 }}
  cooldownPeriod: {{ index .Values "keda" "scaled-object" "cooldownPeriod" | default 300 }}
  {{- if (eq 0 (int (index .Values "keda" "scaled-object" "idleReplicaCount"))) }}
  idleReplicaCount: 0
  {{- else }}
  {{- fail "ERROR: Only 0 is allowed for idleReplicaCount" }}
  {{- end }}
  minReplicaCount: {{ index .Values "keda" "scaled-object" "minReplicaCount" | default 1 }}
  maxReplicaCount: {{ index .Values "keda" "scaled-object" "maxReplicaCount" | default 100 }}
  {{- with (index .Values "keda" "scaled-object" "fallback" ) }}
  fallback:
    failureThreshold: {{- required "Values.keda.scaled-object.fallback.failureThreshold is required!" .failureThreshold }}
    replicas: {{- required "Values.keda.scaled-object.fallback.replicas is required!" .replicas }}
  {{- end }}
  {{- with (index .Values "keda" "scaled-object" "advanced" ) }}
  advanced:
    restoreToOriginalReplicaCount: {{ .restoreToOriginalReplicaCount | default false }}
    horizontalPodAutoscalerConfig:
      name: {{ include "cf-common-0.19.0.names.fullname" . }}
      {{- with .horizontalPodAutoscalerConfig }}
        {{- toYaml . | nindent 6 }}
      {{- end -}}
  {{- end }}
  triggers:
  {{- range $triggerIndex, $triggerItem := (index .Values "keda" "scaled-object" "triggers" ) }}
  - type: {{ $triggerItem.type }}
    metadata: {{ $triggerItem.metadata | toYaml | nindent 6 }}
    {{- with $triggerItem.metricType }}
    metricType: {{ . }}
    {{- end }}
    {{- if and (index $.Values "keda" "trigger-authentication" "enabled") }}
    authenticationRef:
      name: {{ include "cf-common-0.19.0.names.fullname" $ }}
    {{- end }}
  {{ end }}
{{- end }}
{{- end }}

