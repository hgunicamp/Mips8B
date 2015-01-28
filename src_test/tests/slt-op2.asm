; Slt para teste de sinal
addi $1 $0 127
addi $2 $0 -1
addi $3 $0 -128
addi $4 $0 0
addi $5 $0 -4
addi $6 $0 1
addi $7 $0 17
slt $7 $0 $7
slt $6 $6 $0
slt $5 $0 $5
slt $4 $4 $0
slt $3 $0 $3
slt $2 $2 $0
slt $1 $0 $2

; Casos extremos e próximos
addi $1 $0 -128
addi $2 $0 -127
addi $3 $0 127
addi $4 $0 126
slt $5 $2 $1
slt $6 $1 $2
slt $7 $2 $3
slt $5 $3 $2
slt $6 $4 $3
slt $7 $3 $4
slt $5 $3 $1
slt $6 $1 $3

addi $4 $0 2
addi $5 $0 1
addi $6 $0 -1
addi $7 $0 -2
slt $1 $4 $5
slt $2 $5 $4
slt $3 $5 $6
slt $1 $6 $5
slt $2 $6 $7
slt $3 $7 $6
slt $1 $6 $4
slt $2 $4 $6
slt $3 $7 $5
slt $1 $5 $7
