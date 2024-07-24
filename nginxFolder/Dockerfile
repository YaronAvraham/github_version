# Use the official nginx image as a parent image
FROM nginx:alpine

# Copy the nginx config file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Run nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
