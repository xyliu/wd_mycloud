%title config partition

# binary 

  2 binaries: config_md0.img config_md1.img

# Analysis
## hexdump

	{{{
	$ hexdump -C config_md0.img
	00000000  79 ba 8f 79 00 00 00 00  87 33 8f 20 1c 02 00 00  |y..y.....3. ....|
	00000010  00 00 00 00 00 00 00 00  e6 be 0f f8 8d c7 a8 67  |...............g|
	00000020  0a 02 00 00 01 00 00 00  00 00 00 00 23 21 2f 62  |............#!/b|
	00000030  69 6e 2f 73 68 0a 23 23  20 42 75 74 74 6f 6e 20  |in/sh.## Button |
	00000040  69 6e 69 74 69 61 6c 20  73 74 61 74 65 0a 62 74  |initial state.bt|
	00000050  6e 5f 73 74 61 74 75 73  3d 30 0a 67 65 74 5f 62  |n_status=0.get_b|
	00000060  75 74 74 6f 6e 5f 73 74  61 74 75 73 0a 73 61 74  |utton_status.sat|
	00000070  61 20 0a 73 61 74 61 70  61 72 74 20 30 78 33 30  |a .satapart 0x30|
	00000080  30 38 30 30 30 20 35 20  30 78 35 30 30 30 0a 73  |08000 5 0x5000.s|
	00000090  61 74 61 20 73 74 6f 70  0a 23 20 54 68 69 73 20  |ata stop.# This |
	000000a0  69 73 20 63 75 73 74 6f  6d 69 7a 65 64 20 66 6f  |is customized fo|
	000000b0  72 20 65 61 63 68 20 65  6e 76 69 72 6f 6e 6d 65  |r each environme|
	000000c0  6e 74 20 76 61 72 69 61  62 6c 65 20 73 63 72 69  |nt variable scri|
	000000d0  70 74 0a 62 6f 6f 74 61  72 67 73 3d 22 63 6f 6e  |pt.bootargs="con|
	000000e0  73 6f 6c 65 3d 74 74 79  53 30 2c 31 31 35 32 30  |sole=ttyS0,11520|
	000000f0  30 6e 38 2c 20 69 6e 69  74 3d 2f 73 62 69 6e 2f  |0n8, init=/sbin/|
	00000100  69 6e 69 74 22 0a 62 6f  6f 74 61 72 67 73 3d 22  |init".bootargs="|
	00000110  24 62 6f 6f 74 61 72 67  73 20 72 6f 6f 74 3d 2f  |$bootargs root=/|
	00000120  64 65 76 2f 6d 64 30 20  72 61 69 64 3d 61 75 74  |dev/md0 raid=aut|
	00000130  6f 64 65 74 65 63 74 22  0a 62 6f 6f 74 61 72 67  |odetect".bootarg|
	00000140  73 3d 22 24 62 6f 6f 74  61 72 67 73 20 72 6f 6f  |s="$bootargs roo|
	00000150  74 66 73 74 79 70 65 3d  65 78 74 33 20 72 77 20  |tfstype=ext3 rw |
	00000160  6e 6f 69 6e 69 74 72 64  20 64 65 62 75 67 20 69  |noinitrd debug i|
	00000170  6e 69 74 63 61 6c 6c 5f  64 65 62 75 67 20 73 77  |nitcall_debug sw|
	00000180  61 70 61 63 63 6f 75 6e  74 3d 31 20 70 61 6e 69  |apaccount=1 pani|
	00000190  63 3d 33 22 0a 62 6f 6f  74 61 72 67 73 3d 22 24  |c=3".bootargs="$|
	000001a0  62 6f 6f 74 61 72 67 73  20 6d 61 63 5f 61 64 64  |bootargs mac_add|
	000001b0  72 3d 24 65 74 68 30 2e  65 74 68 61 64 64 72 22  |r=$eth0.ethaddr"|
	000001c0  0a 62 6f 6f 74 61 72 67  73 3d 22 24 62 6f 6f 74  |.bootargs="$boot|
	000001d0  61 72 67 73 20 6d 6f 64  65 6c 3d 24 6d 6f 64 65  |args model=$mode|
	000001e0  6c 20 73 65 72 69 61 6c  3d 24 73 65 72 69 61 6c  |l serial=$serial|
	000001f0  20 62 6f 61 72 64 5f 74  65 73 74 3d 24 62 6f 61  | board_test=$boa|
	00000200  72 64 5f 74 65 73 74 20  62 74 6e 5f 73 74 61 74  |rd_test btn_stat|
	00000210  75 73 3d 24 62 74 6e 5f  73 74 61 74 75 73 22 0a  |us=$btn_status".|
	00000220  62 6f 6f 74 6d 20 2f 64  65 76 2f 6d 65 6d 2e 75  |bootm /dev/mem.u|
	00000230  49 6d 61 67 65 0a 00 00  00 00 00 00 00 00 00 00  |Image...........|
	00000240  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
	*
	00000400  e5 e5 e5 e5 e5 e5 e5 e5  e5 e5 e5 e5 e5 e5 e5 e5  |................|
	*
	00100000
	}}}

	{{{
	$ hexdump -C config_md1.img
	00000000  79 ba 8f 79 00 00 00 00  9a b1 73 9b 1c 02 00 00  |y..y......s.....|
	00000010  00 00 00 00 00 00 00 00  1a 39 50 f2 8d c7 a8 67  |.........9P....g|
	00000020  0a 02 00 00 01 00 00 00  00 00 00 00 23 21 2f 62  |............#!/b|
	00000030  69 6e 2f 73 68 0a 23 23  20 42 75 74 74 6f 6e 20  |in/sh.## Button |
	00000040  69 6e 69 74 69 61 6c 20  73 74 61 74 65 0a 62 74  |initial state.bt|
	00000050  6e 5f 73 74 61 74 75 73  3d 30 0a 67 65 74 5f 62  |n_status=0.get_b|
	00000060  75 74 74 6f 6e 5f 73 74  61 74 75 73 0a 73 61 74  |utton_status.sat|
	00000070  61 20 0a 73 61 74 61 70  61 72 74 20 30 78 33 30  |a .satapart 0x30|
	00000080  30 38 30 30 30 20 35 20  30 78 35 30 30 30 0a 73  |08000 5 0x5000.s|
	00000090  61 74 61 20 73 74 6f 70  0a 23 20 54 68 69 73 20  |ata stop.# This |
	000000a0  69 73 20 63 75 73 74 6f  6d 69 7a 65 64 20 66 6f  |is customized fo|
	000000b0  72 20 65 61 63 68 20 65  6e 76 69 72 6f 6e 6d 65  |r each environme|
	000000c0  6e 74 20 76 61 72 69 61  62 6c 65 20 73 63 72 69  |nt variable scri|
	000000d0  70 74 0a 62 6f 6f 74 61  72 67 73 3d 22 63 6f 6e  |pt.bootargs="con|
	000000e0  73 6f 6c 65 3d 74 74 79  53 30 2c 31 31 35 32 30  |sole=ttyS0,11520|
	000000f0  30 6e 38 2c 20 69 6e 69  74 3d 2f 73 62 69 6e 2f  |0n8, init=/sbin/|
	00000100  69 6e 69 74 22 0a 62 6f  6f 74 61 72 67 73 3d 22  |init".bootargs="|
	00000110  24 62 6f 6f 74 61 72 67  73 20 72 6f 6f 74 3d 2f  |$bootargs root=/|
	00000120  64 65 76 2f 6d 64 31 20  72 61 69 64 3d 61 75 74  |dev/md1 raid=aut|
	00000130  6f 64 65 74 65 63 74 22  0a 62 6f 6f 74 61 72 67  |odetect".bootarg|
	00000140  73 3d 22 24 62 6f 6f 74  61 72 67 73 20 72 6f 6f  |s="$bootargs roo|
	00000150  74 66 73 74 79 70 65 3d  65 78 74 33 20 72 77 20  |tfstype=ext3 rw |
	00000160  6e 6f 69 6e 69 74 72 64  20 64 65 62 75 67 20 69  |noinitrd debug i|
	00000170  6e 69 74 63 61 6c 6c 5f  64 65 62 75 67 20 73 77  |nitcall_debug sw|
	00000180  61 70 61 63 63 6f 75 6e  74 3d 31 20 70 61 6e 69  |apaccount=1 pani|
	00000190  63 3d 33 22 0a 62 6f 6f  74 61 72 67 73 3d 22 24  |c=3".bootargs="$|
	000001a0  62 6f 6f 74 61 72 67 73  20 6d 61 63 5f 61 64 64  |bootargs mac_add|
	000001b0  72 3d 24 65 74 68 30 2e  65 74 68 61 64 64 72 22  |r=$eth0.ethaddr"|
	000001c0  0a 62 6f 6f 74 61 72 67  73 3d 22 24 62 6f 6f 74  |.bootargs="$boot|
	000001d0  61 72 67 73 20 6d 6f 64  65 6c 3d 24 6d 6f 64 65  |args model=$mode|
	000001e0  6c 20 73 65 72 69 61 6c  3d 24 73 65 72 69 61 6c  |l serial=$serial|
	000001f0  20 62 6f 61 72 64 5f 74  65 73 74 3d 24 62 6f 61  | board_test=$boa|
	00000200  72 64 5f 74 65 73 74 20  62 74 6e 5f 73 74 61 74  |rd_test btn_stat|
	00000210  75 73 3d 24 62 74 6e 5f  73 74 61 74 75 73 22 0a  |us=$btn_status".|
	00000220  62 6f 6f 74 6d 20 2f 64  65 76 2f 6d 65 6d 2e 75  |bootm /dev/mem.u|
	00000230  49 6d 61 67 65 0a 00 00  00 00 00 00 00 00 00 00  |Image...........|
	00000240  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
	*
	00000400  e5 e5 e5 e5 e5 e5 e5 e5  e5 e5 e5 e5 e5 e5 e5 e5  |................|
	*
	00100000
	}}}

##  uboot 

{{{
#!/bin/sh
## Button initial state
btn_status=0
get_button_status
sata
satapart 0x30 08000 5 0x5000
sata stop
# This is customized for each environment variable script
bootargs="console=ttyS0,115200n8, init=/sbin/init"
bootargs="$bootargs root=/dev/md0 raid=autodetect"
bootargs="$bootargs rootfstype=ext3 rw noinitrd debug initcall_debug sw apaccount=1 panic=3"
bootargs="$bootargs mac_addr=$eth0.ethaddr"
bootargs="$bootargs model=$model serial=$serial board_test=$board_test btn_status=$btn_status"
bootm /dev/mem.uImage
}}}


{{{
#!/bin/sh.
## Button initial state
btn_status=0
get_button_status
sata
satapart 0x30 08000 5 0x5000
sata stop
# This is customized for each environment variable script
bootargs="console=ttyS0,115200n8, init=/sbin/init"
bootargs="$bootargs root=/dev/md1 raid=autodetect"
bootargs="$bootargs rootfstype=ext3 rw noinitrd debug initcall_debug sw apaccount=1 panic=3"
bootargs="$bootargs mac_addr=$eth0.ethaddr"
bootargs="$bootargs model=$model serial=$serial board_test=$board_test btn_status=$btn_status"
bootm /dev/mem.uImage
}}}
