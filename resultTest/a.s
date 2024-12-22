.text
sub:
    addi sp, sp, -16
.L1:
    mv t5, a0
    mv t4, a1
    sw t5, 0(sp)
    sw t4, 4(sp)
    j .L2
.L2:
    lw t4, 0(sp)
    lw t5, 4(sp)
    subw t4, t4, t5
    mv a0, t4
    addi sp, sp, 16
    jr ra
.type sub, @function
.size sub, .-sub
/* end function sub */

.text
.global main
main:
    addi sp, sp, -16
    sd ra, 8(sp)
.L3:
    j .L4
.L4:
    li a4, 5
    sw a4, 0(sp)
    li a4, 2
    sw a4, 4(sp)
    lw t5, 0(sp)
    lw t4, 4(sp)
    mv a1, t4
    mv a0, t5
    call sub
    li a4, 0
    mv a0, a4
    ld ra, 8(sp)
    addi sp, sp, 16
    jr ra
.type main, @function
.size main, .-main
/* end function main */

.section .note.GNU-stack,"",@progbits
