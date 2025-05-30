# Use an official Python image as base

FROM python:3.13-slim


# Set working directory inside the container

WORKDIR /app

# Copy project files

COPY . .


# Install dependencies

RUN pip install -r requirements.txt


# Expose the port Flask runs on 

EXPOSE 5000


# Command to run the application

CMD ["python", "app.py"]
