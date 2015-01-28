; Inicializa os bytes 244-247 e 248-251
; $1 conta de um em um
addi $1 $0 244
; $2 é o valor inicial para o byte 244
addi $2 $0 -4
; $3 é o valor final esperado para $1
addi $3 $0 252
sb $2 $1 0
addi $1 $1 1
addi $2 $2 1
; Quando $1 == $3, pula próxima instrução e pára
beq $1 $3 2
; Senão, volta
beq $0 $0 -4
; Agora efetua a soma
addi $1 $0 244
addi $2 $0 248
addi $3 $0 252
or $7 $0 $0
lb $4 $1 0
lb $5 $2 0
add $6 $4 $5
sb $6 $3 0
addi $1 $1 1
addi $2 $2 1
addi $3 $3 1
beq $3 $7 2
beq $0 $0 -8