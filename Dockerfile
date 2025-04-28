# Use Python 3.11 slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libglib2.0-dev \
    dbus \
    bluez \
    make gcc python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first and install (caches better)
COPY requirements.txt .

# Install normal requirements
RUN pip install --no-cache-dir -r requirements.txt

# Special install csrmesh separately without pulling bluepy
RUN pip install --no-deps csrmesh

RUN pip install pycryptodome && pip install pycryptodomex

RUN pip install bluepy

# Now copy the actual application code
COPY . .

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app/src

# Start command
CMD ["python", "-m", "avionmqtt"]
