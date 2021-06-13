final: hexdump.o other.o
	ld -m elf_i386 -o final hexdump.o ./other.o
hexdump.o: hexdump3.asm
	nasm -f elf -g -F DWARF -o hexdump.o hexdump3.asm
other.o: other.asm
	nasm -f elf -g -F DWARF -o other.o other.asm
