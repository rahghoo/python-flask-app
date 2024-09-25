#Use the official image as a parent image
FROM python:3.8-slim

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip --no-cache-dir install -r requirements.txt

# Run app.py when the container launches
CMD ["python3", "main.py"]