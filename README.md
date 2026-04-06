# MIPS-Pilha-Express-o-Z
MIPS Pilha Expressão Z
# INPUTS: 
# $a0 = A
# $a1 = B
# $a3 = X
# OUTPUT: $v0 = Z = [(A*X)/(B*X)]^X

    addi $sp, $sp, -16       # reserva espaço na pilha
    sw   $ra, 12($sp)        # salva $ra
    sw   $a0, 8($sp)         # salva A
    sw   $a1, 4($sp)         # salva B
    sw   $a3, 0($sp)         # salva X

    # ax = MULT(A, X)
    lw   $a0, 8($sp)         # $a0 = A
    lw   $a1, 0($sp)         # $a1 = X
    jal  MULT
    move $t0, $v0            # $t0 = ax

    # bx = MULT(B, X)
    lw   $a0, 4($sp)         # $a0 = B
    lw   $a1, 0($sp)         # $a1 = X
    jal  MULT
    move $t1, $v0            # $t1 = bx

    # div = DIV(ax, bx)
    move $a2, $t0            # $a2 = ax (dividendo)
    move $a3, $t1            # $a3 = bx (divisor)
    jal  DIV
    move $t2, $v0            # $t2 = div
