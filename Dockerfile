FROM python:3.1

# Set the working directory to /app
WORKDIR /app

# Add the current directory contents into the container at /app
ADD . /app

# Install any needed packages specified in requirements.txt
ADD requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Expose ports based on the database type
EXPOSE 5432


# Default port for the application
EXPOSE 8003

# Define environment variable
ENV NAME phpgittest

# Run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8003"]