;cneirabustos@gmail.com
; This code is from 
; Introduction to 64 Bit Intel Assembly Language Programming for Linux: Second Edition Paperback – June 23, 2012
;


struc node
        n_value resq    1
        n_next  resq    1
        align   8
 endstruc
        extern printf
        extern malloc
        extern scanf

 newlist:
         xor eax,eax
         ret
 insert:
        .list   equ     0
        .k      equ     8
        push rbp
        mov rbp, rsp
        sub rsp, 16
        mov [rsp+.list], rdi
        mov [rsp+.k], rsi
        mov edi, node_size
        call malloc
        mov r8, [rsp+.list]
        mov [rax+n_next],r8
        mov r9, [rsp+.k]
        mov [rax+n_value],r9
        leave
        ret

 print:
        segment .data
        .print_fmt:
        db "%ld  ",0
        .newline
        db  0x0a,0
        segment .text
        global  main
.rbx  equ  0
        push rbp
        mov rbp, rsp
        sub rsp, 16
        mov [rsp+.rbx], rbx
        cmp rdi, 0
        je .done
        mov  rbx, rdi

.more:
        lea  rdi, [.print_fmt]
        mov  rsi, [rbx+n_value]
        xor  eax,eax
        call printf
        mov rbx, [rbx+n_next]
        cmp rbx, 0
        jne .more

.done:
        lea  rdi,[.newline]
        xor  eax,eax
       call printf
        mov rbx, [rsp+.rbx]
        leave
        ret

 main:
         .list equ 0
         .k equ 8
        segment .data
.scanf_fmt:
         db "%ld",0
         segment .text
         push rbp
         mov rbp, rsp
         sub rsp, 16
         call newlist
         mov [rsp+.list],rax
.more    lea rdi, [.scanf_fmt]
         lea    rsi, [rsp+.k]
         xor eax,eax
         call scanf
         cmp rax ,1
         jne .done
         mov rdi, [rsp+.list]
         mov rsi, [rsp+.k]
         call insert
         mov [rsp+.list],rax
         mov rdi,rax
         call print
         jmp .more
.done    leave
         ret
