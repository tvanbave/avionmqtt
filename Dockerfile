FROM python:3.11-slim

WORKDIR /app

# Copy your app into the container
COPY . /app

# Install Python requirements
RUN pip install --no-cache-dir -r requirements.txt

# Default command
CMD ["python", "src/avionmqtt/__init__.py", "-s", "settings.yaml"]
