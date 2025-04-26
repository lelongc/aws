# Flutter build environment for Android and iOS
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-17-jdk \
    wget \
    xauth \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    ruby-full \
    ruby-bundler \
    libssl-dev \
    ca-certificates \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Set up environment variables for Flutter and Android SDK
ENV FLUTTER_HOME=/opt/flutter
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$FLUTTER_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Install Flutter
RUN git clone --depth 1 --branch stable https://github.com/flutter/flutter.git $FLUTTER_HOME && \
    $FLUTTER_HOME/bin/flutter precache

# Download Android SDK tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip && \
    mv cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm cmdline-tools.zip

# Accept licenses and install Android SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" \
    "platforms;android-33" \
    "build-tools;33.0.1" \
    "extras;android;m2repository" \
    "extras;google;m2repository"

# Install CocoaPods for iOS builds
RUN gem install cocoapods

# Set up working directory
WORKDIR /app

# Copy Flutter project files
COPY . .

# Get dependencies
RUN flutter pub get

# Run Flutter doctor to verify installation
RUN flutter doctor -v

# Build command for Android (default)
CMD ["flutter", "build", "apk", "--release"]

# For iOS build, use:
# CMD ["flutter", "build", "ios", "--release", "--no-codesign"]
