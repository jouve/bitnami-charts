{{/*
Create the name of the service account to use
usage: {{ template "common.names.serviceAccountName" (dict "serviceAccountRoot" .Values.serviceAccount "context" .) }}
*/}}
{{- define "common.names.serviceAccountName" -}}
{{- if .serviceAccountRoot.name -}}
{{ tpl .serviceAccountRoot.name .context }}
{{- else if .serviceAccountRoot.create -}}
{{ template "common.names.fullname" .context }}
{{- else -}}
default
{{- end -}}
{{- end -}}


{{/*
usage: {{ include "common.hpa.metricTarget" (dict "type" "Utilization" "value" 75 "context" .) | nindent 8 }}
*/}}
{{- define "common.hpa.metricTarget" -}}
{{- if eq (include "common.capabilities.hpa.apiVersion" .context) "autoscaling/v2beta1" }}
{{- if eq .type "Utilization" -}}
targetAverageUtilization: {{ .value }}
{{- else if eq .type "Value" -}}
value: {{ fail "target type 'Value' not supported" }}
{{- else if eq .type "AverageValue" -}}
targetAverageValue: {{ .value }}
{{- end -}}
{{- else }}
target:
  type: {{ .type }}
  {{- if eq .type "Utilization" -}}
  averageUtilization: {{ .value }}
  {{- else if eq .type "Value" -}}
  value: {{ .value }}
  {{- else if eq .type "AverageValue" -}}
  averageValue: {{ .value }}
  {{- end -}}
{{- end -}}
{{- end -}}
