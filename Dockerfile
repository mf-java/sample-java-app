# FROM websphere-liberty:microProfile
# COPY server.xml /config/
# ADD target/GetStartedJava.war /opt/ibm/wlp/usr/servers/defaultServer/dropins/
# ENV LICENSE accept
# EXPOSE 9080
# Pull base image 
#FROM tomcat:jre8-temurin-jammy 

#RUN apt-get update && apt-get install maven -y
FROM maven:3.5.2-jdk-8-alpine as maven_builder

COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/
RUN mvn clean install 
RUN mvn package

FROM tomcat:9.0-jre8-alpine
COPY --from=maven_builder /tmp/target/GetStartedJava.war /usr/local/tomcat/webapps

#ENV MAVEN_HOME="apache-maven-3.6.3"    

# Maven Goals
#RUN mvn clean install 
#RUN mvn package
#COPY /webapp/target/GetStartedJava.war /usr/local/tomcat/webapps

## Running the container locally
# mvn clean install
# docker build -t getstartedjava:latest .
# docker run -d --name myjavacontainer getstartedjava
# docker run -p 9080:9080 --name myjavacontainer getstartedjava
# Visit http://localhost:9080/GetStartedJava/

## Push container to IBM Cloud
# docker tag getstartedjava:latest registry.ng.bluemix.net/<my_namespace>/getstartedjava:latest
# docker push registry.ng.bluemix.net/<my_namespace>/getstartedjava:latest
# ibmcloud ic images # Verify new image
