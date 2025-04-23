# This pulls the official Apache HTTP Server image (version 2.4)
FROM httpd:2.4

# Remove the default index.html (optional)
RUN rm -f /usr/local/apache2/htdocs/index.html

# Copy our custom HTML page
COPY index.html /usr/local/apache2/htdocs/index.html
