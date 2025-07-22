FROM ubuntu:latest
# Install dependencies
RUN apt-get update && \
   apt-get install -y git curl wget build-essential npm vim
# Install Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
   apt-get install -y nodejs
# Install Go 1.23.10
ENV GO_VERSION=1.23.10
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
   rm -rf /usr/local/go && \
   tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Set working directory to shared folder
WORKDIR /workspace

# Enable pprof and GC tracing
ENV GODEBUG=gctrace=1

# Expose default port and pprof port
EXPOSE 8090 6060

# Start with bash shell for interactive development
CMD ["/bin/bash"]