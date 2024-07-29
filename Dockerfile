FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN apk add --no-cache maven
RUN mvn clean install
CMD ["java", "-jar", "/app/target/YoutubeAutomatedTesting-0.0.1-SNAPSHOT.jar"]
