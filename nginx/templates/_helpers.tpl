{{- define "nginx.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{- define "nginx.fullname" -}}
{{ .Release.Name }}-{{ include "syself-helm-chart.name" . }}
{{- end -}}

{{- define "nginx.labels" -}}
helm.sh/chart: {{ include "nginx.name" . }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "nginx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "nginx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nginx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
