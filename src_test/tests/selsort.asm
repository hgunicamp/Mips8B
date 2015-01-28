; Vetor inicia no byte 200
addi $1 $0 200
; $2 é o valor inicial para o byte 200
addi $2 $0 137
; $3 é o valor final esperado para $1
addi $3 $0 255
sb $2 $1 0
addi $1 $1 1
addi $2 $2 17
; Quando $1 == $3, pula próxima instrução e pára
beq $1 $3 2
; Senão, volta
beq $0 $0 -4

; Ordenação

; $6: índice lento
; $7: índice rápido
; $5: após final do vetor
addi $6 $0 200
addi $5 $0 255

beq $6 $5 14
; $4: byte lento
lb $4 $6 0
addi $7 $6 1
; $3: byte rápido
lb $3 $7 0
; Troca quando $3 < $4 => setar $2 para 1
slt $2 $3 $4
beq $0 $2 4
sb $3 $6 0
sb $4 $7 0
or $4 $3 $0
addi $7 $7 1
beq $7 $5 2
beq $0 $0 -8
addi $6 $6 1
beq $0 $0 -13