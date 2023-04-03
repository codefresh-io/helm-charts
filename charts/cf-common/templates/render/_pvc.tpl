{{/*
Renders PersistentVolumeClaim objects
{{- include "cf-common-0.2.0.secrets" . -}}
*/}}
{{- define "cf-common-0.2.0.pvc" -}}

{{- range $pvcIndex, $pvcItem := .Values.persistence }}

{{- if $pvcItem.enabeled }}
{{- $pvcName := printf "%s-%s" (include "cf-common-0.2.0.names.fullname" $) $pvcIndex }}
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ $pvcName }}
  labels: {{ include "cf-common-0.1.2.labels.standard" $ | nindent 4 }}
  {{- if $pvcItem.labels }}
  {{- include "cf-common-0.1.2.tplrender" (dict "Values" $pvcItem.labels "context" $) | nindent 4 }}
  {{- end }}
  annotations:
  {{- if $values.retain }}
  "helm.sh/resource-policy": keep
  {{- end }}
  {{- if $pvcItem.annotations }}
  {{- include "cf-common-0.1.2.tplrender" (dict "Values" $pvcItem.annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  accessModes:
    - {{ required (printf "accessMode is required for PVC %v" $pvcName) $pvcItem.accessMode | quote }}
  resources:
    requests:
      storage: {{ required (printf "size is required for PVC %v" $pvcName) $pvcItem.size | quote }}
  {{- if $pvcItem.storageClass }}
  storageClassName: {{ if (eq "-" $pvcItem.storageClass) }}""{{- else }}{{ $values.storageClass | quote }}{{- end }}
  {{- end }}
  {{- if $pvcItem.volumeName }}
  volumeName: {{ $pvcItem.volumeName | quote }}
  {{- end }}

{{- end }}

{{- end }}




{{- end -}}
