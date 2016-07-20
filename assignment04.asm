TITLE Assignment 04     (assignment04.asm)

; Author: Bryce Holewinski
; Course: CS 271 
; Project ID: Assignment 04        Date: May 8, 2016
; Description: This is a program that calculates composite numbers. First, the user will be instructed
; to enter the number of composites to be displayed via a prompt to enter an integer between 1-400.
; The program will verify the number is within the range. The program will then calculate and display all 
; of the composite numbers up to and including the nth composite. Results will be displayed 10 composites
; per line with 3 spaces between them

INCLUDE Irvine32.inc

; constant definition
LIMIT = 400			;the upper limit as defined by the problem

.data
;prompts and messages
program_intro			BYTE	"Welcome to Composite Numbers by Bryce Holewinski",0
instruction_one			BYTE	"Enter the composite numbers you would like to see.",0
instruction_two			BYTE	"The range of acceptable numbers is 1 - 400 inclusive.",0
entry_prompt			BYTE	"Enter the number of composites to display (1-400): ",0
error_message			BYTE	"The number you selected is outside of the designated range, try again.",0
farewell				BYTE	"Results certified by Bryce Holewinski, Goodbye!",0
spacing					BYTE	"   ",0

; variables
num						DWORD	?
count					DWORD	?
val						DWORD	?
column					DWORD	?



.code
main PROC

; introduction call
call intro

; userData call
call getUserData

; showComposites call
call showComposites

;fare thee well
call goodbye

	exit	; exit to operating system
main ENDP

; introduction procedure
intro PROC
	
	;introduce the program and developer
	mov			edx, OFFSET	program_intro
	call		WriteString
	call		Crlf

	;inform the user of the rules and the range
	mov			edx, OFFSET	instruction_one
	call		WriteString
	call		Crlf
	mov			edx, OFFSET	instruction_two
	call		WriteString
	call		Crlf

ret
intro ENDP

; user data gathering procedure
getUserData PROC
	
	;prompt user for number
	mov			edx, OFFSET	entry_prompt
	call		WriteString
	
	;get user input and store in num
	call		ReadInt
	mov			num, eax

	;call to validate
	call validate

ret
getUserData ENDP

validate PROC

	; check the number against the upper limit
	cmp			num, LIMIT
	jg			invalid
	
	;check the number against the lower limit
	cmp			num, 1
	jl			invalid
	jmp			proceed

	;invalid num, display error message and call back to getUserData
	invalid:
		mov				edx, OFFSET error_message
		call			WriteString
		call			Crlf
		call			getUserData

	;otherwise the user data is proper
	proceed:
		ret
validate ENDP

;this procedure displays the composite numbers in a list with 10 nums per line
;need to use a loop instruction to iterate through and display the proper amount of numbers
showComposites PROC
	
	;first we initialize the counter, column and val variables
	mov			ecx, num ;for the counter
	mov			column, 0
	mov			val, 1

	;our loop that decrements based on the num entered by the user earlier
	;it's pretty similar to the one used in assignment 2
	looper:

		;first we check if the number is a composite
		call	isComposite

		;since the number is valid we store the proper value
		mov		eax, val

		;next compare if we can stay in the current row 
		cmp		column, 10
		jl		row

		;otherwise make a new row
		call	Crlf
		mov		column, 0

		row:
			call		WriteDec
			mov			edx, OFFSET	spacing
			call		WriteString
			inc			column
			mov			eax, val
			inc			eax
			mov			val, eax

		;the loop instruction
		loop	looper


ret
showComposites ENDP

; since a composite number is any non-prime number we will have a bunch of comparrisons done by division to test if the
; number is prime or not, if it is not we will increment the counter and go back to check the next number
; 5 and 7 are tested again since they will be used as divisors for higher numbers but are themselves prime
isComposite PROC

	;initialize the edx & ebx registers with 0 then we will compare val to make sure it isn't 1-3
	mov			ebx, 0
	mov			edx, 0
	mov			eax, val
	cmp			val, 3
	jle			prime

	;test if val is divisible by 2
	mov			ebx, 2
	div			ebx
	cmp			edx, 0
	je			validNum
	mov			edx, 0

	;test if val is divisible by 3, beginning here we need to make sure that eax has the val for calculations
	mov			eax, val
	mov			ebx, 3
	div			ebx
	cmp			edx, 0
	je			validNum
	mov			edx, 0

	;test if val is divisible by 5, we skip 4 since that's tested by 2
	mov			eax, val
	mov			ebx, 5
	div			ebx
	cmp			edx, 0
	je			validNum
	mov			edx, 0

	;test if val is divisible by 7, we skip 6 since that's tested by 2 & 3
	mov			eax, val
	mov			ebx, 7
	div			ebx
	cmp			edx, 0
	je			validNum
	mov			edx, 0

	;test if val is divisible by 9, we skip 8 since that's tested by 2
	mov			eax, val
	mov			ebx, 9
	div			ebx
	cmp			edx, 0
	je			validNum
	mov			edx, 0

	;since this val is prime we increment it and go to the next one
	prime:
		mov		eax, val
		inc		eax
		mov		val, eax
		call	isComposite

	validNum:
		;first do one final check to make sure the "validNum" isn't 5 or 7
		mov		eax, val
		cmp		eax, 5
		je		prime
		cmp		eax, 7
		je		prime
		;return!
		ret
isComposite ENDP

goodbye PROC
;say goodbye!!
call		Crlf
mov			edx, OFFSET farewell
call		WriteString
call		Crlf
call		Crlf

ret
goodbye ENDP

END main