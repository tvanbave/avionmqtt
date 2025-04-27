FROM python:3.11-slim

WORKDIR /app

# Install required system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    bluez \
    libglib2.0-dev \
    make \
    gcc \
    g++ \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the Python path to include /app/src
ENV PYTHONPATH=/app/src

# Copy your app
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Start the app
CMD ["python", "src/avionmqtt/__init__.py", "-s", "settings.yaml"]
