# --------------------------
# Stage 1: Build the JAR
# --------------------------
FROM maven:3.9.11-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom and wrapper first for caching
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Download dependencies offline
RUN ./mvnw dependency:go-offline

# Copy source and build
COPY src ./src
RUN ./mvnw clean package -DskipTests

# --------------------------
# Stage 2: Runtime
# --------------------------
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Install tools needed for wait script
RUN apk add --no-cache bash curl netcat-openbsd coreutils

# Copy the built jar from the build stage
COPY --from=build /app/target/*.jar /app/

# Copy the wait-for-cassandra script
COPY wait-for-cassandra.sh /wait-for-cassandra.sh
RUN chmod +x /wait-for-cassandra.sh

# Run the wait script, which launches the JAR
ENTRYPOINT ["/wait-for-cassandra.sh"]
