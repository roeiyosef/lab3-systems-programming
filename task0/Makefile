all: task0a task0b 

##################################
# Task 0.A - Hybrid (start + main + util)
##################################
task0a: start.o main.o util.o
	ld -m elf_i386 start.o main.o util.o -o task0a

start.o: start.s
	nasm -f elf32 start.s -o start.o

main.o: main.c
	gcc -m32 -Wall -ansi -c -nostdlib -fno-stack-protector main.c -o main.o

util.o: util.c
	gcc -m32 -Wall -ansi -c -nostdlib -fno-stack-protector util.c -o util.o

##################################
# Task 0.B - Standalone Assembly
##################################
task0b: task0b.o
	ld -m elf_i386 task0b.o -o task0b

task0b.o: task0b.s
	nasm -f elf32 task0b.s -o task0b.o


##################################
# Cleanup
##################################
.PHONY: clean
clean:
	rm -f *.o task0a task0b