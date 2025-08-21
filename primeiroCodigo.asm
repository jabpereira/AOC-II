.data

mensagem_entrada: .asciiz "\nDigite um numero inteiro: "
mensagem_saida: .asciiz "\nResultado: "

.text 
# imprime o valor 10
#li $v0, 1
#li $a0, 10
#syscall 

# imprime a mensagem 
li $v0, 4 
la $a0, mensagem_entrada
syscall 

# ler um valor inteiro
li $v0, 5 
syscall

move $t0, $v0 #copiar valor de v0 sobre t0

# imprime a mensagem 
li $v0, 4 
la $a0, mensagem_saida
syscall 

# imprime valor inteiro lido
li $v0, 1
move $a0, $t0
syscall 




 
