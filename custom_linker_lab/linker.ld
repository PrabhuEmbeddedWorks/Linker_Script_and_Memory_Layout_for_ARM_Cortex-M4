/* linker.ld */

/* Define MEMORY regions for flash and RAM using the correct sizes and base addresses */
MEMORY {
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 256K /* Flash: 256 KB starting at 0x08000000 */
    RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 64K  /* RAM: 64 KB starting at 0x20000000 */
}

/* Define stack symbol at the top of RAM (downward-growing stack) */
_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS {
    /* 1. The interrupt vector table at the start of flash */
    .isr_vector : {
        KEEP(*(.isr_vector)) /* KEEP prevents the linker from discarding the vector table */
    } > FLASH

    /* 2. .text (code) properly placed in flash */
    .text : {
        . = ALIGN(4);
        *(.text*)    /* Actual program code */
        *(.rodata*)  /* Read-only data/constants */
        . = ALIGN(4);
    } > FLASH

    /* Store the load address (LMA) of .data in flash to be used by startup script */
    _sidata = LOADADDR(.data);

    /* 3. .data copied to RAM and linked for runtime */
    .data : {
        . = ALIGN(4);
        _sdata = .;  /* Start of initialized data */
        *(.data*)    /* Initialized variables */
        . = ALIGN(4);
        _edata = .;  /* End of initialized data */
    } > RAM AT > FLASH /* AT > FLASH dictates it loads from flash but runs in RAM */

    /* 4. .bss zero-initialized in RAM */
    .bss : {
        . = ALIGN(4);
        _sbss = .;   /* Start of uninitialized data */
        *(.bss*)     /* Uninitialized variables */
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;   /* End of uninitialized data */
    } > RAM
}
