;The purpose of this assembly code is to ensure that the main function is properly executed as the entry point of the kernel. 
;This is important because, during the compilation and linking process, 
;the actual layout and arrangement of functions in the compiled code might not guarantee that the main function will be the first to execute. 
;The order of functions and the behavior of the compiler and linker could lead to a situation where the kernel's entry point is not reached.
[bits 32]
[extern main] ;Declare that the 'main' function is external in our kernel code.
call main
jmp $