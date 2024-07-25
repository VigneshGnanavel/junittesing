# Use a base image with OpenJDK
FROM eclipse-temurin:21-jdk

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven wrapper files and project descriptor
COPY mvnw .
COPY .mvn .mvn

# Copy the rest of the project files
COPY pom.xml .
COPY src ./src

# Download dependencies and build the project
RUN ./mvnw dependency:go-offline
RUN ./mvnw clean package

# Run the tests
RUN ./mvnw test

# Define the entry point for the container
CMD ["./mvnw", "spring-boot:run"]
