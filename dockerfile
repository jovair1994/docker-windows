# Base image
FROM ubuntu:latest

# Install necessary packages
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean 

# Install necessary packages2
RUN apt-get update && apt-get install -y \
    qemu-kvm \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*
    
# Copy the VM images to the container
COPY win10.qcow2 /root/

# Set up noVNC
ENV NO_VNC_HOME=/root/noVNC
ENV VNC_PORT=5900
ENV NO_VNC_PORT=5000


RUN apt-get update && apt-get install -y \
    git \
    wget \
    net-tools \
    python3-numpy \
    python3-dev \
    python3-setuptools \
    python3-websockify \
    novnc && \
    apt-get clean

# Download noVNC release
RUN wget https://codeload.github.com/novnc/noVNC/tar.gz/refs/tags/v1.4.0 && \
    tar -xzvf v1.4.0 && \
    mv noVNC-1.4.0 /opt/novnc && \
    rm v1.4.0 && \
    cp -f /opt/novnc/vnc.html /opt/novnc/index.html


EXPOSE $NO_VNC_PORT

COPY vnc_startup.sh $NO_VNC_HOME/utils/
RUN chmod +x $NO_VNC_HOME/utils/vnc_startup.sh

ENTRYPOINT ["/root/noVNC/utils/vnc_startup.sh"]
