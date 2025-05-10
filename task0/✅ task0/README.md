# 🧪 Task 0 – C & Assembly Integration

### Task 0.A
- Hybrid program combining C (`main.c`, `util.c`) and NASM (`start.s`)
- Objective: Print command-line arguments using only system calls

### Task 0.B
- Standalone NASM program
- Prints `"hello world\n"` using direct `int 0x80` syscall
- No linking with C code

### Compilation
```bash
make  # see Makefile
