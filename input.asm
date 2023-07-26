section .data
	msg1	db	"Input anythings here: ",0xa
	len1	equ	$-msg1
	msg2	db	"Your String entered: ", 0xa
	len2	equ	$-msg2

section .bss
	buffer  resb	0x20
	
section .text
	global _start

_start:
	;print out messege 1
	mov eax, 0x4
	mov ebx, 0x1
	mov ecx, msg1
	mov edx, len1
	int 0x80

	; receive strings
	mov eax, 0x3
	mov ebx, 0x0
	mov ecx, buffer
	mov edx, 0x20
	int 0x80
	
	; convert to Upper case:
	mov ecx, 0x20
	mov ebx, 0x0
	mov esi, buffer
	l1:
		push ecx
		cmp byte [esi+ebx], 0
		je end_loop
		
		cmp byte [esi+ebx], 'a'
		jl end_loop
		cmp byte [esi+ebx], 'z'
		jg end_loop
		sub byte [esi+ebx], 0x20
		inc ebx
		pop ecx
	loop l1
	
	end_loop:
	; print out messege 2
	mov eax, 0x4
	mov ebx, 0x1
	mov ecx, msg2
	mov edx, len2
	int 0x80

	; print out strings entered
	mov eax, 0x4
	mov ebx, 0x1
	mov ecx, buffer
	mov edx, 0x20
	int 0x80

	mov eax, 0x1
	int 0x80
