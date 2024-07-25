FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY mvn .
COPY .mvn .mvn
COPY pom.xml .
COPY src ./src
RUN mvn dependency:go-offline
RUN mvn clean package
RUN mvn test
CMD ["mvn", "spring-boot:run"]
