;Inicialização
addi $1 $0 -128
addi $2 $0 -76
addi $3 $0 127
addi $4 $0 -1
addi $5 $0 53
addi $6 $0 64
addi $7 $0 72

; Sub simples
sub $7 $1 $2
sub $6 $3 $4
sub $5 $6 $7
sub $4 $7 $1
sub $3 $6 $2
sub $2 $5 $3
sub $1 $4 $5

; $0 como destino
sub $0 $1 $2
sub $0 $3 $4
sub $0 $5 $6
sub $0 $0 $0
sub $0 $1 $1
sub $0 $7 $7

; Sub como cópia
sub $7 $1 $0
sub $6 $2 $0
sub $5 $3 $0
sub $4 $7 $0
sub $3 $4 $0
sub $2 $5 $0
sub $1 $6 $0

; Operando = destino
sub $7 $7 $1
sub $6 $6 $2
sub $5 $5 $3
sub $4 $4 $7
sub $3 $3 $4
sub $2 $2 $5
sub $1 $1 $6

; Sub como NOP
sub $7 $7 $0
sub $6 $6 $0
sub $5 $5 $0
sub $4 $4 $0
sub $3 $3 $0
sub $2 $2 $0
sub $1 $1 $0

; Sub para zerar 1
sub $7 $7 $7
sub $6 $6 $6
sub $5 $5 $5
sub $4 $4 $4
sub $3 $3 $3
sub $2 $2 $2
sub $1 $1 $1

; Sub para zerar 2
sub $7 $0 $0
sub $6 $0 $0
sub $5 $0 $0
sub $4 $0 $0
sub $3 $0 $0
sub $2 $0 $0
sub $1 $0 $0
