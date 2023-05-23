#!/bin/bash

# Start the VM using QEMU
qemu-system-x86_64 -name win10 -m 2048 -cpu host -enable-kvm -smp 2 -drive file=/root/win10.qcow2,if=virtio -net nic,model=virtio -net user -soundhw hda -usb -device usb-tablet -vnc :0 -display none &
