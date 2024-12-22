.section .text
.global _start

_start:
    call main
    li a7, 93         # syscall number for exit
    ecall
