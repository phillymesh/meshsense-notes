FROM ubuntu:latest
EXPOSE 5920

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
    fuse \
    libfuse2 \
    curl \
    libgtk2.0-0 \
    libnss3 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libgtk-3.0 \
    libgbm1 \
    libasound2t64 \
    xvfb

RUN curl -SL -o meshsense https://affirmatech.com/download/meshsense/meshsense-x86_64.AppImage && mv meshsense /usr/local/bin/ && chmod +x /usr/local/bin/meshsen>

ENV ACCESS_KEY=${ACCESS_KEY}

CMD ["dbus-run-session", "xvfb-run", "./usr/local/bin/meshsense", "--headless", "--no-sandbox", "--disable-gpu"]
