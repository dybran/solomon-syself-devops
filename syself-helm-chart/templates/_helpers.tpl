{{- define "syself-helm-chart.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{- define "syself-helm-chart.fullname" -}}
{{ .Release.Name }}-{{ include "syself-helm-chart.name" . }}
{{- end -}}

{{- define "syself-helm-chart.labels" -}}
helm.sh/chart: {{ include "syself-helm-chart.name" . }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "syself-helm-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
