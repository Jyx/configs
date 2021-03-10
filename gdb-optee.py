import gdb
import os
import subprocess
import fnmatch
from threading import Thread, Lock

# All paths here have been verified and used with OP-TEE v3.9.0

# OP-TEE binaries
TEE_ELF                  = "optee_os/out/arm/core/tee.elf"

# Trusted applications
# optee_example
ACIPHER_TA_ELF           = "out-br/build/optee_examples_ext-1.0/acipher/ta/out/a734eed9-d6a1-4244-aa50-7c99719e7b7b.elf"
AES_TA_ELF               = "out-br/build/optee_examples_ext-1.0/aes/ta/out/5dbac793-f574-4871-8ad3-04331ec17f24.elf"
HELLO_WORLD_TA_ELF       = "out-br/build/optee_examples_ext-1.0/hello_world/ta/out/8aaaf200-2450-11e4-abe2-0002a5d5c51b.elf"
HOTP_TA_ELF              = "out-br/build/optee_examples_ext-1.0/hotp/ta/out/484d4143-2d53-4841-3120-4a6f636b6542.elf"
RANDOM_TA_ELF            = "out-br/build/optee_examples_ext-1.0/random/ta/out/b6c53aba-9669-4668-a7f2-205629d00f86.elf"
SECURE_STORAGE_TA_ELF    = "out-br/build/optee_examples_ext-1.0/secure_storage/ta/out/f4e750bb-1437-4fbf-8785-8d3580c34994.elf"

# optee_test
AES_PERF_TA_ELF          = "out-br/build/optee_test_ext-1.0/ta/aes_perf/out/e626662e-c0e2-485c-b8c8-09fbce6edf3d.elf"
CONCURRENT_LARGE_TA_ELF  = "out-br/build/optee_test_ext-1.0/ta/concurrent_large/out/5ce0c432-0ab0-40e5-a056-782ca0e6aba2.elf"
CONCURRENT_TA_ELF        = "out-br/build/optee_test_ext-1.0/ta/concurrent/out/e13010e0-2ae1-11e5-896a-0002a5d5c51b.elf"
CREATE_FAIL_TEST_TA_ELF  = "out-br/build/optee_test_ext-1.0/ta/create_fail_test/out/c3f6e2c0-3548-11e1-b86c-0800200c9a66.elf"
CRYPT_TA_ELF             = "out-br/build/optee_test_ext-1.0/ta/crypt/out/cb3e5ba0-adf1-11e0-998b-0002a5d5c51b.elf"
OS_TEST_LIB_TA_ELF       = "out-br/build/optee_test_ext-1.0/ta/os_test_lib/out/ffd2bded-ab7d-4988-95ee-e4962fff7154.elf"
OS_TEST_TA_ELF           = "out-br/build/optee_test_ext-1.0/ta/os_test/out/5b9e0e40-2636-11e1-ad9e-0002a5d5c51b.elf"
RPC_TEST_TA_ELF          = "out-br/build/optee_test_ext-1.0/ta/rpc_test/out/d17f73a0-36ef-11e1-984a-0002a5d5c51b.elf"
SDP_BASIC_TA_ELF         = "out-br/build/optee_test_ext-1.0/ta/sdp_basic/out/12345678-5b69-11e4-9dbb-101f74f00099.elf"
SHA_PERF_TA_ELF          = "out-br/build/optee_test_ext-1.0/ta/sha_perf/out/614789f2-39c0-4ebf-b235-92b32ac107ed.elf"
SIMS_TA_ELF              = "out-br/build/optee_test_ext-1.0/ta/sims/out/e6a33ed4-562b-463a-bb7e-ff5e15a493c8.elf"
SOCKET_TA_ELF            = "out-br/build/optee_test_ext-1.0/ta/socket/out/873bcd08-c2c3-11e6-a937-d0bf9c45c61c.elf"
STORAGE2_TA_ELF          = "out-br/build/optee_test_ext-1.0/ta/storage2/out/731e279e-aafb-4575-a771-38caa6f0cca6.elf"
STORAGE_BENCHMARK_TA_ELF = "out-br/build/optee_test_ext-1.0/ta/storage_benchmark/out/f157cda0-550c-11e5-a6fa-0002a5d5c51b.elf"
STORAGE_TA_ELF           = "out-br/build/optee_test_ext-1.0/ta/storage/out/b689f2a7-8adf-477a-9f99-32e90c0ad0a2.elf"

# Host applications
ACIPHER_HOST_ELF         = "out-br/build/optee_examples_ext-1.0/acipher/acipher"
AES_HOST_ELF             = "out-br/build/optee_examples_ext-1.0/aes/aes"
HELLO_WORLD_HOST_ELF     = "out-br/build/optee_examples_ext-1.0/hello_world/hello_world"
HOTP_HOST_ELF            = "out-br/build/optee_examples_ext-1.0/hotp/hotp"
RANDOM_HOST_ELF          = "out-br/build/optee_examples_ext-1.0/random/random"
SECURE_STORAGE_HOST_ELF  = "out-br/build/optee_examples_ext-1.0/secure_storage/secure_storage"
XTEST_HOST_ELF           = "out-br/build/optee_test_ext-1.0/host/xtest/xtest"

# TF-A binaries
BL1_ELF                  = "trusted-firmware-a/build/qemu/debug/bl1/bl1.elf"
BL2_ELF                  = "trusted-firmware-a/build/qemu/debug/bl2/bl2.elf"
BL31_ELF                 = "trusted-firmware-a/build/qemu/debug/bl31/bl31.elf"

# Linux kernel
LINUX_KERNEL_ELF         = "linux/vmlinux"

# U-Boot
UBOOT_ELF                = "u-boot/u-boot"

# By default OP-TEE has CFG_TA_ASLR=y, which means that the load address for
# the TA will be different every time the TA loads. The auto load feature in
# this script figure out the address automatically, but for the manual loading
# one need to set it explicitly, either here below or as an environment
# variable. However, that also means that you should set CFG_TA_ASLR=n when
# building optee_os for manually loaded TA's.
TA_LOAD_ADDR = "0x10d020"

# The TA_LOAD_ADDR exported as environment variable always has the final
# saying when doing a manual load.
if 'TA_LOAD_ADDR' in os.environ:
    TA_LOAD_ADDR = os.environ['TA_LOAD_ADDR']

# Main path to a OP-TEE project which can be overridden by exporting
# OPTEE_PROJ_PATH to another valid setup coming from build.git
# (see https://github.com/OP-TEE/build)
OPTEE_PROJ_PATH = "/media/jbech/TSHB_LINUX/devel/optee_projects/qemu"
if 'OPTEE_PROJ_PATH' in os.environ:
    OPTEE_PROJ_PATH = os.environ['OPTEE_PROJ_PATH']

###############################################################################
# Some global variables.
###############################################################################
TEE_LOADED = False

# Dictionary for the ldelf.elf
ldelf_loaded_symbols = {}

# Dictionary for the current TA in use.
ta_loaded_symbols = {}

# Dictionary containing timelow (key) and absolute path (value) to all TA's
# found under OPTEE_PROJ_PATH.
ta_path_cache = {}

###############################################################################
# Utility functions
###############################################################################


def read_segments(elf_file):
    """ Read segments from an ELF file into an array. """
    result = subprocess.check_output(("readelf -S " + elf_file).split(' '))
    result = result.split('\n')
    offsets = {}

    for line in result:
        tmp = line[line.find(' .'): line.find('\t')].split(' ')
        seg = [ln for ln in tmp if ln != ""]
        if seg != []:
            offsets[seg[0]] = seg[2]

    return offsets


def find_file(pattern, path):
    """ Recursively find files matching a certain pattern. """
    result = []
    for root, dirs, files in os.walk(path):
        for name in files:
            if fnmatch.fnmatch(name, pattern):
                result.append(os.path.join(root, name))
    return result


def cache_ta_paths():
    """ Finds a and cache all ELF-files under the buildroot folder """
    ta_list = find_file("*.elf", OPTEE_PROJ_PATH + "/out-br")
    for ta in ta_list:
        # We don't want the stripped ones.
        if 'stripped' not in ta:
            timelow = os.path.basename(ta)[:8]
            ta_path_cache[timelow] = ta


cache_ta_paths()


def auto_load_ta():
    """ Loads TA's when the helper breakpoint in ldelf is hit. """
    global ta_loaded_symbols
    global ta_path_cache

    if "elf" in ta_loaded_symbols:
        gdb.post_event(Executor("continue"))
        return

    ta_load_addr = gdb.parse_and_eval("ta_load_addr")
    timelow = gdb.parse_and_eval("uuid->timeLow")
    # Strip away 0x
    timelow = str(timelow)[2:]
    ta_elf = None
    if timelow in ta_path_cache:
        ta_elf = ta_path_cache[timelow]
    else:
        print("No TA's in cache")

    ta_loaded_symbols["elf"] = ta_elf

    segments = read_segments(ta_elf)
    ta_load_addr = int(ta_load_addr)

    ta_loaded_symbols[".text"] = hex(ta_load_addr
                                     + int(segments['.text'], 16))
    ta_loaded_symbols[".rodata"] = hex(ta_load_addr
                                       + int(segments['.rodata'], 16))
    ta_loaded_symbols[".data"] = hex(ta_load_addr
                                     + int(segments['.data'], 16))
    ta_loaded_symbols[".bss"] = hex(ta_load_addr
                                    + int(segments['.bss'], 16))

    gdb.execute("add-symbol-file {} {} -s .rodata {} -s .data {} -s .bss {}"
                .format(ta_elf,
                        ta_loaded_symbols[".text"],
                        ta_loaded_symbols[".rodata"],
                        ta_loaded_symbols[".data"],
                        ta_loaded_symbols[".bss"]))
    gdb.execute("tb TA_InvokeCommandEntryPoint")
    gdb.post_event(Executor("continue"))

mutex = Lock()

def auto_load_ldelf():
    """ Loads ldelf when the helper breakpoint in TEE core is hit. """
    global OPTEE_PROJ_PATH
    global ta_loaded_symbols
    global ldelf_loaded_symbols
    global mutex

    mutex.acquire()

    try:
        # Clear out old TA's that has previously been auto-loaded.
        if "elf" in ta_loaded_symbols:
            gdb.execute("remove-symbol-file {}".format(ta_loaded_symbols["elf"]))
            ta_loaded_symbols.clear()

        if "ldelf.elf" in ldelf_loaded_symbols:
            gdb.post_event(Executor("continue"))
            return

        print("Loading LDELF symbols for OP-TEE")
        if "ldelf.elf" not in ldelf_loaded_symbols:
            ldelf = find_file("ldelf.elf", OPTEE_PROJ_PATH + "/optee_os")
            if ldelf is None or len(ldelf) != 1:
                print("Couldn't find ldelf.elf (or found too many)!")
                return
            # We want it as a string and not as an array.
            ldelf_loaded_symbols["ldelf.elf"] = ldelf[0]

        print(ldelf_loaded_symbols["ldelf.elf"])

        ldelf_addr = gdb.parse_and_eval("ldelf_addr")
        print("LDELF load address: {}".format(ldelf_addr))

        segments = read_segments(ldelf_loaded_symbols["ldelf.elf"])
        ldelf_addr = int(ldelf_addr)

        ldelf_loaded_symbols[".text"] = hex(ldelf_addr
                                            + int(segments['.text'], 16))
        ldelf_loaded_symbols[".rodata"] = hex(ldelf_addr
                                              + int(segments['.rodata'], 16))
        ldelf_loaded_symbols[".data"] = hex(ldelf_addr
                                            + int(segments['.data'], 16))
        ldelf_loaded_symbols[".bss"] = hex(ldelf_addr
                                           + int(segments['.bss'], 16))

        # Segments retrieved are explicitly loaded
        gdb.execute("add-symbol-file {} {} -s .rodata {} -s .data {} -s .bss {}"
                    .format(ldelf_loaded_symbols["ldelf.elf"],
                            ldelf_loaded_symbols[".text"],
                            ldelf_loaded_symbols[".rodata"],
                            ldelf_loaded_symbols[".data"],
                            ldelf_loaded_symbols[".bss"]))
        gdb.execute("b gdb_ldelf_helper")
    finally:
        mutex.release()

    gdb.post_event(Executor("continue"))


def load_tee():
    """ Helper function that loads TEE core. """
    global TEE_LOADED

    if TEE_LOADED:
        return

    print("Loading TEE core symbols for OP-TEE!")
    gdb.execute("symbol-file {}/{}".format(OPTEE_PROJ_PATH, TEE_ELF))
    TEE_LOADED = True


###############################################################################
# Setup up handlers for stop events
###############################################################################

class Executor:
    """ Helper class to post and execute commands using GDB events. """
    def __init__(self, cmd):
        self.__cmd = cmd

    def __call__(self):
        gdb.execute(self.__cmd)


def stop_handler(event):
    """ Handler function that gets called when a breakpoint is hit. """
    if isinstance(event, gdb.BreakpointEvent):
        try:
            if event.breakpoint.location == "gdb_helper":
                print("Calling auto_load_ldelf")
                auto_load_ldelf()
            elif event.breakpoint.location == "gdb_ldelf_helper":
                print("Calling auto_load_ta")
                auto_load_ta()
            else:
                pass
        except RuntimeError:
            pass
    else:
        pass


def register_event_handler():
    """ Helper function that registers the event handler for stop events. """
    gdb.events.stop.connect(stop_handler)


register_event_handler()

###############################################################################
# User created GDB commands
###############################################################################


class Connect(gdb.Command):
    """ Command that connects to the QEMU stub. """
    def __init__(self):
        super(Connect, self).__init__("connect", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        # Default to the QEMU stub
        remote = "127.0.0.1:1234"
        name = "QEMU gdb stub"

        # For debugging on the remote device
        if arg == "gdbserver":
            remote = "127.0.0.1:12345"
            name = "gdbserver"

        print("Connecting to {} at {}".format(name, remote))
        gdb.execute("target remote {}".format(remote))

    def complete(self, text, word):
        # Sync the array with invoke
        candidates = ['qemu', 'gdbserver']
        return filter(lambda candidate: candidate.startswith(word), candidates)


Connect()


class LoadOPTEE(gdb.Command):
    """ Command that loads TEE core symbols. """
    def __init__(self):
        super(LoadOPTEE, self).__init__("load_tee", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        load_tee()
        gdb.execute("b tee_entry_std")


LoadOPTEE()


class AutoLoadTA(gdb.Command):
    """ Command that enables automatic loading of symbols for TA's. """
    def __init__(self):
        super(AutoLoadTA, self).__init__("auto_load_ta", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        print("Automatically try to load TA's")

        if arg == "on" or arg == "":
            load_tee()
            gdb.execute("b gdb_helper")
        elif arg == "off":
            # Remove breakpoints, unload
            bp = gdb.execute("info b", to_string=True)
            if "gdb_helper" in bp:
                gdb.execute("clear gdb_helper")
            if "gdb_ldelf_helper" in bp:
                gdb.execute("clear gdb_ldelf_helper")
                if "ldelf.elf" in ldelf_loaded_symbols:
                    gdb.execute("remove-symbol-file {}".format(
                        ldelf_loaded_symbols["ldelf.elf"]))
        else:
            print("Unknown argument!")

    def complete(self, text, word):
        # Sync the array with invoke
        candidates = ['on', 'off']
        return filter(lambda candidate: candidate.startswith(word), candidates)


AutoLoadTA()


class LoadTA(gdb.Command):
    """ Command that manually loads TA's symbols. """
    def __init__(self):
        super(LoadTA, self).__init__("load_ta", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        try:
            print("Loading symbols for '{}' Trusted Application".format(arg))
            ta = None
            # optee_example
            if arg == "acipher":
                ta = ACIPHER_TA_ELF
            elif arg == "aes":
                ta = AES_TA_ELF
            elif arg == "hello_world":
                ta = HELLO_WORLD_TA_ELF
            elif arg == "hotp":
                ta = HOTP_TA_ELF
            elif arg == "random":
                ta = RANDOM_ELF
            elif arg == "secure_storage":
                ta = SECURE_STORAGE_TA_ELF

            # optee_test
            elif arg == "aes_perf":
                ta = AES_PERF_TA_ELF
            elif arg == "concurrent_large":
                ta = CONCURRENT_LARGE_TA_EL
            elif arg == "concurrent":
                ta = CONCURRENT_TA_ELF
            elif arg == "create_fail_test":
                ta = CREATE_FAIL_TEST_TA_ELF
            elif arg == "crypt":
                ta = CRYPT_TA_ELF
            elif arg == "os_test_lib_ta":
                ta = OS_TEST_LIB_TA_ELF
            elif arg == "os_test":
                ta = OS_TEST_TA_ELF
            elif arg == "sdp_basic":
                ta = SDP_BASIC_TA_ELF
            elif arg == "rpc_test":
                ta = RPC_TEST_TA_ELF
            elif arg == "sha_perf":
                ta = SHA_PERF_TA_ELF
            elif arg == "sims":
                ta = SIMS_TA_ELF
            elif arg == "socket":
                ta = SOCKET_TA_ELF
            elif arg == "storage2":
                ta = STORAGE2_TA_ELF
            elif arg == "storage_benchmark":
                ta = STORAGE_BENCHMARK_TA_ELF
            elif arg == "storage":
                ta = STORAGE_TA_ELF
            else:
                print("Unknown TA!")
                return

            gdb.execute("add-symbol-file {}/{} {}".format(
                OPTEE_PROJ_PATH, ta, TA_LOAD_ADDR))

            gdb.execute("b TA_InvokeCommandEntryPoint")

        except IndexError:
            print("No TA specified")

    def complete(self, text, word):
        # Sync the array(s) with invoke
        optee_example = [
                'acipher', 'aes', 'hello_world', 'hotp', 'random',
                'secure_storage'
                ]
        optee_test = [
                'aes_perf', 'concurrent', 'concurrent_large',
                'create_fail_test', 'crypt', 'os_test', 'os_test_lib',
                'rpc_test', 'sdp_basic', 'sha_perf', 'sims', 'socket',
                'storage', 'storage2', 'storage_benchmark'
                ]
        candidates = optee_example + optee_test
        return filter(lambda candidate: candidate.startswith(word), candidates)


LoadTA()


class LoadHost(gdb.Command):
    """ Command that manually loads the user space applications symbols. """
    def __init__(self):
        super(LoadHost, self).__init__("load_host", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        try:
            print("Loading symbols for '{}' Trusted Application".format(arg))
            binary = None
            if arg == "acipher":
                binary = ACIPHER_HOST_ELF
            elif arg == "aes":
                binary = AES_HOST_ELF
            elif arg == "hello_world":
                binary = HELLO_WORLD_HOST_ELF
            elif arg == "hotp":
                binary = HOTP_HOST_ELF
            elif arg == "random":
                binary = RANDOM_HOST_ELF
            elif arg == "secure_storage":
                binary = SECURE_STORAGE_HOST_ELF
            elif arg == "xtest":
                binary = XTEST_HOST_ELF
            else:
                print("Unknown host binary!")
                return
            gdb.execute("symbol-file {}/{}".format(OPTEE_PROJ_PATH, binary))

            # FIXME: This must be updated to support QEMU v8 for example (path
            # ...)
            gdb.execute("set sysroot {}/{}".format(
                OPTEE_PROJ_PATH,
                "out-br/host/arm-buildroot-linux-gnueabihf/sysroot"))
            gdb.execute("b main")

        except IndexError:
            print("No host binary specified")

    def complete(self, text, word):
        # Sync the array with invoke
        candidates = [
                'acipher', 'hello_world', 'hotp', 'random', 'secure_storage',
                'xtest'
                ]
        return filter(lambda candidate: candidate.startswith(word), candidates)


LoadHost()


class LoadTFA(gdb.Command):
    """ Command that manually loads TrustedFirmare symbols. """
    def __init__(self):
        super(LoadTFA, self).__init__("load_tfa", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        try:
            print("Loading symbols for Trusted Firmware A from '{}'"
                  .format(arg))
            binary = None
            if arg == "bl1":
                binary = BL1_ELF
            elif arg == "bl2":
                binary = BL2_ELF
            elif arg == "bl31":
                binary = BL31_ELF
            else:
                print("Unknown/unspecified TF-A binary!")
                return
            gdb.execute("symbol-file {}/{}".format(OPTEE_PROJ_PATH, binary))

            if binary == BL1_ELF:
                gdb.execute("b bl1_entrypoint")
                gdb.execute("b bl1_main")
            elif binary == BL2_ELF:
                gdb.execute("b bl2_entrypoint")
                gdb.execute("b bl2_main")
            elif binary == BL31_ELF:
                gdb.execute("b bl31_entrypoint")
                gdb.execute("b bl31_main")
                gdb.execute("b opteed_setup")
                gdb.execute("b opteed_init")
                gdb.execute("b opteed_smc_handler")

        except IndexError:
            print("No TF-A binary specified")

    def complete(self, text, word):
        # Sync the array with invoke
        candidates = ['bl1', 'bl2', 'bl31']
        return filter(lambda candidate: candidate.startswith(word), candidates)


LoadTFA()


class LoadLinux(gdb.Command):
    """ Command that manually loads Linux kernel symbols. """
    def __init__(self):
        super(LoadLinux, self).__init__("load_linux", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        print("Loading symbols for Linux kernel")
        gdb.execute("symbol-file {}/{}".format(
            OPTEE_PROJ_PATH, LINUX_KERNEL_ELF))
        gdb.execute("b tee_init")
        gdb.execute("b optee_do_call_with_arg")
        gdb.execute("b optee_probe")


LoadLinux()


class LoadUBoot(gdb.Command):
    """ Command that manually loads U-Boot symbols. """
    def __init__(self):
        super(LoadUBoot, self).__init__("load_uboot", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        print("Loading symbols for U-Boot")
        gdb.execute("symbol-file {}/{}".format(OPTEE_PROJ_PATH, UBOOT_ELF))
        gdb.execute("b _main")


LoadUBoot()


class OPTEECmd(gdb.Command):
    """ Command for OP-TEE utility functions. """
    def __init__(self):
        super(OPTEECmd, self).__init__("optee-stat", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        if arg == "memstat":
            range_vars = [
                    ("CFG_SHMEM_START", "CFG_SHMEM_SIZE"),
                    ("CFG_TZDRAM_START", "CFG_TZDRAM_SIZE")
                    ]

            print("\n{:30}  {}\n{}".format("TYPE", "START-END (size)", "-"*80))
            for var in sorted(range_vars):
                start = gdb.parse_and_eval(var[0])
                size = gdb.parse_and_eval(var[1])
                print("{:30}: 0x{:08x}-0x{:08x} (0x{:08x}, {})".format(
                      var[0],
                      int(str(start), 16),
                      int(str(start + size), 16),
                      int(str(size), 16),
                      str(size/float(1 << 20)) + " MB"))

            single_vars = [
                    "CFG_CORE_HEAP_SIZE",
                    "CFG_LPAE_ADDR_SPACE_SIZE",
                    "CFG_TEE_RAM_VA_SIZE",
                    "CFG_CORE_NEX_HEAP_SIZE",
                    "CFG_DTB_MAX_SIZE",
                    "CFG_RESERVED_VASPACE_SIZE",
                    "CFG_TEE_SDP_MEM_SIZE"
                    ]

            print("\n{:30}  {}\n{}".format("TYPE", "SIZE", "-"*80))
            for cfg in sorted(single_vars):
                val = gdb.parse_and_eval(cfg)
                print("{:30}: {:16} {}".format(
                      cfg, val, str(val/float(1 << 20)) + " MB"))

    def complete(self, text, word):
        # Sync the array with invoke
        candidates = ['memstat']
        return filter(lambda candidate: candidate.startswith(word), candidates)


OPTEECmd()


class TEECoreLinkedListPrinter(gdb.Command):
    """Prints the ListNode from our example in a nice format!"""
    def __init__(self):
        super(TEECoreLinkedListPrinter, self).__init__("tee-ll-dump", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        if arg == "tee_open_sessions":
            node_ptr = gdb.parse_and_eval("tee_open_sessions.tqh_first")
            count = 0
            while node_ptr != 0:
                uuid = node_ptr['clnt_id']['uuid']
                print("{:3}: {:16} {:10}-{:6}-{:6}-{}".format(
                      count,
                      "uuid:",
                      uuid['timeLow'],
                      uuid['timeMid'],
                      uuid['timeHiAndVersion'],
                      uuid['clockSeqAndNode']))

                ctx_uuid = node_ptr['ctx']['uuid']
                print("{:4} {:16} {:10}-{:6}-{:6}-{}".format(
                      "",
                      "ctx->uuid:",
                      ctx_uuid['timeLow'],
                      ctx_uuid['timeMid'],
                      ctx_uuid['timeHiAndVersion'],
                      ctx_uuid['clockSeqAndNode']))
                node_ptr = node_ptr['link']['tqe_next']
                count += 1
            node_ptr = None

    def complete(self, text, word):
        # Sync the array with invoke
        candidates = ['tee_open_sessions']
        return filter(lambda candidate: candidate.startswith(word), candidates)


TEECoreLinkedListPrinter()
