// Lab 6 Part 8: Changing Volume with GPIO
#include "xparameters.h"
#include "xiomodule.h"

volatile int timer_ticks = 0;

void timer_handler(void *CallbackRef)
{
    timer_ticks++;
}

void delay(int ms)
{
    int target = timer_ticks + ms;
    while(timer_ticks < target);
}

int main()
{
    unsigned counter = 0;
    
    // GPIO initialisation
    XIOModule iom;
    XIOModule_Initialize(&iom, XPAR_IOMODULE_0_DEVICE_ID);
    XIOModule_Start(&iom);
    
    // Enable timer
    XIOModule_Connect(&iom, XIN_IOMODULE_FIT_1_INTERRUPT_INTR, timer_handler, NULL);
    XIOModule_Enable(&iom, XIN_IOMODULE_FIT_1_INTERRUPT_INTR);
    
    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, 
        (Xil_ExceptionHandler)XIOModule_DeviceInterruptHandler, NULL);
    Xil_ExceptionEnable();
    microblaze_enable_interrupts();
    
    // Frequencies (top values)
    unsigned frequencies[3] = {199, 99, 49};
    
    // Volume levels (0-10)
    unsigned volumes[4] = {2, 5, 8, 10};  // 20%, 50%, 80%, 100%
    
    while(1)
    {
        // Select note using counter modulo 3
        unsigned note = frequencies[counter % 3];
        
        // Select volume using counter modulo 4
        unsigned volume = volumes[counter % 4];
        
        // Combine: volume in bits 19-16, frequency in bits 15-0
        unsigned value = (volume << 16) | note;
        
        // Write to GPIO
        XIOModule_DiscreteWrite(&iom, 1, value);
        
        delay(1000);  // 20ms per note
        counter++;
    }
    
    return 0;
}