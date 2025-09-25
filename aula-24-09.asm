.data
    origem: .asciiz "Josiane é boboca"

.text
main:
    # imprime string origem
    la $a0, origem      
    li $v0, 4      
    syscall
    
    # imprime '/'
    li $a0, 47     # ASCII de '/'
    li $v0, 11      
    syscall

    # chamada para copiar a string
    la $a0, origem      
    jal MEMCOPY  # faz a cópia entre blocos

    # imprime o conteúdo da área destino
    move $a0, $v0  
    li $v0, 4      
    syscall

    # encerra programa
    li $v0, 10
    syscall


# ------------------------------------------------
# MEMCOPY
# Procedimento de cópia do conteúdo de memória
# Entrada: $a0 - endereço da string de origem
# Saída:   $v0 - endereço da nova string copiada (alocada dinamicamente)
# ------------------------------------------------
MEMCOPY:
    # salva registradores que serao usados
    addi $sp, $sp, -8
    sw $a0, 0($sp)
    sw $ra, 4($sp)

    # passo 1: calcular tamanho da string origem
    
    move $t0, $a0       # $t0 = origem
    li $t1, 0           # contador de tamanho

loop:
    lb $t2, 0($t0)
    beqz $t2, loop_feito
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j loop_feito

loop_feito:
    addi $t1, $t1, 1    # +1 para incluir o '\0'

    # passo 2: alocar memoria (syscall 9)
    
    move $a0, $t1       # $a0 = tamanho
    li $v0, 9           # syscall 9 = sbrk
    syscall
    move $t3, $v0       # $t3 = destino alocado
                        # também sera retornado em $v0 ao final

    # passo 3: copiar byte a byte
    
    lw $t0, 0($sp)      # $t0 = origem novamente
    move $t4, $t3       # $t4 = destino

copiando:
    lb $t2, 0($t0)
    sb $t2, 0($t4)
    beqz $t2, feito
    addi $t0, $t0, 1
    addi $t4, $t4, 1
    j copiando

feito:
    move $v0, $t3       # endereço da string copiada

    # restaura registradores
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    jr $ra              # retorna para main
