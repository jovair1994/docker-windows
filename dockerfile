# Dockerfile for the VM container Linux with noVNC

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
    novnc \
    websockify \
    curl \
    && rm -rf /var/lib/apt/lists/*
    
# Copy the VM images to the container
COPY win10.qcow2 /root/


# Set up noVNC
ENV NO_VNC_HOME=/root/noVNC
ENV VNC_PORT=5900
ENV NO_VNC_PORT=6080
RUN mkdir -p $NO_VNC_HOME/utils/websockify && \
    curl -L -o $NO_VNC_HOME/utils/websockify/websockify.py https://github.com/novnc/websockify/blob/master/websockify.py && \
    chmod +x $NO_VNC_HOME/utils/websockify/websockify.py
EXPOSE $NO_VNC_PORT
COPY vnc_startup.sh $NO_VNC_HOME/utils/
RUN chmod +x $NO_VNC_HOME/utils/vnc_startup.sh

#Aqui fiquei na dúvida se usaria ENTRYPOINT ou CMD. De qualquer forma, nenhum dos dois funcionou.

# Set Entry

#ENTRYPOINT ["/root/noVNC/utils/vnc_startup.sh"]
