all: task1 

##################################
# Task 1 - Assembly + util
##################################
task1: task1.o util.o
	ld -m elf_i386 task1.o util.o -o task1

task1.o: task1.s
	nasm -f elf32 task1.s -o task1.o

##################################
# Cleanup
##################################
.PHONY: clean
clean:
	rm -f *.o  task1 