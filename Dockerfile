# Use the officail Node.js 16 image as the base image
FROM node:16

# Set Working directing as app
WORKDIR /app

# Copy package.json and package-lock.json over working directory
COPY package*.json ./

# Install project dependencies
RUN npm install 

# Copy the all applciation  code to the container
COPY . .

# Build the react app
RUN npm run build 
# Expose the application on port 3000

EXPOSE 3000

# Start the react app when the container starts
CMD [ "npm", "start" ]

