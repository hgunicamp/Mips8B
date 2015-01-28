; $1 conta de um em um
or $1 $0 $0
; $2 é a somatória de $1
or $2 $0 $0
; $3 é o valor final esperado para $1
addi $3 $0 4
addi $1 $1 1
add $2 $2 $1
; Quando $1 == $3, pula próxima instrução e pára
beq $1 $3 2
; Senão, volta
beq $0 $0 -4