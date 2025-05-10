all: task2

task2: start.o util.o task2.o
	ld -m elf_i386 start.o task2.o util.o -o task2

start.o: start.s
	nasm -f elf32 start.s -o start.o

task2.o: task2.c
	gcc -m32 -Wall -ansi -c -nostdlib -fno-stack-protector task2.c -o task2.o

util.o: util.c
	gcc -m32 -Wall -ansi -c -nostdlib -fno-stack-protector util.c -o util.o

 
.PHONY: clean
clean:
	rm -f *.o task2