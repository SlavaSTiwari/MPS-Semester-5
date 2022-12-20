; Author: 	        Slava Shiv Tiwari
; Date of Completion:  	24/11/2022
; Task: 	        Take vector as user input and output only
;	                negative numbers in decreasing order.

global _start

section .data
	buffer: times 100 db 0
	data: times 100 db 0
	inp_str: db 'Input numbers: '
	out_str: db 'Sorted array: '
	swapped: db 0

section .start
_start:

take_input:
	mov eax, 4
	mov ebx, 1
	mov ecx, inp_str		; decoration
	mov edx, 15
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, buffer			; take input into buffer
	mov edx, 100
	int 80h

	xor edx, edx			; index = 0
	xor edi, edi			; count = 0

find_neg:
	lea esi, [buffer+edx]		; esi = *(buffer+edx), edx: 0, 1, 2..
	movzx eax, byte [esi]		; eax = single byte from buffer

	inc edx				; increment index

	cmp eax, 0			; if end of buffer,
	je sorter			; exit loop, go to sort the array

	cmp eax, '-'			; compare eax to the single bytes

	je equal			; if neg number, insert in array
	jne find_neg			; else keep looping

equal:
	lea esi, [buffer+edx]
	movzx eax, byte [esi]		; take a single byte

	mov [data + edi], byte '-'
	mov [data + edi + 1], eax	; insert the neg number to 'data'
	mov [data + edi + 2], byte ' '

	add edi, 3

	jmp find_neg			; jump back to find more neg numbers

end:
	mov eax, 4
	mov ebx, 1
	mov ecx, out_str		; decoration
	mov edx, 14
	int 80h

	add edi, 2			; reset the offset of length from sorter

	mov eax, 4
	mov ebx, 1
	mov ecx, data			; print the array
	mov edx, edi			; edi = length
	int 80h

exit:
	mov eax, 1
	mov ebx, 0
	int 80h

sorter:
	sub edi, 2			; offset array length to match ebx(index)

sort_start:
	mov ebx, 1			; Index = 1: numbers at data[1+3N]
	mov [swapped], byte 0		; Reset swapped to false

comparison:
	mov ax,  [data + ebx]		; Take the first element
	mov dx,  [data + ebx + 3]	; Take the second element
	
	cmp ax, dx			; Compare first to second
	jle no_swap			; If 1st <= 2nd, no need to swap

swap:
	mov [data + ebx + 3], ax	; put ax at dx's position in array
	mov [data + ebx], dx 		; vice versa

	mov [swapped], byte 1		; set swapped to true

no_swap:
	add bx, 3			; increase the counter
	cmp ebx, edi			; if index != count,
	jne comparison			; keep loop going

	cmp [swapped], byte 0		; if there was a swap, array not sorted
	jne sort_start			; go to start, else end sorting
	je  end
