{{/*
Renders PersistentVolumeClaim objects
{{- include "cf-common-0.2.0.pvc" . -}}
*/}}
{{- define "cf-common-0.2.0.pvc" -}}

{{- range $pvcIndex, $pvcItem := .Values.persistence }}

{{- $pvcEnabled := include "cf-common-0.2.0.tplrender" (dict "Values" $pvcItem.enabled "context" $) }}
{{- if ( toBool $pvcEnabled) }}
{{- $pvcName := printf "%s-%s" (include "cf-common-0.2.0.names.fullname" $) $pvcIndex }}

{{- if and (hasKey $pvcItem "nameOverride") $pvcItem.nameOverride  }}
{{- $pvcName = include "cf-common-0.2.0.tplrender" (dict "Values" $pvcItem.nameOverride "context" $) -}}
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
      storage: {{ include "cf-common-0.2.0.tplrender" (dict "Values" $pvcSize "context" $)  | quote }}
  {{- if $pvcItem.storageClass }}
  {{- $pvcStorageClassName := include "cf-common-0.2.0.tplrender" (dict "Values" $pvcItem.storageClass "context" $)  }}
  storageClassName: {{ if (eq "-" $pvcItem.storageClass) }}""{{- else }}{{ $pvcStorageClassName | quote }}{{- end }}
  {{- end }}
  {{- if $pvcItem.volumeName }}
  volumeName: {{ $pvcItem.volumeName | quote }}
  {{- end }}

{{- end }}

{{- end }}

{{- end -}}
