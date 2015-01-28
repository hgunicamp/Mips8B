; Addi como inicialização
addi $1 $0 -128
addi $2 $0 -76
addi $3 $0 127
addi $4 $0 -1
addi $5 $0 53
addi $6 $0 64
addi $7 $0 72

; Addi simples
addi $7 $1 -2
addi $6 $3 4
addi $5 $6 -7
addi $4 $7 1
addi $3 $6 -2
addi $2 $5 3
addi $1 $4 -5

; $0 como destino
addi $0 $1 2
addi $0 $3 4
addi $0 $5 6
addi $0 $0 0
addi $0 $1 1
addi $0 $7 7

; Addi como cópia
addi $7 $1 0
addi $6 $2 0
addi $5 $3 0
addi $4 $7 0
addi $3 $4 0
addi $2 $5 0
addi $1 $6 0

; Operando = destino
addi $7 $7 1
addi $6 $6 2
addi $5 $5 3
addi $4 $4 7
addi $3 $3 4
addi $2 $2 5
addi $1 $1 6

; Addi como NOP
addi $7 $7 0
addi $6 $6 0
addi $5 $5 0
addi $4 $4 0
addi $3 $3 0
addi $2 $2 0
addi $1 $1 0

; Addi para zerar
addi $7 $0 0
addi $6 $0 0
addi $5 $0 0
addi $4 $0 0
addi $3 $0 0
addi $2 $0 0
addi $1 $0 0
