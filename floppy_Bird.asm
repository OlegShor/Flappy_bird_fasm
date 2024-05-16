org 7c00h

bird equ 0x0Ff0
nex equ 0x0Ff2
grav equ 0x0Ff4
pass equ 0x0ff6
sid equ 0x0ff8

start:
  mov ax, 2h
  int 10h
  mov ax, 0xb800
  mov es, ax          ;задать vga tex modecm
  mov ax, 0x0000
  mov di, ax
  mov word [bird], 13  ; установка начальной позиции пцицы
  mov word [grav], 0 ; установка гравитации
  mov word [nex], 0
  mov word [pass], 18
  mov word [sid], 5
  .maingameloop:    ; отрисовка птицы
    mov ax, [bird]
    add ax, [grav]
    cmp ax, 24 ; проверка чтобы пцица не упала за экран
    jnc .aax
    .met:
    mov word[bird], ax
    mov bl, 80 * 2
    mul bl
    add ax, 10   
    mov bx, ax
    mov ax, 0x0f10
    mov dx, [es:di + bx] ; проверка на врезание
    cmp dx, 0x0A08
    mov [es:di + bx], ax ; сама отрисовка
    jz game_ower
    inc word [grav]
    mov ax, [grav]
    cmp ax, 24 ; проверка чтобы пцица не упала за экран
    jnc .aax
    mov [grav], ax
    push bx
    call sleep
    pop bx
    mov ax, 0x0a2a
    mov [es:di + bx], ax ; оставляет за пцицей след
    inc word [nex]
    call mov_screen
    cmp word [nex], 15
    jnc .pipe
    .pipe_back:
    call Press
    jmp .maingameloop


  .aax:
    mov ax, 24  
    jmp .met     

  .pipe: ; рисование трубы
    cmp word [nex], 18
    jnc .beck
    mov cx, 25
    mov bx, 158
    mov ax, 0x0A08
    .metca:
      cmp cx, word [pass]
      jc .if ; проверка на пропуск
      .no_pass_:
      mov [es:di + bx], ax
      .pass_:
      add bx, 160
      loop .metca
    jmp .pipe_back
    .beck:
      call rand
      mov word [nex], 0
      jmp .pipe_back
    .if:
      add cx, 5
      cmp cx, word [pass]
      jnc .pass
      jmp .no_pass
    .pass:
      sub cx, 5
      jmp .pass_
    .no_pass:
      sub cx, 5
      jmp .no_pass_

sleep:
    mov ah, 86h
    mov al, 0
    mov cx, 0x0001
    mov dx, 0xffff
    int 15h
    ret

mov_screen:
  mov cx, 25*79
  xor ax, ax
  xor bx, bx
  .metca:
    mov dx, [es:di + bx + 2]
    mov [es:di + bx], dx
    add bx, 2
    inc ax
    cmp ax, 79
    jnb .last
    .m:
    loop .metca
    ret

    .last:
      mov [es:di + bx + 1], word 0
      xor ax, ax
      add bx, 2
      jmp .m

Press:
  mov ah, 0x01
  int 0x16
  jz .end
  xor ax, ax
  int 0x16
  cmp al, 0x1B
  jne .ok
  int 19h
  .ok:
    mov word [grav], 0
    sub word [bird], 2
  .end:
    ret



rand:
  mov ax, [sid]
  mov dx, 9973
  mul dx
  add ax, 12345
  mov word [sid], ax
  shr ax, 4
  mov dx, 0
  mov bx, 20
  div bx
  add dx, 6
  mov [pass], dx
  ret

game_ower:
  mov cx, 80
  .metca:
    push cx
    call mov_screen
    call sleep
    pop cx
    loop .metca
  jmp start


times 510 - ($ - $$) db 0
db 0x55, 0xAA ;Загрузочная сигнатура  
