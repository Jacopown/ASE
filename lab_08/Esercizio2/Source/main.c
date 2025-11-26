#include <stdint.h>
#include <math.h>

extern unsigned int Input_Values;
extern unsigned char NUM_VALUES;
extern int fast_magic_calc(int input_float_as_int);

float ERRORS[2][4]; 

int main(void){

    volatile unsigned int *vector = &Input_Values;
    int num_vals = NUM_VALUES; 
    
    int i;
    for(i = 0; i < num_vals; i++) {
        
        unsigned int input_int = vector[i];
        
        float x = *((float*)&input_int);
        float xhalf = 0.5f * x;

        int magic_res = fast_magic_calc(input_int);
        
        float y = *((float*)&magic_res);
        
        y = y * (1.5f - (xhalf * y * y));
        
        float standard = 1.0f / sqrtf(x);
        
        float diff = standard - y;
        if(diff < 0) diff = -diff;
        
        ERRORS[i/4][i%4] = diff;
    }
		
    while(1);
}