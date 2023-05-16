{{/*
Renders ServiceAccount/Role/RoleBinding objects.
Must be called from chart root context.
Usage:
{{- include "cf-common-0.7.1.rbac" . -}}
*/}}

{{- define "cf-common-0.7.1.rbac" -}}

{{- if .Values.serviceAccount.enabled }}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ default ( include "cf-common-0.7.1.names.fullname" $) .Values.serviceAccount.nameOverride }}
  labels: {{ include "cf-common-0.7.1.labels.standard" . | nindent 4 }}
  {{- if .Values.serviceAccount.annotations }}
  annotations: {{ include "cf-common-0.7.1.tplrender" (dict "Values" .Values.serviceAccount.annotations "context" $) | nindent 4 }}
  {{- end }}
secrets:
  - name: {{ include "cf-common-0.7.1.names.fullname" $ }}-sa-token
{{- end }}


{{- if and .Values.serviceAccount.enabled .Values.rbac.enabled  }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: {{ .Values.rbac.namespaced | ternary "Role" "ClusterRole" }}
metadata:
  name: {{ include "cf-common-0.7.1.names.fullname" $ }}
  labels: {{ include "cf-common-0.7.1.labels.standard" . | nindent 4 }}
rules: {{ include "cf-common-0.7.1.tplrender" (dict "Values" .Values.rbac.rules "context" $) | nindent 2 }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: {{ .Values.rbac.namespaced | ternary "RoleBinding" "ClusterRoleBinding" }}
metadata:
  name: {{ include "cf-common-0.7.1.names.fullname" $ }}
  labels: {{ include "cf-common-0.7.1.labels.standard" . | nindent 4 }}
roleRef:
  kind: {{ .Values.rbac.namespaced | ternary "Role" "ClusterRole" }}
  name: {{ include "cf-common-0.7.1.names.fullname" $ }}
  apiGroup: rbac.authorization.k8s.io
subjects:
  - kind: ServiceAccount
    name: {{ default ( include "cf-common-0.7.1.names.fullname" $) .Values.serviceAccount.nameOverride }}
    namespace: {{ .Release.Namespace }}
{{- end }}

{{- end -}}
