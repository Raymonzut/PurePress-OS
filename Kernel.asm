BITS 16

global _start

;; Controls
; [ and ] for left and right
; BS and ENTER for up and down

_start:
	mov al,03h
	mov ah,0
	int 10h

	mov bl,2h
	mov cl,0h

	_loop:
		mov ah,02h
		mov dl,bl
		mov dh,cl
		int 10h
		mov ah, 00h
		int 16h

		cmp al,08h ; BS
		je _up

		cmp al,0Dh ; ENTER
		je _down

		cmp al,5Bh ; [
		je _left

		cmp al,5Dh ; ]
		je _right

		cmp ah,2bh ; backslash
		je _back

		cmp al,20h ; everything else except first 32 ASCII chars
		jge _print

		jmp _loop

	_up:
		sub cl,1h
		mov bl,2h
		jmp _loop

	_down:
		add cl,1h
		mov bl,2h
		jmp _loop

	_left:
		sub bl,1h

		; Wrap cursor line up on reaching left border
		cmp bl,1h
		je _up

		jmp _loop

	_right:
		add bl,1h

		; Wrap cursor line down on reaching right border
		cmp bl,41h
		je _down

		jmp _loop

	_back:
		cmp bl,2h
		je _loop

		sub bl,1h

		mov ah,02h
		mov dl,bl
		int 10h

		mov ah,0eh
		mov al,0
		int 10h

		jmp _loop

	_print:
		mov ah,0eh

		cmp al,0Dh
		je _down
		int 10h

		jmp _right
