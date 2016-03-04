set auto-load safe-path /
#add-auto-load-safe-path /home/jbech/tutorial/.gdbinit

set print pretty on
set output-radix 0x10
set history save

define hikey
  set remotetimeout 60
  file ~/devel/optee_projects/optee_hikey/optee_os/out/arm-plat-hikey/core/tee.elf
  target remote localhost:3333
  add-symbol-file ~/devel/optee_projects/optee_hikey/linux/vmlinux 0xffffffc000081000
  # use below to force hardare breakpoints if software misbhehave or A64/A32/T conflicts
  mon gdb_breakpoint_override hard
  # test next 2 -- halt on any target ?
  #mon aarch64 smp_on
  mon targets 0
  b __thread_std_smc_entry
  b tee_entry
  set pagination off
  l tee_user_ta_enter
  b 672 
  b 694
  set pagination on
  mon targets 0
  dis 1
  #dis 2
  # if linux symbols loaded then try a breakpoint in linux
  ##b do_sys_open
  c
end

define state
  mon aarch64 mmu_info
  mon aarch64 state
end

define targets
  if $argc == 0
    mon targets
  end
  if $argc == 1
    mon targets $arg0
  end
end

define smp_off
  mon aarch64 smp_off
end

define smp_on
  mon aarch64 smp_on
end

define mmu_info
  mon aarch64 mmu_info
end

define resume
  mon aarch64 smp_on
  mon resume
end

define halt
  mon aarch64 smp_on
  mon halt
  mon aarch64 smp_off
end

define reset
  mon aarch64 smp_on
  if $argc == 0
    mon reset
  end
  if $argc == 1
    mon reset $arg0
  end
  mon aarch64 smp_off
  mon halt
end

define optee
  target remote 127.0.0.1:1234
  symbol-file /home/jbech/devel/optee_projects/qemu/optee_os/out/arm-plat-vexpress/core/tee.elf
end

define kernel
  target remote 127.0.0.1:1234
  symbol-file /home/jbech/devel/optee_projects/qemu/linux/vmlinux
end

define connect
  target remote 127.0.0.1:1234
end

define walk_mmu_entry
	set $list = ($arg0)
		while ((tee_mm_entry_t *)$list->next != 0)
		p (uintptr_t *)(tee_mm_entry_t *)$list->next
		p (uint32_t *)(tee_mm_entry_t *)$list->size
		p (uint32_t *)(tee_mm_entry_t *)$list->offset
		set $list = (tee_mm_entry_t *)$list->next
	end	
end
document walk_mmu_entry
	walk_mmu_entry <list>: Dumps the strings in a tee_mmu_entry
	entry->next
	entry->size
	entry->offset
	...
end
