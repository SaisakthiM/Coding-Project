FROM maven:3.9.6-eclipse-temurin-21

WORKDIR /app

COPY . .

RUN mvn test-compile

RUN mvn dependency:copy-dependencies -DincludeScope=test


RUN chmod +x entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]