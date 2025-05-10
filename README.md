# 🔬 Lab 3 – System Programming: Assembly, System Calls, and File Infection

This lab explores low-level programming in Linux using system calls, inline assembly, and ELF file manipulation — written entirely without using the C standard library.

---

## 🧭 Table of Contents

- [Task 0.A – Hybrid Startup](#task-0a--hybrid-startup)
- [Task 0.B – Assembly Hello World](#task-0b--assembly-hello-world)
- [Task 1 – Command-Line Encoder](#task-1--command-line-encoder)
- [Task 2 – Virus Attachment](#task-2--virus-attachment)
- [How to Build](#how-to-build)
- [How to Run](#how-to-run)
- [Credits](#credits)

---

## 📦 Task 0.A – Hybrid Startup

- **Description**: Compile and link C code (`main.c`, `util.c`) with assembly glue (`start.s`) to build a program that prints all command-line arguments **without using the standard C library**.
- **Goal**: Practice low-level linking and the CDECL calling convention.

---

## ⚙️ Task 0.B – Assembly Hello World

- **Description**: A standalone `.s` file written in NASM that directly performs a `write` syscall using `int 0x80` to print `"hello world\n"` to standard output.
- **Goal**: Understand system call usage and manual syscall argument passing.

---

## 🧾 Task 1 – Command-Line Encoder

- **Description**: A mini program written entirely in assembly that:
  - Prints all command-line arguments to `stderr`
  - Encodes characters from `stdin` by shifting uppercase letters one step back (e.g., `B` → `A`)
  - Writes the result to `stdout` or a specified file
- **Supports flags**:
  - `-i{filename}`: Read from file
  - `-o{filename}`: Write to file

- **Goal**: Practice file handling, I/O redirection, pointer arithmetic, and simple character transformations using only system calls.

---

## 🦠 Task 2 – Virus Attachment

- **Description**: A simulated virus written in C + assembly that:
  - Lists files in the current directory using the `getdents` syscall
  - Optionally infects files starting with a prefix (`-a{prefix}`)
  - Appends custom payload code to each infected file
  - Payload prints `"Hello, Infected File"` when executed

- **Assembly components**:
  - `infection`: the message-printing payload
  - `infector`: appends payload to ELF executables
  - `code_start` → `code_end`: define the binary range copied into targets

- **Goal**: Simulate how self-replicating code (like real-world viruses) appends itself to binaries.

---

## 🔧 How to Build

```bash
make clean
make
