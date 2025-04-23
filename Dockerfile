FROM python:3.12-slim

WORKDIR /app/OpenManus

# Install Node.js, system dependencies, and required libraries for Playwright
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget gnupg ca-certificates nodejs npm \
    libnss3 libatk-bridge2.0-0 libxss1 libasound2 libxshmfence1 \
    libgtk-3-0 libdrm2 libgbm1 libx11-xcb1 libxcb1 libgdk-pixbuf2.0-0 \
    libenchant-2-2 libsecret-1-0 libgles2 libx264-155 libxslt1.1 \
    libevent-2.1-7 libopus0 libwoff1 libwoff2-1 libvpx7 libwebpdemux2 libwebpmux3 \
    libgst* libflite1 libhyphen0 libmanette-0.2-0 libavif15 libgraphene-1.0-0 \
    libharfbuzz-icu0 libgtk-4-1 libatomic1 \
    && rm -rf /var/lib/apt/lists/*

# Optional: Ensure Node.js is properly installed
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get update && apt-get install -y nodejs

# Install uv if needed
RUN (command -v uv >/dev/null 2>&1 || pip install --no-cache-dir uv)

# Install Playwright and all required browser binaries with dependencies
RUN npm install -g playwright && playwright install --with-deps

# Copy code
COPY . .

# Python dependencies
RUN uv pip install --system -r requirements.txt

# Set main entrypoint
ENTRYPOINT ["python", "main.py"]
