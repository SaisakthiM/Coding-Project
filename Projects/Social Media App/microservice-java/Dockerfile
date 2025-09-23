# Stage 1: build
FROM maven:3.9.11-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom and wrapper first for caching
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Download dependencies offline
RUN mvn dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: runtime
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Install required tools for wait script
RUN apk add --no-cache bash curl netcat-openbsd

# Copy the built jar
COPY --from=build /app/target/*.jar app.jar

# Copy the wait-for-Cassandra script
COPY wait-for-cassandra.sh /wait-for-cassandra.sh
RUN chmod +x /wait-for-cassandra.sh

# Start the service after waiting for Cassandra
CMD ["/wait-for-cassandra.sh"]

COPY wait-for-cassandra.sh /wait-for-cassandra.sh
RUN chmod +x /wait-for-cassandra.sh
ENTRYPOINT ["/wait-for-cassandra.sh"]
