# Custom Linker Script and Memory Layout Verification (ARM Cortex-M4)

## 1. Project Overview

This project focuses on designing and verifying a custom linker script as part of a Bare-Metal Board Support Package (BSP).

The goal is to control how different sections of a program are placed in memory and validate their correctness using ELF inspection tools.

Target Memory Configuration:
- FLASH : 256 KB starting at 0x08000000
- RAM   : 64 KB starting at 0x20000000 

---

## 2. Design of the Project

### 2.1 Memory Layout

| Section        | Location | Description |
|----------------|----------|------------|
| .isr_vector    | FLASH    | Interrupt vector table |
| .text          | FLASH    | Program instructions and constants |
| .data          | RAM      | Initialized variables (loaded from FLASH) |
| .bss           | RAM      | Uninitialized variables (zero initialized) |

---

### 2.2 Execution Flow

1. System Reset occurs  
2. Stack Pointer is loaded from vector table  
3. Reset_Handler executes (startup code)  
4. `.data` is copied from FLASH to RAM  
5. `.bss` is initialized to zero  
6. Control jumps to `main()`  

---

### 2.3 Key Concepts

- Custom linker script design  
- Section placement control  
- VMA (Virtual Memory Address) vs LMA (Load Memory Address)  
- Startup initialization process  
- ELF file verification  

---

## 3. Environment Setup (Linux)

### 3.1 Install Required Packages

```bash
sudo apt-get update
sudo apt-get install gcc-arm-none-eabi binutils-arm-none-eabi
````

---

### 3.2 Create Project Directory

```bash
cd ~
mkdir custom_linker_lab
cd custom_linker_lab
```

---

### 3.3 Project Files

Ensure the following files are present:

```
linker.ld
startup.c
main.c
```

---

## 4. Build Process

Compile the project using the custom linker script:

```bash
arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -nostartfiles -T linker.ld startup.c main.c -o firmware.elf
```

---

## 5. Verify Output (Section Mapping)

Use the following command:

```bash
arm-none-eabi-readelf -S firmware.elf
```

---

## 6. Expected Output

```
There are 10 section headers, starting at offset ...

Section Headers:
[Nr] Name          Type       Addr       Off      Size     ES Flg Lk Inf Al
[ 1] .isr_vector   PROGBITS   08000000   010000   000008   00  A  0   0  4
[ 2] .text         PROGBITS   08000008   010008   000074   00 AX  0   0  4
[ 3] .data         PROGBITS   20000000   020000   000004   00 WA  0   0  4
[ 4] .bss          NOBITS     20000004   020004   000004   00 WA  0   0  4
```

---

## 7. Detailed Output Explanation

### 7.1 .isr_vector

* Address: 0x08000000
* Located at the beginning of FLASH
* Contains stack pointer and reset handler
* Ensures correct boot sequence

---

### 7.2 .text

* Address: 0x08000008
* Stored in FLASH
* Contains:

  * Program instructions
  * Read-only data
* Positioned immediately after vector table

---

### 7.3 .data

* VMA: 0x20000000 (RAM)
* LMA: Stored in FLASH (not shown directly in readelf)

Explanation:

* Initialized variables are stored in FLASH
* Copied to RAM during startup execution

---

### 7.4 .bss

* Address: 0x20000004
* Located in RAM
* Contains uninitialized variables
* Automatically initialized to zero

---

## 8. Validation Checklist

* Vector table starts at FLASH base address
* Program code is placed correctly in FLASH
* `.data` section is correctly mapped to RAM
* `.bss` section is zero-initialized
* No overlapping memory regions
* ELF file generated successfully

---

## 9. Project Structure

```
custom_linker_lab/
│── linker.ld
│── startup.c
│── main.c
│── firmware.elf
```

---

## 10. Conclusion

This project demonstrates precise control over memory layout in embedded systems using a custom linker script.

It validates how different sections are mapped between FLASH and RAM and highlights the role of startup code in system initialization.

This is a fundamental concept in embedded firmware development and BSP design.

```

