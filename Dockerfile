FROM python:3.12-slim

WORKDIR /app/OpenManus

# Install OS dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget gnupg ca-certificates \
    nodejs npm \
    libnss3 libatk-bridge2.0-0 libxss1 libasound2 libxshmfence1 \
    libgtk-3-0 libdrm2 libgbm1 libx11-xcb1 libxcb1 \
    && rm -rf /var/lib/apt/lists/*

# Optional: Fix for Node.js missing in some slim images
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get update && apt-get install -y nodejs

# Install uv if needed
RUN (command -v uv >/dev/null 2>&1 || pip install --no-cache-dir uv)

# Install Playwright and browser dependencies
RUN npm install -g playwright && playwright install --with-deps chromium

# Copy project files into the container
COPY . .

# Install Python dependencies
RUN uv pip install --system -r requirements.txt

# Set entry point to run the main agent
ENTRYPOINT ["python", "main.py"]
CMD []
