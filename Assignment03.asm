TITLE Assignment03     (Assignment03.asm)

; Author:Bryce Holewinski
; Course: CS271 
; Project ID: Assignment 03            Date: April 30, 2016
; Description: This program will display the program title and programmer's name. It will obtain the user's
; name and greet them. It shall display instructions. It will repeatedly prompt the user to input a number and then 
; validate the entered number to be between -100 and -1. It will count and accumulate the valid user numbers until a non-
; negative number is entered (which is discarded). Calculate the rounded average of the negative numbers and then 
; display 1) the number of negative integers entered (and handle the special case of no negatives entered) 2) sum of 
; numbers entered. 3) the average, rounded to nearest int. 4) a parting message to the user

INCLUDE Irvine32.inc

; constant definition
LIMIT = -100 ;this is the lower limit as defined in the sample problem

.data
; prompts and messages
program_intro					BYTE	"Welcome to the Integer Accumulator by Bryce Holewinski",0 
user_name_prompt				BYTE	"Hello, what's your name?", 0
user_greeting					BYTE	"Hello, ", 0
instruction_one					BYTE	"Please enter numbers between -100 and -1.",0
instruction_two					BYTE	"Once you enter a non-negative number the program will end and you will see the results.",0
entry_prompt					BYTE	"Enter number: ", 0
error_message					BYTE	"You did not enter a proper number between -100 and -1, try again.",0
total_num_entered_prompt1		BYTE	"You entered ", 0
total_num_entered_prompt2		BYTE	" valid numbers.",0
user_average					BYTE	"The rounded average is: ",0
user_sum						BYTE	"The sum of the numbers you entered is: ",0
farewell						BYTE	"Thanks for stopping by to play Integer Accumulator, goodbye ",0
special_message					BYTE	"You did not enter any negative numbers.",0

; variables
num					DWORD	?
prevNum				DWORD	?
totalNum			DWORD	0
sum					DWORD	?
avg					DWORD	?
remainder			DWORD	?
userName			BYTE	31 DUP(0)

.code
main PROC

; introduction

	;introduce the program and developer
	mov				edx, OFFSET	program_intro
	call			WriteString
	call			Crlf

	;get user name and greet them
	mov				edx, OFFSET	user_name_prompt
	call			WriteString
	mov				edx, OFFSET	userName
	mov				ecx, SIZEOF userName
	call			ReadString
	call			Crlf
	mov				edx, OFFSET	user_greeting
	call			WriteString
	mov				edx, OFFSET	userName
	call			WriteString
	call			Crlf

;user instructions
		
	;inform user of rules and range
	mov				edx, OFFSET	instruction_one
	call			WriteString
	call			Crlf
	mov				edx, OFFSET	instruction_two
	call			WriteString
	call			Crlf

;get user data until a positive is entered, verify lower bound

	proper_range:

		;prompt user for negative number between -100 and -1
		mov				edx, OFFSET entry_prompt
		call			WriteString

		;grabs user input
		call			ReadInt
		call			Crlf

		;validate user input
		cmp				eax, LIMIT	;compares the lower limit 
		jl				error		;jumps to the error prompt
		cmp				eax, -1		;compares to upper limit
		jg				results		;jumps to the results section
		mov				num, eax
		jmp				proper		;otherwise we continue collecting numbers

	;displays an error message and sends user back
	error:
		
		mov				edx, OFFSET	error_message
		call			WriteString
		call			Crlf
		jmp				proper_range

	;calculates the proper input and shoots them back to proper range
	proper:

		;increment totalNum
		mov				eax, totalNum	
		inc				eax				
		mov				totalNum, eax

		;add num to the sum
		mov				eax, num
		add				eax, sum
		mov				sum, eax
		jmp				proper_range ;goes back for more
		 
;calculate results

	results:

		;first check for special condition
		cmp				totalNum, 0
		je				special_end

		;perform calculations
		mov				eax, sum
		cdq
		mov				ebx, totalNum
		idiv			ebx
		mov				avg, eax
		mov				remainder, edx
		mov				totalNum, ebx

		;check the rounding
		cmp				remainder, 5			;check if you need to round up or down
		jle				display
		mov				eax, avg
		add				eax, 1
		mov				avg, eax

;display results

	display:
		
		mov			eax,0
		mov			ebx,0

		;display the total number of valid entries
		mov				edx, OFFSET	total_num_entered_prompt1
		call			WriteString
		mov				eax, totalNum
		call			WriteInt
		mov				edx, OFFSET	total_num_entered_prompt2
		call			WriteString
		call			Crlf

		;display the sum of the numbers entered
		mov				edx, OFFSET user_sum
		call			WriteString
		mov				eax, sum
		call			WriteInt
		call			Crlf

		;display the average of the numbers entered
		mov				edx, OFFSET user_average
		call			WriteString
		mov				eax, avg
		call			WriteInt
		call			Crlf
		jmp				exitlude

;special end

	special_end: 

	;inform user that they did not enter any negative numbers
	mov				edx, OFFSET special_message
	call			WriteString
	call			Crlf

;farewell/exitelude

	exitlude:
	;thanks and goodbye!
	mov				edx, OFFSET farewell
	call			WriteString
	mov				edx, OFFSET	userName
	call			WriteString
	call			Crlf
	call			Crlf



	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main