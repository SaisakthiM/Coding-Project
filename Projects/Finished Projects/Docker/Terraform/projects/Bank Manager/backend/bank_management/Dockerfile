FROM maven:3.9.6-eclipse-temurin-21

WORKDIR /app

COPY . .


RUN mvn dependency:copy-dependencies -DincludeScope=test


RUN chmod +x entrypoint.sh

# Download the agent at build time
ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar /app/opentelemetry-javaagent.jar

ENV JAVA_TOOL_OPTIONS="-javaagent:/app/opentelemetry-javaagent.jar"
ENV OTEL_SERVICE_NAME="bank-backend"
ENV OTEL_EXPORTER_OTLP_ENDPOINT="http://otel-gateway:4317"
ENV OTEL_EXPORTER_OTLP_PROTOCOL="grpc"
ENV OTEL_TRACES_EXPORTER="otlp"
ENV OTEL_METRICS_EXPORTER="otlp"
ENV OTEL_LOGS_EXPORTER="otlp"

ENTRYPOINT ["/app/entrypoint.sh"]