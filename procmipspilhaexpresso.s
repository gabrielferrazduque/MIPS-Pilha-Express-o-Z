
# Convenciona-se que $a0 = A, $a1 = B, $a2 = Array[], $a3 = Matriz[]
# PROC1:
Proc1:
    addi $sp, $sp, -24
    sw   $ra, 20($sp)
    sw   $a0, 16($sp)    # salva A
    sw   $a1, 12($sp)    # salva B
    sw   $a2, 8($sp)     # salva Array base
    sw   $a3, 4($sp)     # salva Matriz base

    # Matriz[8] = Array[4] + 8;
    lw   $t0, 8($sp)             # $t0 = Array base
    lw   $t1, 4($sp)             # $t1 = Matriz base
    lw   $t2, 16($t0)            # $t2 = Array[4]
    addi $t2, $t2, 8             # $t2 = Array[4] + 8
    sw   $t2, 32($t1)            # Matriz[8] = $t2

WhileLoop:
    # Carrega valores atuais
    lw   $t0, 16($sp)            # $t0 = A
    lw   $t1, 12($sp)            # $t1 = B
    lw   $t2, 8($sp)             # $t2 = Array base
    lw   $t3, 4($sp)             # $t3 = Matriz base

    lw   $t4, 16($t2)            # $t4 = Array[4]
    lw   $t5, 24($t3)            # $t5 = Matriz[6]
    lw   $t6, 32($t3)            # $t6 = Matriz[8]

    # Condição: (A>B) && (Array[4]>Matriz[6])
    slt  $t7, $t1, $t0           # $t7 = (A>B)
    slt  $t8, $t5, $t4           # $t8 = (Array[4]>Matriz[6])
    and  $t7, $t7, $t8           # $t7 = (A>B)&&(Array[4]>Matriz[6])
    # Ou: Matriz[8]==Array[4]
    sub  $t9, $t6, $t4
    sltiu $t9, $t9, 1            # $t9=1 se igual
    or   $t7, $t7, $t9           # $t7 = condicao final

    beq  $t7, $zero, EndWhile

    # Corpo do while:
    # A = Array[4] + 4
    addi $t4, $t4, 4             
    sw   $t4, 16($sp)            # Atualiza A na pilha

    # Proc2(Matriz[6], B)
    lw   $a0, 24($t3)            # $a0 = Matriz[6]
    lw   $a1, 12($sp)            # $a1 = B
    jal  Proc2
    move $t8, $v1                # $t8 = retorno de Proc2

    # Array[4] = B - A + retorno
    lw   $t1, 12($sp)            # $t1 = B
    lw   $t0, 16($sp)            # $t0 = A
    sub  $t9, $t1, $t0           # $t9 = B - A
    add  $t9, $t9, $t8           # $t9 += Proc2(...)
    sw   $t9, 16($t2)            # Array[4] = resultado

    j    WhileLoop

EndWhile:
    lw   $t1, 4($sp)             # Matriz base
    lw   $t2, 8($sp)             # Array base
    lw   $v0, 24($t1)            # $v0 = Matriz[6]
    lw   $v1, 16($t2)            # $v1 = Array[4]

    lw   $ra, 20($sp)
    addi $sp, $sp, 24
    jr   $ra