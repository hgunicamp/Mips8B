;Inicialização
addi $1 $0 -128
addi $2 $0 -76
addi $3 $0 127
addi $4 $0 -1
addi $5 $0 53
addi $6 $0 64
addi $7 $0 72

; Add simples
add $7 $1 $2
add $6 $3 $4
add $5 $6 $7
add $4 $7 $1
add $3 $6 $2
add $2 $5 $3
add $1 $4 $5

; $0 como destino
add $0 $1 $2
add $0 $3 $4
add $0 $5 $6
add $0 $0 $0
add $0 $1 $1
add $0 $7 $7

; Add como cópia
add $7 $1 $0
add $6 $2 $0
add $5 $3 $0
add $4 $7 $0
add $3 $4 $0
add $2 $5 $0
add $1 $6 $0

; Operando = destino
add $7 $7 $1
add $6 $6 $2
add $5 $5 $3
add $4 $4 $7
add $3 $3 $4
add $2 $2 $5
add $1 $1 $6

; Add como NOP
add $7 $7 $0
add $6 $6 $0
add $5 $5 $0
add $4 $4 $0
add $3 $3 $0
add $2 $2 $0
add $1 $1 $0

; Add para zerar
add $7 $0 $0
add $6 $0 $0
add $5 $0 $0
add $4 $0 $0
add $3 $0 $0
add $2 $0 $0
add $1 $0 $0
