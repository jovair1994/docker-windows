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

# Add script to run qemu command
COPY run_qemu.sh /root/
RUN chmod +x /root/run_qemu.sh

# Set entry point to run the qemu command
ENTRYPOINT ["/usr/bin/qemu-system-x86_64"]
CMD ["-name", "nome_do_container", "-m", "2048", "-cpu", "host", "-enable-kvm", "-smp", "2", "-drive", "file=/root/win10.qcow2,if=virtio", "-net", "nic,model=virtio", "-net", "user", "-soundhw", "hda", "-usb", "-device", "usb-tablet", "-vnc", ":0", "-display", "none"]
