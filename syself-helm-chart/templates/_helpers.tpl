{{- define "my-helm-chart.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{- define "my-helm-chart.fullname" -}}
{{ .Release.Name }}-{{ include "my-helm-chart.name" . }}
{{- end -}}

{{- define "my-helm-chart.labels" -}}
helm.sh/chart: {{ include "my-helm-chart.name" . }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "my-helm-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
