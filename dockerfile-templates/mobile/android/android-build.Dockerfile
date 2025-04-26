# Android build environment for CI/CD
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    file \
    git \
    openjdk-17-jdk \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set up environment variables
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_SDK_HOME=/opt/android-sdk
ENV ANDROID_NDK_HOME=/opt/android-sdk/ndk-bundle
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/33.0.1

# Create directory for Android SDK
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools

# Download and install Android SDK command line tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip && \
    mv cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm cmdline-tools.zip

# Accept licenses and install required Android SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" \
    "platforms;android-33" \
    "build-tools;33.0.1" \
    "ndk-bundle" \
    "cmake;3.22.1" \
    "extras;android;m2repository" \
    "extras;google;m2repository"

# Install Gradle
ARG GRADLE_VERSION=8.3
RUN wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -O gradle.zip && \
    mkdir -p /opt/gradle && \
    unzip -d /opt/gradle gradle.zip && \
    ln -s /opt/gradle/gradle-${GRADLE_VERSION} /opt/gradle/latest && \
    rm gradle.zip

ENV PATH=${PATH}:/opt/gradle/latest/bin

# Create gradle user home directory and cache directories
RUN mkdir -p /root/.gradle/caches/modules-2/files-2.1 && \
    mkdir -p /root/.gradle/wrapper

# Set up working directory
WORKDIR /app

# Create gradle.properties with memory settings
RUN echo "org.gradle.jvmargs=-Xmx4g -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError" > /root/.gradle/gradle.properties && \
    echo "org.gradle.daemon=true" >> /root/.gradle/gradle.properties && \
    echo "org.gradle.parallel=true" >> /root/.gradle/gradle.properties && \
    echo "org.gradle.caching=true" >> /root/.gradle/gradle.properties

# Add entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set default command
ENTRYPOINT ["/entrypoint.sh"]
CMD ["./gradlew", "assembleRelease"]
