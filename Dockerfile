FROM ubuntu:22.04

# Install bindfs and dependencies
RUN apt-get update && \
    apt-get install -y \
    bindfs \
    fuse \
    && rm -rf /var/lib/apt/lists/*

# Create mount points
RUN mkdir -p /mnt/source /mnt/target

# Set up FUSE configuration
RUN echo "user_allow_other" >> /etc/fuse.conf

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Default command shows help
CMD []
