# Use Alpine Linux as the base image
FROM alpine:latest 

ENV DEVBOX_DEBUG=1
# Update and install dependencies
RUN apk update && apk add --no-cache \
    curl git bash ca-certificates libc6-compat sudo shadow nix



# Create a non-root user
#RUN sudo groupadd -g 30000 --system nixbld

# Ensure certificates are updated
RUN update-ca-certificates

# Install Devbox non-interactively
RUN curl -fsSL https://get.jetpack.io/devbox | bash -s -- -f

    #/usr/local/bin/devbox
# Add Devbox to PATH
ENV PATH="/root/.devbox/bin:$PATH"

WORKDIR /workspace

# Configure Devbox and install packages
COPY devbox.json /workspace/devbox.json

#RUN /root/.devbox/bin/devbox install

RUN df -h
RUN sudo chown -R root:root /nix
RUN sudo chmod -R 755 /nix

# Set the working directory
WORKDIR /workspace

RUN devbox install

# Default command
CMD ["sh", "-c", "trap 'exit' TERM INT; while true; do sleep 1; done"]