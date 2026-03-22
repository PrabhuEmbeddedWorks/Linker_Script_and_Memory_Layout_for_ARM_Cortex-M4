#include <stdint.h>

/* Import symbols defined in the linker script */
extern uint32_t _estack;
extern uint32_t _sidata, _sdata, _edata;
extern uint32_t _sbss, _ebss;

extern int main(void);

void Reset_Handler(void) {
    /* Copy .data from flash to RAM */
    uint32_t *src = &_sidata;
    uint32_t *dest = &_sdata;
    while (dest < &_edata) {
        *dest++ = *src++;
    }

    /* Zero-initialize the .bss section */
    dest = &_sbss;
    while (dest < &_ebss) {
        *dest++ = 0;
    }

    /* Jump to main application */
    main();
    while(1);
}

/* Place the vector table in the dedicated .isr_vector section */
__attribute__((section(".isr_vector")))
void (* const g_pfnVectors[])(void) = {
    (void (*)(void))(&_estack), /* Initial Stack Pointer */
    Reset_Handler               /* Reset Handler */
};
