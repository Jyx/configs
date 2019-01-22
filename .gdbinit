#set auto-load safe-path $HOME/
#add-auto-load-safe-path /home/jbech/tutorial/.gdbinit

set $PROJ_PATH="/media/jbech/SSHD_LINUX/devel/optee_projects/qemu"

set print pretty on
set output-radix 0x10
set history save
#focus cmd
#layout src

################################################################################
# Dashboard
################################################################################
source /home/jbech/configs/.gdb-dashboard
dashboard history -style limit 2
dashboard stack -style limit 2

define db
  dashboard
end

source /home/jbech/configs/gdb-optee.py
source /home/jbech/configs/hexdump.py

################################################################################
# Misc
################################################################################
define xxd
  dump binary memory dump.bin $arg0 $arg0+$arg1
  shell xxd dump.bin
end

################################################################################
# TEE core
################################################################################
define optee
  target remote 127.0.0.1:1234
  symbol-file /media/jbech/SSHD_LINUX/devel/optee_projects/qemu/optee_os/out/arm/core/tee.elf
end

################################################################################
# Trusted Applications
################################################################################
define hotp
  add-symbol-file /media/jbech/SSHD_LINUX/devel/optee_projects/qemu/out-br/build/optee_examples-1.0/hotp/ta/out/484d4143-2d53-4841-3120-4a6f636b6542.elf 0x103020
end

define sdp
  add-symbol-file /media/jbech/SSHD_LINUX/devel/optee_projects/qemu/out-br/build/optee_test-1.0/ta/sdp_basic/out/12345678-5b69-11e4-9dbb-101f74f00099.elf 0x103020
end


################################################################################
# Host applications etc
################################################################################
define hotphost
  file /media/jbech/SSHD_LINUX/devel/optee_projects/qemu/out-br/build/optee_examples-1.0/hotp/hotp
  set sysroot /media/jbech/SSHD_LINUX/devel/optee_projects/qemu/out-br/host/arm-buildroot-linux-gnueabihf/sysroot
  target remote 127.0.0.1:12345
  set stop-on-solib-events 1
end

define teesupp
  set sysroot /media/jbech/SSHD_LINUX/devel/optee_projects/qemu/out-br/host/arm-buildroot-linux-gnueabihf/sysroot
  file /media/jbech/SSHD_LINUX/devel/optee_projects/qemu/out-br/build/optee_client-1.0/tee-supplicant/tee-supplicant
  set args /dev/tee0
  target remote 127.0.0.1:12345
end

define libteec
  set sysroot /media/jbech/SSHD_LINUX/devel/optee_projects/qemu/out-br/host/arm-buildroot-linux-gnueabihf/sysroot
  file /media/jbech/SSHD_LINUX/devel/optee_projects/qemu/out-br/build/optee_client-1.0/libteec/libteec.so
  target remote 127.0.0.1:12345
end


################################################################################
# Linux kernel
################################################################################
define linux
  target remote 127.0.0.1:1234
  symbol-file /media/jbech/SSHD_LINUX/devel/optee_projects/qemu/linux/vmlinux
end

################################################################################
# Trusted Firmware A
################################################################################
define bl2
  target remote 127.0.0.1:1234
  symbol-file /media/jbech/SSHD_LINUX/devel/optee_projects/qemu/arm-trusted-firmware/build/qemu/debug/bl2/bl2.elf
end

# Old stuff
#define helloworld
#  add-symbol-file /home/jbech/devel/optee_projects/qemu/hello_world/ta/8aaaf200-2450-11e4-abe2-0002a5d5c51b.elf 0x101020
#end
#
#define trasher
#  add-symbol-file /home/jbech/devel/optee_projects/qemu/trasher/ta/11111111-2222-3333-4455-6677-8899aabb.elf 0x101020
#end
#
#define gp_conf_ta
#  add-symbol-file /home/jbech/devel/optee_projects/qemu/gp_conf/ta/67707465-6563-6f6e-666c-696e-61726f15.elf 0x101020
#end
#
#define sdp
#  add-symbol-file /home/jbech/devel/optee_projects/qemu/optee_test/out/ta/sdp_basic/12345678-5b69-11e4-9dbb-101f-74f00099.elf 0x101020
#end

