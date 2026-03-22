int my_initialized_data = 100; /* This should end up in .data */
int my_uninitialized_data;     /* This should end up in .bss */

int main(void) {
    /* Code goes to .text */
    my_uninitialized_data = my_initialized_data + 50;
    
    while(1) {
        // Infinite loop
    }
    return 0;
}
