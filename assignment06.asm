TITLE Assignment #6 - Option A     (assignment06.asm)

; Author: Bryce Holewinski
; Course: CS271
; Project ID: Assignment 6, Option A          Date: June 1, 2016
; Description: This program will implement and test my own version of ReadVal and WriteVal procedures for
; unsigned integers. Macros will be implemented for getString and displayString. getString should display 
; a prompt and get the user's keyboard input in a memory location. displayString should display the string 
; stored in the specific memory location. readVal should invoke the getString macro to get the user's string of digits
; convert it to numeric and validate the input. writeVal should convert a numeric value to a string of digits
; and invoke displayString macro to produce the output. The program will retrieve 10 valid integers from the user
; and stores the numeric values in an array. The program then displays the integers, their sum, and their average

INCLUDE Irvine32.inc

; constants
MAX = 10			;for the array
 
;macros
;-------------------------------------------------------------------------------------;
;		This is the getString macro, which displays a prompt and then gets the user's
;keyboard inut into a memory location. Some of the code is borrowed from pages 415-416
; of the textbook and from lecture 26
;-------------------------------------------------------------------------------------;
getString MACRO instruction, size
push	ecx
push	edx
mov		edx, instruction
mov		ecx, size
call	readString
pop		edx
pop		ecx
ENDM

;-------------------------------------------------------------------------------------;
;		This is the displayString macro, it displays the string stored in a specified
; memory location. Some of the code is taken from pages 418-419 of the textbook
;-------------------------------------------------------------------------------------;
displayString MACRO theString
push	edx
mov		edx, OFFSET theString
call	WriteString
pop		edx
ENDM

.data

; prompts and messages
program_intro			BYTE	"PROGRAMMING ASSIGNMENT 6: Designing Low-Level I/O Procedures",0
programmer_intro		BYTE	"Written by: Bryce Holewinski",0
instruction_one			BYTE	"Please enter 10 unsigned decimal integers.",0
instruction_two			BYTE	"Each number needs to be small enough to fit inside a 32-bit register.",0
instruction_three		BYTE	"After the numbers have been inputted the numbers will be listed, along with the sum and average.",0
user_prompt				BYTE	"Please enter an unsigned integer: ",0
error_message			BYTE	"Error: you did not enter a valid unsigned number or your number was too large, try again.",0
list_display			BYTE	"You entered the following numbers: ",0
sum_display				BYTE	"The sum of these numbers is: ",0
average_display			BYTE	"The average is: ",0
farewell_display		BYTE	"Thanks for checking out the program!",0
formating_display		BYTE	", ",0

;variables
request					DWORD	?
sum						DWORD	? 
average					DWORD	?
input_string			BYTE	255 DUP (0)
output_string			BYTE	32 DUP (?)
array					DWORD	MAX	DUP(?) ;capacity is at 10
test_array				DWORD	1, 2, 3, 4, 5, 6, 7, 8, 9, 10


.code
main PROC

; introduction
call intro

;fill up the array using valid input via readVal
; to do this we will use a short loop that will grab prompt the user and then calls readVal

	;first set up the counter for the loop and move the array to register EDI
	mov			ecx, 10
	mov			edi, OFFSET array

	;now start the loop
	input_loop:
		
		;prompt the user for input
		displayString OFFSET user_prompt

		push OFFSET input_string
		push SIZEOF input_string
		call readVal

		;input the valid int and increment the array's element position
		mov		eax, DWORD PTR input_string
		mov		[edi], eax
		add		edi, 4

		loop input_loop

;now we will use a simple loop to output the values that we gathered above
;and use writeVal to display the array values one at a time

	;first set up the counter for the loop and move the array to register EDI
	mov			ecx, 10
	mov			esi, OFFSET array

	;tell the user what they're about to see
	call		Crlf
	displayString OFFSET list_display

	;now we do the output loop
	output_loop:

		mov		eax, [esi]
		push	eax
		push	OFFSET output_string
		call	writeVal
		add		esi, 4
		loop	output_loop

	call		Crlf

;now it's time for some math calculations
push OFFSET array	;ebp+16
push OFFSET sum		;ebp+12
push OFFSET average ;ebp+8
call calculations

;goodbye!
call farewell

	exit	; exit to operating system
main ENDP
;---------------------------------------------------------------------------------
;introduction procedure, this procedure introduces the program and programmer
;---------------------------------------------------------------------------------
intro PROC

	;next begin making calls 
	displayString	OFFSET program_intro
	call			Crlf
	displayString	OFFSET programmer_intro
	call			Crlf	
	displayString	OFFSET instruction_one
	displayString	OFFSET instruction_two
	displayString	OFFSET instruction_three
	call			Crlf
	call			Crlf

ret 
intro ENDP
;---------------------------------------------------------------------------------
;readVal procedure, this procedure invokes the getString macro to get the user's
; string of digits. It then converts the digits to numeric and validates the input
;---------------------------------------------------------------------------------
readVal PROC

	;first set up the stack
	push	ebp
	mov		ebp, esp
	pushad

	begin:

	mov		edx, [ebp+12]	;the address of input string
	mov		ecx, [ebp+8]	;the length of input_string
	getString	edx, ecx

	;now it's time prep the registers
	mov		esi, edx
	mov		eax, 0
	mov		ecx, 0
	mov		ebx, 10

		;start the validation sequence
		validate:

			;loads the byte into al to compare it to 0 to see if we reached the null terminator
			lodsb
			cmp		ax, 0
			je		the_end

			;next we determine if the byte is valid by comparing its ASCII values
			cmp		ax, 48
			jb		invalid
			cmp		ax, 57
			ja		invalid

			;value is proper, thus convert it to a digit
			sub		ax, 48
			xchg	eax, ecx
			mul		ebx
			jc		invalid			;checks for overflow
			jmp		valid

		;here we deal with invalid numbers
		invalid:

			displayString	OFFSET error_message
			call	Crlf
			displayString	OFFSET user_prompt
			jmp		begin

		;valid numbers are handled here
		valid:

			add		eax, ecx
			xchg	eax, ecx
			jmp		validate

		;reached the end
		the_end:
			
			xchg	ecx, eax
			mov		DWORD PTR input_string, eax

popad
pop	ebp
ret 8
readVal ENDP
;---------------------------------------------------------------------------------
;writeVal procedure, converts a numeric value to a string of digits, and invokes the 
; displayString macro to produce the output
;---------------------------------------------------------------------------------
writeVal PROC
	; set up the stack
	push	ebp
	mov		ebp, esp
	pushad

	;set up registers for sequence
	mov		eax, [ebp+12]
	mov		edi, [ebp+8]
	mov		ebx, 10
	push	0

	;now we convert the digits to a string
	conversion:
		
		mov		edx, 0
		div		ebx
		add		edx, 48
		push	edx

		;check if you've reached the end of the number
		cmp		eax, 0
		jne		conversion

	;place the characters into output_string, I found this sequence on stackoverflow
	place_in:

		pop		[edi]
		mov		eax, [edi]
		inc		edi
		cmp		eax, 0
		jne		place_in


	;lastly, print the string
	mov		edx, [ebp+8]
	displayString	OFFSET output_string
	displayString	OFFSET formating_display

popad
pop ebp
ret 8
writeVal ENDP
;---------------------------------------------------------------------------------
;calculations procedure, this procedure calculates and displays the sum and average
; of the numbers in the user's array
;---------------------------------------------------------------------------------
calculations PROC
	;set up the stack
	push	ebp
	mov		ebp, esp
	pushad

	;first display the sum, starting with setting up the registers
	mov		esi, [ebp+16]  ;move the array to esi
	mov		ecx, 10
	mov		eax, 0
	mov		ebx, [ebp+12] ;move sum into ebx

	;now do the summation loop
	summation:

		add		eax, [esi]
		add		esi, 4
		loop	summation
	
	;now move the total and display it
	mov		[ebx], eax
	displayString OFFSET sum_display
	push	eax
	push	OFFSET output_string
	call	writeVal
	call	Crlf

	;now we display the average
	displayString OFFSET average_display
	mov		eax, sum		;move the sum into eax
	mov		ebx, 10
	mov		edx, 0				
	div		ebx

	;use writeVal
	push	eax
	push	OFFSET output_string
	call	writeVal
	call	Crlf


popad
pop ebp
ret 12
calculations ENDP


;---------------------------------------------------------------------------------
;farewell procedure, this procedure says goodbye to the user
;---------------------------------------------------------------------------------
farewell PROC

	;say goodbye to the user
	displayString	OFFSET farewell_display
	call	Crlf

ret
farewell ENDP

END main