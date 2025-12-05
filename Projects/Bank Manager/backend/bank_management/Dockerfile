# =========================
# 1. Build the Spring Boot JAR
# =========================
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app

# Copy only pom.xml first to cache dependencies
COPY pom.xml .

# Download dependencies
RUN mvn -q dependency:go-offline

# Copy project files
COPY src ./src

# Build JAR
RUN mvn -q clean package -DskipTests


# =========================
# 2. Run the Spring Boot App
# =========================
FROM eclipse-temurin:21-jdk

WORKDIR /app

# Copy JAR from builder stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
