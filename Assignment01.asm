TITLE  assignment one     (Assignment01.asm)

; Author:Bryce Holewinski
; Course CS271, Section 400
; Project ID: Assignment 1            Date: April 10, 2016
; Description:This program will display the author's name, program title, and instructions for the user.
; The program will take two integers as input, calculate the sum, difference, product, quotient and 
; remainder and display those items to the user. The program will then display a goodbye message. 

INCLUDE Irvine32.inc

.data
;variables for user input
userNum1	DWORD	?
userNum2	DOWRD	?

; prompts and messages
intro			BYTE	"Author: Bryce Holewinski", 0
instruction_one	BYTE	"Enter two numbers and I will show you their sum, difference, product, quotient and remainder.", 0
instruction_two	BYTE	"Please enter the first number: ", 0
instruction_three BYTE	"Please enter the second number: ", 0
goobye			BYTE	"Thanks for stopping by, take care!", 0

;output for arithmetic displays
sum_sign		BYTE	" + ",0
diff_sign		BYTE	" - ",0
mult_sign		BYTE	" * ",0
div_sign		BYTE	" / ",0
remainder		BYTE	" the remainder is: ",0
equal_sign		BYTE	" = ",0
answer_sum		DWORD	?
answer_diff		DWORD	?
answer_mult		DWORD	?
answer_div		DWORD	?
answer_remainder DWORD	? 

.code
main PROC

; Introduction section
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruction_one
	call	WriteString
	call	CrLf

; Get the data

	;get the first num from user
	mov		edx, OFFSET instruction_two
	call	WriteString
	call	ReadInt
	mov		userNum1, eax
	call	CrLf

	;get the second num from user
	mov		edx, OFFSET instruction_three
	call	WriteString
	call	ReadInt
	mov		userNum2, eax
	call	CrLf

;Calculate the values

	;calculate the sum
	mov		ebx, userNum1
	mov		ecx, userNum2
	add		ecx, ebx
	mov		answer_sum, ecx

	;calculate the difference
	mov		ebx, userNum1
	mov		ecx, userNum2
	sub		ecx, ebx
	mov		answer_diff, ecx

	;calculate the product 
	mov		eax, userNum1
	mul		userNum2
	mov		answer_mult, eax

	;calculate the quotient and remainder
	mov		edx, 0
	mov		eax, userNum1
	mov		ebx, userNum2
	div		ebx
	mov		answer_remainder, edx
	mov		answer_div, eax

;Display results

	;display the sum
	mov		eax, userNum1
	call	WriteDec
	mov		edx, OFFSET sum_sign
	call	WriteString
	mov		eax, userNum2
	call	WriteDec
	mov		edx, OFFSET equal_sign
	call	WriteString
	mov		eax, answer_sum
	call	WriteDec
	call	CrLF

	;display the difference
	mov		eax, userNum1
	call	WriteDec
	mov		edx, OFFSET diff_sign
	call	WriteString
	mov		eax, userNum2
	call	WriteDec
	mov		edx, OFFSET equal_sign
	call	WriteString
	mov		eax, answer_diff
	call	WriteDec
	call	CrLF

	;display the product
	mov		eax, userNum1
	call	WriteDec
	mov		edx, OFFSET mult_sign
	call	WriteString
	mov		eax, userNum2
	call	WriteDec
	mov		edx, OFFSET equal_sign
	call	WriteString
	mov		eax, answer_mult
	call	WriteDec
	call	CrLF

	;display the quotient and remainder
	mov		eax, userNum1
	call	WriteDec
	mov		edx, OFFSET div_sign
	call	WriteString
	mov		eax, userNum2
	call	WriteDec
	mov		edx, OFFSET equal_sign
	call	WriteString
	mov		eax, answer_div
	call	WriteDec
	mov		edx, OFFSET remainder
	call	WriteString
	call	CrLF

; Goodbye Message!

	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main