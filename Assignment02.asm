TITLE Assignment02     (Assignment02.asm)

; Author:Bryce Holewinski
; Course: CS271, Section 400 
; Project ID: Assignment 2        Date: April 17, 2016
; Description: This program will display the programmers name and project title. 
; It will also accept a string input (user's name), and greet the user. It will 
; then prompt the user to enter the number which they want to see the fibonaci sequence 
; of and verify the range. It will calculate the fibonnaci sequence up to the nth term (provided by user)
; with appropriate spacing and then display a farewell message. 

INCLUDE Irvine32.inc

; constant definition
LIMIT = 46 ;the upper limit as noted on the assignment for DWORD data

.data
;prompts and messages
program_intro				BYTE	"Welcome to the Fibonacci Numbers Program!", 0
dev_intro					BYTE	"Programmed by Bryce Holewinski", 0
user_name_prompt			BYTE	"What's your name?", 0
user_greeting				BYTE	"Hello, ", 0
instruction_one				BYTE	"Please enter the number of Fibonnaci terms you'd like to see displayed.", 0
instruction_two				BYTE	"Select an integer in the range of 1 through 46.", 0
instruction_three			BYTE	"How many Fibonnaci terms would you like to see?", 0
error_message				BYTE	"Your selection was not within the range of 1 through 46, try again.", 0
dev_farewell				BYTE	"Results certified by Bryce Holewinski.", 0
user_farewell				BYTE	"Goodbye, ", 0

; variables (input and output)
num							DWORD	?
count						DWORD	?
userName					BYTE	31 DUP(0)
value						DWORD	?
prev_val					DWORD	?

;formatting variables
column						DWORD	?		  ;for the 5 columns	
spacing						BYTE	"     ",0 ;5 spaces per instructions

.code
main PROC

;introduction

	;introducing the program and developer
	mov		edx, OFFSET	 program_intro
	call	WriteString
	call	Crlf
	mov		edx, OFFSET	dev_intro
	call	WriteString
	call	Crlf

	;get user name and display
	mov		edx, OFFSET	user_name_prompt
	call	WriteString
	mov		edx, OFFSET	userName	;I had trouble with this section with the sizes not being equal
	mov		ecx, SIZEOF	userName	; and so I pulled these lines from stackoverflow
	call	ReadString
	mov		count, eax
	call	Crlf

	;greet user by name
	mov		edx, OFFSET	user_greeting
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	Crlf

;user instructions
	
	;inform user of fibonnaci range
	mov		edx, OFFSET	instruction_one
	call	WriteString
	call	Crlf
	mov		edx, OFFSET	instruction_two
	call	WriteString
	call	Crlf

;get user data and verify range

	proper_range:

		;prompt user for sequence length
		mov		edx, OFFSET instruction_three
		call	WriteString
		call	Crlf

		;get users input
		call	ReadInt
		call	Crlf

		;validate user input
		cmp		eax, 1			;checks lower limit
		jl		error			
		cmp		eax, LIMIT		;checks upper limit
		jg		error
		jmp		proper

	;displays error and sends user back
	error:

		mov		edx, OFFSET	error_message
		call	WriteString
		call	Crlf
		jmp		proper_range

	;continues on with proper input 
	proper:
		
		mov		num, eax		;stores proper input
		call	crlf
		call	crlf

;display fibonnaci sequence
;fibonnaci in mathematical terms is Fn = Fn-1 + Fn-2

	;restructure register values for the loop
	mov			eax, 0
	mov			ebx, 1
	mov			ecx, num	;this will be the counter as determined by user
	mov			value, 1	;start value off at 1 since fibonnaci sequences begin at 1
	mov			prev_val, 0	;start prev_val at 0, based on value being 1
	mov			column, 1	;start column at 1	

	;loop instruction acts like a for loop, decrementing ecx each iteration
	theLoop:

		;as shown by the mathematical term above we need to add up the terms
		mov		eax, value
		add		eax, prev_val
		mov		value, eax
		mov		prev_val, ebx
		mov		ebx, value

		;check to see if we can stay in the same row (nested do-while loop)
		cmp		column, 5
		jle		row
		;otherwise make new row
		call	Crlf
		mov		column, 1

		;display the number with a space and increment the column counter
		row:

			call		WriteDec
			mov			edx, OFFSET	spacing
			call		WriteString
			inc			column
			
		;here's the for loop instruction
		loop	theLoop

		;needs some spacing
		call	Crlf
		call	Crlf

;farewell/exitlude

	;ensure the user that results have been certified by their trusty programmer
	mov			edx, OFFSET dev_farewell
	call		WriteString
	call		Crlf

	;bid them goodbye
	mov			edx, OFFSET user_farewell
	call		WriteString
	mov			edx, OFFSET userName
	call		WriteString
	call		Crlf



	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main