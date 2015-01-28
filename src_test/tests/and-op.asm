;Inicialização
addi $1 $0 137
addi $2 $0 146
addi $3 $0 65
addi $4 $0 63
addi $5 $0 75
addi $6 $0 86
addi $7 $0 97

; And simples
and $7 $4 $5
and $6 $6 $7
and $5 $7 $1
and $4 $2 $3
and $3 $4 $5
and $2 $6 $7
and $1 $1 $2

; $0 como destino
and $0 $5 $2
and $0 $6 $3
and $0 $7 $4
and $0 $1 $5
and $0 $2 $6
and $0 $3 $7

; And como cópia
and $7 $1 $1
and $6 $2 $2
and $5 $3 $3
and $4 $7 $7
and $3 $4 $4
and $2 $5 $5
and $1 $6 $6

; Operando = destino
and $7 $7 $2
and $6 $6 $3
and $5 $5 $4
and $4 $4 $5
and $3 $3 $6
and $2 $2 $7
and $1 $1 $2

; And como NOP
and $7 $7 $7
and $6 $6 $6
and $5 $5 $5
and $4 $4 $4
and $3 $3 $3
and $2 $2 $2
and $1 $1 $1

; And para zerar
and $7 $0 $7
and $6 $0 $6
and $5 $0 $5
and $4 $0 $4
and $3 $0 $3
and $2 $0 $2
and $1 $0 $1
