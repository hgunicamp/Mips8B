;Inicialização
addi $1 $0 7
addi $2 $0 6
addi $3 $0 5
addi $4 $0 4
addi $5 $0 5
addi $6 $0 6
addi $7 $0 7

; Or simples
or $7 $1 $2
or $6 $3 $4
or $5 $6 $7
or $4 $7 $1
or $3 $6 $2
or $2 $5 $3
or $1 $4 $5

; $0 como destino
or $0 $1 $2
or $0 $3 $4
or $0 $5 $6
or $0 $0 $0
or $0 $1 $1
or $0 $7 $7

; Or como cópia
or $7 $1 $1
or $6 $2 $2
or $5 $3 $3
or $4 $7 $7
or $3 $4 $4
or $2 $5 $5
or $1 $6 $6

; Operando = destino
or $7 $7 $1
or $6 $6 $2
or $5 $5 $3
or $4 $4 $7
or $3 $3 $4
or $2 $2 $5
or $1 $1 $6

; Or como NOP
or $7 $7 $7
or $6 $6 $6
or $5 $5 $5
or $4 $4 $4
or $3 $3 $3
or $2 $2 $2
or $1 $1 $1

; Or para zerar
and $7 $0 $0
and $6 $0 $0
and $5 $0 $0
and $4 $0 $0
and $3 $0 $0
and $2 $0 $0
and $1 $0 $0
