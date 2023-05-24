#!/bin/bash
echo "Starting Qemu"
nohup qemu-system-x86_64 -name win10 -m 2048 -cpu host -vga virtio -enable-kvm -smp 2 -drive file=/root/win10.qcow2,if=virtio -net nic,model=virtio -net user -vnc :0 -vncclient compresstcp -encodings copyrect,hextile -full-screen -display vnc=:1,1920x1080 -k pt-br &


echo "Starting noVNC"
/opt/novnc/utils/novnc_proxy --listen 5000 --vnc localhost:5900

echo "Starting websockify"
bash