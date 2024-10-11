# MERN App Deployment Guide

This guide walks through the steps to deploy a MERN stack application on an AWS EC2 instance using Docker, Docker Compose, Jenkins for CI/CD, and Nginx as a reverse proxy. Terraform is used to automate the infrastructure setup, while Docker ensures a consistent runtime environment.

## Prerequisites

- **AWS Account**: With permission to create EC2 instances.
- **Terraform Installed**: For infrastructure provisioning.
- **GitHub Repository**: A clone of the MERN app from [this repo](https://github.com/maham0612/mern-app.git).

---

## Step 1: Provision AWS EC2 with Terraform

First, create a Terraform file (`EC2.tf`) to automate the creation of an EC2 instance that will host the website. The instance will be configured to install the following software via user data:

- **Nginx**: Web server to act as a reverse proxy.
- **Git**: To clone the MERN app from GitHub.
- **Docker & Docker Compose**: For containerizing the application.
- **Jenkins**: For continuous integration and deployment.
- **MongoDB**: Database for the MERN app.
- **Node.js**: Backend runtime environment.

Add Jenkins to the Docker group in the user data.

### Steps:

1. **Initialize Terraform**:  
   In your local environment, navigate to the directory with the Terraform configuration file and run:

   ```bash
   terraform init
   ```

2. **Apply Terraform Configuration**:  
   To create the EC2 instance, apply the configuration by running:

   ```bash
   terraform apply
   ```
Once the instance is up, the user data script will handle the installation of the required packages and services.  
Check **EC2.tf** & **user-data.sh** files.

---

## Step 2: Clone the Repository

Once the EC2 instance is running, SSH into it and clone the MERN app from the GitHub repository. The app code will be used to create Docker and Docker Compose configurations.

```bash
git clone https://github.com/maham0612/mern-app.git
```

This repository will contain the necessary application files.  
Also, check **Git Repo link** to get the code link.

---

## Step 3: Create Docker and Docker Compose Files

Inside the repository directory on the EC2 instance, create the following files:

- **Dockerfile**: In the Dockerfile, use the Ubuntu image and define necessary instructions to install dependencies (Node.js, MongoDB), add code, make a build of the code, and run MongoDB and the server in the background.  
  Expose the application on port 5000 and MongoDB on port 27017.
  
- **docker-compose.yml**: In the Docker Compose file, create a build of the image and bind the container to port 5000. Also, attach a volume so that the data is not lost if the container stops.

Push these files to the GitHub repository to ensure that they can be accessed by Jenkins for deployment.  
Check **Dockerfile** & **docker-compose.yml**.

---

## Step 4: Set Up Jenkins Pipeline

Jenkins will automate the process of building, removing old images/containers, and deploying the application.

### Steps:

1. **Access Jenkins**:  
   Open Jenkins on the EC2 instance by navigating to `http://<EC2-IP>:8080` in your browser.

2. **Create a New Pipeline**:  
   In Jenkins, create a new pipeline job that will:

   - **Clone the GitHub repository**: Fetch the latest code for the MERN app.
   - **Remove existing Docker images and containers**: This ensures that you start with a fresh deployment. The pipeline should run commands to remove any old containers and images related to the app.
   - **Build and deploy the application**: Use Docker Compose to build the image and start the necessary services.
   
   The pipeline script can include steps like:
   
   - Fetching the latest code from GitHub.
   - Removing old images and containers.
   - Rebuilding the image using Docker Compose.
   - Starting the containers in detached mode.

3. **Add Jenkins to the Docker Group**:  
   Ensure Jenkins can run Docker commands without needing sudo access. This can be done by adding Jenkins to the Docker group in the user data when creating the EC2 instance.

---

Check **Jenkins bashscript** file.

## Step 5: Configure Nginx as a Reverse Proxy

Nginx will be set up to route incoming traffic to the appropriate backend service (the Node.js app running in Docker).

### Steps:

1. **Edit Nginx Configuration**:  
   On EC2 instance, create or edit the Nginx configuration file to define a reverse proxy. This file will tell Nginx to forward all incoming requests to Node.js app running on a port 5000.

Check **nginx as proxy** file.

2. **Restart Nginx**:  
   After updating the configuration, restart Nginx to apply the changes.

---

## Step 6: Test the Deployment

Once Jenkins runs the pipeline and Nginx is configured, MERN app is up and running. It is access by navigating to the domain or IP address associated with EC2 instance.

 Test all the functionality of the app to confirm that everything is working as expected.

---

## Conclusion

By following these steps, a fully automated deployment pipeline for MERN stack application, running on an AWS EC2 instance, containerized with Docker, managed by Jenkins, and served through Nginx. Each time update the code and push changes to GitHub, Jenkins will handle the deployment, ensuring a streamlined CI/CD process.

For the MERN app code, visit the [GitHub repository](https://github.com/maham0612/mern-app.git).

---
