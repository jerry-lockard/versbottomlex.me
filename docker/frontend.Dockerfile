FROM ubuntu:22.04 as builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Set up Flutter
RUN mkdir -p /flutter
WORKDIR /flutter
RUN curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.3-stable.tar.xz \
    && tar xf flutter_linux_3.19.3-stable.tar.xz \
    && rm flutter_linux_3.19.3-stable.tar.xz
ENV PATH="/flutter/flutter/bin:${PATH}"

# Set up app
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# Production stage
FROM nginx:alpine

# Copy built app to nginx
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy nginx config
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
