; Welcome to compiler tutorial #2

; Command Line Parameters:
; 1. To get a full listof command line parameters, run the compiler
;    with the oh flag
; 2. For this tutorial, we will change the DEPTH of the mif file to 512
; 3. We will also specify the name of the output file

; Handling Errors:
; 1. The compiler will handle most errors without crashing
  2. Even if I forget a Semicolon, the compiler will figure output
     that these lines should have been comments
; 3. Any errors in the assembly code will be printed out to the terminal
;    when the compiler is run
; 4. If you forget to prepend an instruction with # or r, the compiler 
;    will try its best to infer what you meant to do
; 5. Even if there are errors in your assembly code, the compiler will 
;    generate the mif file anyways, along with a warning. Just in case
;    what you did was intentional. Though be warned, it likely will not
;    function as you thought it would.



; Let's see some code

CLR 0           ; Here I forgot and r before the Register, but it will
CLR 1           ; be inferred by the compiler

SR0 #10
MOV r1 r0

MOVR r1
PAUSE
PAUSE
MOVRHS r1
PAUSE
PAUSE
SUBI 0 1        ; Here I forgot both the r and #.
BRZ #2
BR #-8

SR0 #8
SRH0 #8


MOVRHS r0


; To Compile Me:
; python compiler.py compiler_tut_02.s -o compiler_tutorial_002 -w 512