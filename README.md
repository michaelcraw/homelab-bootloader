# homelab-bootloader

A 512-byte x86 bootloader written in NASM that runs directly from BIOS and displays the status of my homelab fleet.

This project runs with **no operating system** — it executes in real mode immediately after the BIOS loads it into memory.

---

## What this does

When the system boots, this bootloader:

- Switches to 80x25 text mode
- Clears the screen
- Prints a custom “homelab fleet dashboard”
- Halts the CPU

---

## How it works

- The BIOS loads the first 512 bytes of the disk into memory at `0x7C00`
- Execution begins in **16-bit real mode**
- BIOS interrupts (`int 0x10`) are used for:
  - Screen control
  - Cursor positioning
  - Character output
- A custom `print_string` function prints a null-terminated string from memory
- The program then halts using `hlt` in an infinite loop

---

## Build

Assemble the bootloader using NASM:

```bash
nasm -f bin boot.asm -o boot.bin
