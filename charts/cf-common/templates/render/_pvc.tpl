{{/*
Renders PersistentVolumeClaim objects
{{- include "cf-common-0.2.0.pvc" . -}}
*/}}
{{- define "cf-common-0.2.0.pvc" -}}

{{- range $pvcIndex, $pvcItem := .Values.persistence }}

{{- if and (not $pvcItem.existingClaim) (eq (default "pvc" $pvcItem.type) "pvc") $pvcItem.enabled  }}
{{- $pvcName := printf "%s-%s" (include "cf-common-0.2.0.names.fullname" $) $pvcIndex }}

{{- if and (hasKey $pvcItem "nameOverride") $pvcItem.nameOverride  }}
{{- $pvcName = include "cf-common-0.2.0.tplrender" (dict "Values" $pvcItem.nameOverride "context" $) }}
{{- end }}
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ $pvcName }}
  labels: {{ include "cf-common-0.2.0.labels.standard" $ | nindent 4 }}
  {{- if $pvcItem.labels }}
  {{- include "cf-common-0.2.0.tplrender" (dict "Values" $pvcItem.labels "context" $) | nindent 4 }}
  {{- end }}
  annotations:
  {{- if $pvcItem.retain }}
    "helm.sh/resource-policy": keep
  {{- end }}
  {{- if $pvcItem.annotations }}
  {{- include "cf-common-0.2.0.tplrender" (dict "Values" $pvcItem.annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  {{- $pvcSize := required (printf "size is required for PVC %v" $pvcName) $pvcItem.size }}
  accessModes:
    - {{ required (printf "accessMode is required for PVC %v" $pvcName) $pvcItem.accessMode | quote }}
  resources:
    requests:
      storage: {{ $pvcItem.size | quote }}
  {{- if $pvcItem.storageClass }}
  storageClassName: {{ include "cf-common-0.2.0.storageclass" ( dict "persistence" $pvcItem "global" $) }}
  {{- end }}
  {{- if $pvcItem.volumeName }}
  volumeName: {{ $pvcItem.volumeName | quote }}
  {{- end }}

{{- end }}

{{- end }}

{{- end -}}
