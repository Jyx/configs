#set auto-load safe-path $HOME/
set auto-load local-gdbinit
#add-auto-load-safe-path /home/jbech/tutorial/.gdbinit

set print pretty on
set output-radix 0x10
set history save
focus cmd
layout src
#set disassembly-flavor intel

define optee
  target remote 127.0.0.1:1234
  symbol-file /home/jbech/devel/optee_projects/qemu/optee_os/out/arm/core/tee.elf
end

define helloworld
  add-symbol-file /home/jbech/devel/optee_projects/qemu/hello_world/ta/8aaaf200-2450-11e4-abe2-0002a5d5c51b.elf 0x101020
end

define trasher
  add-symbol-file /home/jbech/devel/optee_projects/qemu/trasher/ta/11111111-2222-3333-4455-6677-8899aabb.elf 0x101020
end

define gp_conf_ta
  add-symbol-file /home/jbech/devel/optee_projects/qemu/gp_conf/ta/67707465-6563-6f6e-666c-696e-61726f15.elf 0x101020
end

define sdp
  add-symbol-file /home/jbech/devel/optee_projects/qemu/optee_test/out/ta/sdp_basic/12345678-5b69-11e4-9dbb-101f-74f00099.elf 0x101020
end

define hotp
  add-symbol-file /home/jbech/devel/optee_projects/qemu/optee_examples/hotp/ta/484d4143-2d53-4841-3120-62617365642e.elf 0x101020
end
