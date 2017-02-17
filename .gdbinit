#set auto-load safe-path $HOME/
#add-auto-load-safe-path /home/jbech/tutorial/.gdbinit

set print pretty on
set output-radix 0x10
set history save
#focus cmd
#layout src

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

#define newt
#  target remote localhost:2331
#  symbol-file /home/jbech/devel/newt/nRF52/bin/nrf52_boot/apps/boot/boot.elf
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/bootutil/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/apps/boot/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/os/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/hw/hal/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/hw/mcu/nordic/nrf52xxx/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/hw/mcu/native/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/hw/bsp/nrf52dk/src/arch/cortex_m4
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/hw/bsp/nrf52dk/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/cmsis-core/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/baselibc/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/cmsis-core/include/cmsis-core
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/os/src/arch/cortex_m4
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/os/src/arch/cortex_m4/m4
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/sys/config/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/fs/nffs/src
#  b boot.c:120
#end
#
#define newt_stm
#  target remote localhost:2331
#  symbol-file /home/jbech/devel/newt/nRF52/bin/stm_boot/apps/boot/boot.elf
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/bootutil/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/apps/boot/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/os/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/hw/hal/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/hw/mcu/native/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/hw/bsp/nucleo-f401re/src/arch/cortex_m4
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/hw/bsp/nucleo-f401re/src/arch
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/hw/bsp/nucleo-f401re/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/cmsis-core/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/baselibc/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/cmsis-core/include/cmsis-core
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/os/src/arch/cortex_m4
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/os/src/arch/cortex_m4/m4
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/sys/config/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/fs/nffs/src
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/libs/os/src/arch/cortex_m4/m4
#  dir /home/jbech/devel/newt/nRF52/repos/apache-mynewt-core/hw/mcu/stm/stm32f4xx/src
#  b boot.c:120
#end
#
#define blinky_8000
#  # When loading a Zephyr binary, use 8020 as offset.
#  add-symbol-file /home/jbech/devel/newt/nRF52/bin/blink_nordic/apps/blinky/blinky.elf 0x8000
#  dir /home/jbech/devel/newt/nRF52/apps/blinky/src
#  b main.c:95
#end
#
#define blinky_9000
#
#  # When loading a Zephyr binary, use 8020 as offset.
#  add-symbol-file /home/jbech/devel/newt/nRF52/bin/blink_nordic/apps/blinky/blinky.elf 0x9000
#  dir /home/jbech/devel/newt/nRF52/apps/blinky/src
#  b main.c:95
#end
#
#define zephyr
#  target remote localhost:2331
#  symbol-file /home/jbech/devel/zephyr-project/samples/shell/outdir/nrf52_pca10040/zephyr.elf
#end
#
#define zephyrshellmicro
#  target remote localhost:2331
#  add-symbol-file /home/jbech/devel/zephyr-project/samples/shell/microkernel/outdir/96b_carbon/zephyr.elf 0x08020020
#end
#
#define zephyrshellnano
##target remote localhost:2331
#  add-symbol-file /home/jbech/devel/zephyr-project/samples/shell/nanokernel/outdir/96b_carbon/zephyr.elf 0x08020020
#end
#
#define tiny
#	set args -c -o foo2
#	focus cmd
#	b read_keys
#end
#
#define hikey
#  set remotetimeout 60
#  file ~/devel/optee_projects/optee_hikey/optee_os/out/arm-plat-hikey/core/tee.elf
#  target remote localhost:3333
#  add-symbol-file ~/devel/optee_projects/optee_hikey/linux/vmlinux 0xffffffc000081000
#  # use below to force hardare breakpoints if software misbhehave or A64/A32/T conflicts
#  mon gdb_breakpoint_override hard
#  # test next 2 -- halt on any target ?
#  #mon aarch64 smp_on
#  mon targets 0
#  b __thread_std_smc_entry
#  b tee_entry
#  set pagination off
#  l tee_user_ta_enter
#  b 672 
#  b 694
#  set pagination on
#  mon targets 0
#  dis 1
#  #dis 2
#  # if linux symbols loaded then try a breakpoint in linux
#  ##b do_sys_open
#  c
#end
#
#define state
#  mon aarch64 mmu_info
#  mon aarch64 state
#end
#
#define targets
#  if $argc == 0
#    mon targets
#  end
#  if $argc == 1
#    mon targets $arg0
#  end
#end
#
#define smp_off
#  mon aarch64 smp_off
#end
#
#define smp_on
#  mon aarch64 smp_on
#end
#
#define mmu_info
#  mon aarch64 mmu_info
#end
#
#define resume
#  mon aarch64 smp_on
#  mon resume
#end
#
#define halt
#  mon aarch64 smp_on
#  mon halt
#  mon aarch64 smp_off
#end
#
#define reset
#  mon aarch64 smp_on
#  if $argc == 0
#    mon reset
#  end
#  if $argc == 1
#    mon reset $arg0
#  end
#  mon aarch64 smp_off
#  mon halt
#end
#
#define optee
#  target remote 127.0.0.1:1234
#  symbol-file /home/jbech/devel/optee_projects/qemu/optee_os/out/arm/core/tee.elf
#end
#
#define helloworld
#  add-symbol-file /home/jbech/devel/optee_projects/qemu/hello_world/ta/8aaaf200-2450-11e4-abe20002a5d5c51b.ta 0x101020
#end
#
#define gp_conf_ta
#  add-symbol-file /home/jbech/devel/optee_projects/qemu/hello_world/ta/8aaaf200-2450-11e4-abe20002a5d5c51b.ta 0x101020
#end
#
#define optee_v8
#  target remote 127.0.0.1:1234
#  symbol-file /home/jbech/devel/optee_projects/qemu_v8/optee_os/out/arm/core/tee.elf
#end
#
#define kernel
#  target remote 127.0.0.1:1234
#  symbol-file /home/jbech/devel/optee_projects/qemu/linux/vmlinux
#end
#
#define connect
#  target remote localhost:2331
#end
#
#define walk_mmu_entry
#	set $list = ($arg0)
#		while ((tee_mm_entry_t *)$list->next != 0)
#		p (uintptr_t *)(tee_mm_entry_t *)$list->next
#		p (uint32_t *)(tee_mm_entry_t *)$list->size
#		p (uint32_t *)(tee_mm_entry_t *)$list->offset
#		set $list = (tee_mm_entry_t *)$list->next
#	end
#end
#document walk_mmu_entry
#	walk_mmu_entry <list>: Dumps the strings in a tee_mmu_entry
#	entry->next
#	entry->size
#	entry->offset
#	...
#end
