# Use lightweight Python base
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Copy and install dependencies first (layer caching)
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app/ .

# Don't run as root — security best practice
RUN useradd -m appuser && chown -R appuser /app
USER appuser

# Expose port
EXPOSE 5000

# Run with gunicorn (production server, not flask dev server)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "main:app"]