# Use Python 3.11 slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libglib2.0-dev \
    dbus \
    bluez \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first and install (caches better)
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Now copy the actual application code
COPY . .

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Start command
CMD ["python", "-m", "avionmqtt"]
