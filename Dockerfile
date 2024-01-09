# Stage 1: Node.js installation stage
FROM node:latest as node-installer

# Set a working directory
WORKDIR /tmp

# Install Node.js and npm
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Stage 2: Jenkins stage
FROM jenkins/jenkins:lts

# Copy Node.js binaries from the first stage
COPY --from=node-installer /usr/bin/node /usr/bin/node

# Install Node.js and npm directly in the Jenkins image
USER root
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    mkdir /var/jenkins_home/.npm-global && \
    chown -R jenkins:jenkins /var/jenkins_home/.npm-global

# Switch back to the Jenkins user
USER jenkins

# Set npm prefix to a directory where Jenkins user has write permissions
ENV NPM_CONFIG_PREFIX=/var/jenkins_home/.npm-global
ENV PATH=$PATH:/var/jenkins_home/.npm-global/bin

# Install Testim CLI (or any other Node.js tools you need)
RUN npm install -g @testim/testim-cli

# Add any additional setup or commands here

# Expose Jenkins port
EXPOSE 8080

