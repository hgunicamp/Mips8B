; Addi como inicialização
addi $1 $0 -128
addi $2 $0 -76
addi $3 $0 127
addi $4 $0 -1
addi $5 $0 53
addi $6 $0 64
addi $7 $0 72

; SH simples
sra  $7 $1 2
srl $6 $3 4
sll $5 $6 7
sra $4 $7 1
srl $4 $7 1
sll $3 $6 2
sra $2 $5 3
sll $1 $4 5

; $0 como destino
sra $0 $1 2
srl $0 $3 4
sll $0 $5 6
sra $0 $0 0
srl $0 $1 1
sll $0 $7 7

; SH como cópia
sra $7 $1 0
srl $6 $2 0
sll $5 $3 0
sra $4 $7 0
srl $3 $4 0
sll $2 $5 0
sra $1 $6 0

; Operando = destino
sra $7 $7 1
srl $6 $6 2
sll $5 $5 3
sra $4 $4 7
srl $3 $3 4
sll $2 $2 5
sra $1 $1 6

; Addi como NOP
sra $7 $7 0
srl $6 $6 0
sll $5 $5 0
sra $4 $4 0
srl $3 $3 0
sll $2 $2 0
sra $1 $1 0
