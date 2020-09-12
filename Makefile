all:
	# Dependency
	[ -e Bootloader.asm ] || curl -o Bootloader.asm "https://raw.githubusercontent.com/BestsoftCorporation/Bestsoft-OS/1197f4f78d04ccbe33eeb87fb13e658cc767c098/Bootloader.asm"
	
	[ -e PurePress.flp ] || mkdosfs -C PurePress.flp 1440
	nasm -O0 -w+orphan-labels -f bin -o  bootloader.bin Bootloader.asm
	nasm -O0 -w+orphan-labels -f bin -o kernel.bin Kernel.asm
	dd status=noxfer conv=notrunc if=bootloader.bin of=PurePress.flp
	[ -e iso-dir ] || mkdir iso-dir && mount -o loop -t vfat PurePress.flp iso-dir && cp kernel.bin iso-dir/
	sleep 1.0
	umount iso-dir
	mkisofs -V 'PUREPRESSOS' -input-charset iso8859-1 -o PurePress.iso -b PurePress.flp ./ 
	# Done!
clean:
	rm -rf iso-dir
	rm -f *.flp
	rm -f *.bin

