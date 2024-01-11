# Use an official PHP runtime as a parent image
FROM php:apache

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY /app /var/www/html

# Expose port 80 for Apache
EXPOSE 80

# Define environment variables
ENV APACHE_DOCUMENT_ROOT /var/www/html

# Configure Apache to use the new document root
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot ${APACHE_DOCUMENT_ROOT}|' /etc/apache2/sites-available/000-default.conf && \
    sed -i 's|<Directory /var/www/>|<Directory ${APACHE_DOCUMENT_ROOT}>|' /etc/apache2/apache2.conf

# Enable Apache modules
RUN a2enmod rewrite

# Run Apache in the foreground when the container starts
CMD ["apache2-foreground"]
