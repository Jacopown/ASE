int main(void){
	__asm volatile (
			"MOV R0, #1 \n"
			"MSR CONTROL, R0 \n"
			"ISB \n"
			"SVC 0xA \n"
		);
	while(1);
}
