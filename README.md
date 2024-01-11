# Form App

This is a simple Form application built with php and html which will display a message after the form be submitted.

## Getting Started (To Run Locally)

1. Prerequisites:
   
   ``` 
   - php
   ```

2. Clone the repository:

   ```
   git clone https://github.com/RajeevThapa/form-app
   cd form-app/app
   ```

3. Install dependencies:
  
   ```
   - For Debian/Ubuntu: sudo apt-get install php
   - For MacOs: brew install php
   - For Windows: The most simple way to get a local PHP installation along with Apache HTTP server integration is using the XAMPP package installation
   ```

4. Run the server:
   
   ```
   php -S localhost:8000
   ```

Open your web browser and go to http://localhost:8000. The calculator application should be accessible.


## Getting Started (Using Docker)

If you prefer to run the application using Docker, follow these steps:

1. Prerequisites:
   
   ``` 
   - Docker - Download link: https://www.docker.com/get-started/
   ```

2. Clone the repository:

   ```
   git clone https://github.com/RajeevThapa/form-app
   cd form-app
   ```

3. Build the Docker image:
   
   ```
   docker build -t form-app .
   ```

4. Run the Docker container:
   
   ```
   docker run -d -p 3000:80 form-app
   ```

Open your web browser and go to http://localhost:3000. The form application should be accessible.


## Jenkins Pipeline Screenshot



## Project Overview
