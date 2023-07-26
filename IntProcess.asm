section .data
	num1	dd	0x0
	num2	dd	0x0
	sum	dd	0x0
	msg1	db	"Enter 2 number positive integer: ", 0xa
	len1	equ	$-msg1
	msg2	db	"Sum of 2 entered number: "
	len2	equ	$-msg2
	newline	db	0xa
section .bss
	buffer	resd	0x5

section .text
	global _start

_start:
	;print out message 1 
	mov	eax, 0x4
	mov 	ebx, 0x1
	mov 	ecx, msg1
	mov 	edx, len1
	int 	0x80

	;Process number 1
	mov 	eax, 0x3
	mov 	ebx, 0x0
	mov 	ecx, buffer
	mov	edx, 0x5
	int	0x80
	
	cmp	eax, 0
	je	exit
	cmp	byte [buffer], 0x2d ;check "-" char
	je	exit
	mov	eax, dword [buffer]
	mov	dword [num1], eax
	
	;Process Number 2
	mov	eax, 0x3
	mov 	ebx, 0x0
	mov	ecx, buffer
	mov	edx, 0x5
	int 	0x80

	cmp	eax, 0
	je	exit
	cmp	byte [buffer], 0x2d
	je	exit
	mov	eax, dword [buffer]
	mov 	dword [num2], eax
	
	
	;print out message 2
	mov	eax, 0x4
	mov	ebx, 0x1
	mov 	ecx, msg2
	mov	edx, len2
	int	0x80
	
	;Calculate 2 numbers
	mov	eax, [num2]
	mov	ebx, [num1]
	add	eax, ebx
	mov 	dword [sum], eax
	mov	ecx, 0x4
	mov 	esi, 0x3
	l1:	
		push 	ecx
		sub	byte [sum+esi], 0x30
		dec 	esi
		pop 	ecx
	loop l1
	;print sum
	mov	eax, 0x4
	mov 	ebx, 0x1
	mov 	ecx, sum
	mov 	edx, 0x4
	int 	0x80
	 
	;endline
	mov	eax, 0x4
	mov	ebx, 0x1
	mov	ecx, newline
	mov	edx, 0x1
	int 	0x80
	exit:
	mov	eax, 0x1
	int 	0x80
