; Inicializacao do Vetor

; Vetor inicia no byte 200 e termina no 204
addi $1 $0 200
; $2 é o valor inicial para o byte 200
addi $2 $0 137
; $3 fica uma posicao apos a ultima posicao de memoria do vetor
addi $3 $0 205
sb $2 $1 0
addi $1 $1 1
; incremento do valor
addi $2 $2 -17
; Quando $1 == $3, pula próxima instrução e pára
beq $1 $3 2
; Senão, volta
beq $0 $0 -4

; Ordenação

; $1: houve troca
; $6: índice menor
; $7: índice maior
; $5: após final do vetor

; AQUI RECOMECA UMA ETAPA DA ORDENACAO
or $1 $0 $0
addi $6 $0 200
addi $7 $6 1
addi $5 $0 205

; LACO INTERNO ATE O FIM DO VETOR
; Termina quando o $7 passou do fim do vetor
beq $7 $5 11
; $3: byte menor
lb $3 $6 0
; $4: byte maior
lb $4 $7 0
; Troca quando $3 > $4 => setar $2 para 1
slt $2 $4 $3
beq $0 $2 4
addi $1 $1 1
sb $4 $6 0
sb $3 $7 0
add $6 $7 $0
addi $7 $7 1
beq $0 $0 -10

; Termina quando nao ha nenhuma alteracao
beq $1 $0 2
beq $0 $0 -16 ; Se houve mudanca, tudo de novo

; Fica mostrando o vetor ordenado
; $3 fica uma posicao apos a ultima posicao de memoria do vetor
addi $3 $0 205
addi $1 $0 200
lb $2 $1 0
sb $2 $1 0
addi $1 $1 1
; Quando $1 == $3, comeca tudo denovo
beq $1 $3 -4
; Senão, vai ao proximo elemento
beq $0 $0 -4
