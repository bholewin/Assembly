TITLE Assignment05     (assignment05.asm)

; Author: Bryce Holewinski
; Course: CS271 
; Project ID: Assignment 5            Date: May 22, 2016
; Description: This program will have an introduction. It will then obtain a number from the user, which
; will be validated to be within the range of 10-200. It will then generate random integers in a range of
; 100 to 999, storing them in consecutive elements of an array. It will next display the list of integers 
; before sorting them with 10 columns. The list will be sorted in descending order (i.e. largest first). 
; It will display the sorted list and calculate and display the median value, rounded to nearest integer. 

INCLUDE Irvine32.inc

; constant definitions as defined in the assignment
MIN = 10
MAX = 200
LO = 100
HI = 999

.data
;prompts and messages
program_intro			BYTE	"Sorting Random Integers, programmed by Bryce Holewinski",0
instruction_one			BYTE	"This program generates random numbers in the range of 100-999.",0
instruction_two			BYTE	"It then displays the original list, the list again sorted, and the median value.",0
intruction_three		BYTE	"The sorted portion will be in descending order.",0
user_prompt				BYTE	"Select how many values should be implemented, between 10 and 200: ",0
error_message			BYTE	"Invalid input, try again.",0
unsorted_display		BYTE	"The unsorted random numbers are: ",0
sorted_display			BYTE	"The sorted list (in descending order): ",0
median_display			BYTE	"The median is: ",0
spacing					BYTE	"    ",0

; variables
request					DWORD	?
array					DWORD	MAX	DUP(?) ;capacity is set to 200
median					DWORD	?
count					DWORD	?
column					DWORD	?

.code
main PROC

;introduction
call intro

;call randomize to seed the random #s
call RANDOMIZE

;get data
;per instructions pass through request by reference
push OFFSET request
call getUserData

;fill the array, pass request by value and array by reference
push OFFSET array
push request
call fillArray

;here is the first of two calls to display list, this one shows the unsorted list
push OFFSET array
push request
push OFFSET unsorted_display
call displayList

;sort list, same parameters as filling the array, this time they values are sorted
push OFFSET array
push request
call sortList

;display median, will calculate and then display the median value of the array once the array is sorted
push OFFSET array
push request
call displayMedian

;here is the second of two calls to display list, this one shows the sorted list
push OFFSET array
push request
push OFFSET sorted_display
call displayList

	exit	; exit to operating system
main ENDP

;*************************************************************************************
; introduction procedure
; This procudure introduces the program and the developer and lays out  the general 
; rules and what to expect
;*************************************************************************************

intro PROC

	;introduce the program and developer
	mov			edx, OFFSET program_intro
	call		WriteString
	call		Crlf

	;inform the user of the rules
	mov			edx, OFFSET instruction_one
	call		WriteString
	call		Crlf
	mov			edx, OFFSET instruction_two	
	call		WriteString
	call		Crlf
	mov			edx, OFFSET intruction_three
	call		WriteString
	call		Crlf

ret
intro ENDP
;*************************************************************************************
; getUserData, this function compares the user input against min and max, using data validation
; then it will store and return the proper value
;*************************************************************************************

getUserData PROC
;first set up the stack frame
push	ebp
mov		ebp, esp
mov		ebx, [ebp+8]

	properRange:
	;prompt user for number
	mov			edx, OFFSET user_prompt
	call		WriteString
	call		Crlf

	;get user input and compare against min and max
	call		ReadInt
	cmp			eax, MAX
	jg			invalid
	cmp			eax, MIN
	jl			invalid
	jmp			proper

	;this will warn the user and send them back for proper input
	invalid:
	mov			edx, OFFSET error_message
	call		WriteString
	call		Crlf
	jmp			properRange

	;stores the proper input from the user
	proper:
	mov			[ebx], eax
	pop			ebp
	ret			4

getUserData ENDP
;*************************************************************************************
; fill Array, this function takes request which will become our counter for the number 
; of iterations to loop through and fill the array with random numbers. Calls to randomrange
; will be made according to the method shown in lecture 20, much of this function borrows
; from that lecture  
;*************************************************************************************
fillArray PROC
;setting up the stack
push	ebp
mov		ebp, esp
mov		edi, [ebp+12]
mov		ecx, [ebp+8]

	;this is the start of the loop that decrements based on the users input for request
	addElement:
	;first set up the range of possible numbers
	mov			eax, HI
	sub			eax, LO
	add			eax, 1
	call		RandomRange
	;then store the number and call our loop
	add			eax, LO
	mov			[edi], eax
	add			edi, 4
	loop		addElement

pop ebp
ret 8
fillArray ENDP
;*************************************************************************************
; sortList, this function takes the array as an offset and request as a value. It will then
; be sorted in descending order using the bubble sort method described in the reading page 375
; the code is adjusted slightly since the program requirements are for descending order
;*************************************************************************************
sortList PROC
;create the stack
push	ebp
mov		ebp, esp
mov		ecx, [ebp+8]
dec		ecx

	;outer loop
	L1:
	push		ecx
	mov			esi, [ebp+12]

	;inner loop
	L2:
	mov			eax, [esi]
	cmp			[esi+4], eax
	jl			L3
	xchg		eax, [esi+4]
	mov			[esi], eax

	L3:
	add			esi, 4
	loop		L2

	;returning to outer loop
	pop			ecx
	loop		L1


pop ebp
ret 8
sortList ENDP

;*************************************************************************************
; displayMedian, this function will find the median of the sorted array, and round it to
; the nearest whole integer. The median is the middle value in a sorted list. Once the 
; median is found it will be displayed 
;*************************************************************************************
displayMedian PROC
;set up the stack
push	ebp
mov		ebp, esp
mov		esi, [ebp+12]
mov		eax, [ebp+8]
mov		edx, 0

	;first find the halfway point in the array
	mov			ebx, 2
	div			ebx
	cmp			edx, 0
	je			calcMedian  ;need to perform rounding since there are even # of values

	;after some testing I realized I need to display the address not the value
	;this portion was modified based on a stackoverflow finding
	mov			ebx, 4
	mul			ebx
	add			esi, eax
	mov			eax, [esi]

	;display the median
	display:
	call		CrLf
	mov			edx, OFFSET median_display
	call		WriteString
	call		WriteDec
	call		CrLf
	jmp			fin

	;rounding for calculating the median
	calcMedian:

	;calculate lower position address
	mov			eax, esi
	sub			eax, 4
	mov			esi, eax
	mov			eax, [esi]

	;calculate higher position address
	mov			ebx, 4
	mul			ebx
	add			esi, eax
	mov			edx, [esi]

	;average the two values
	add			eax, edx
	mov			edx, 0
	mov			ebx, 2
	div			ebx
	call		display

	fin:
	pop ebp
	ret 8

displayMedian ENDP

;*************************************************************************************
; displayList, this function will display the contents of the array as well as the 
; array title (based on what's passed in). This procedure's implementation borrows
; heavily from lecture 20
;*************************************************************************************
displayList PROC
push	ebp
mov		ebp, esp
mov		esi, [ebp+16]
mov		ecx, [ebp+12]
mov		ebx, 1

	;displays the list title
	call		CrLf
	mov			edx, [ebp+8]
	call		WriteString
	call		CrLf

	;display current row
	currentRow:
	cmp			ebx, MIN
	jg			newRow
	mov			eax, [esi]
	call		WriteDec
	mov			edx, OFFSET spacing
	call		WriteString
	add			esi, 4
	inc			ebx
	loop		currentRow
	jmp			fin

	;create a new row
	newRow:
	call		CrLf
	mov			ebx, 1
	jmp			currentRow

	fin:
	call		CrLf
	pop			ebp
	ret			12
displayList ENDP

END main