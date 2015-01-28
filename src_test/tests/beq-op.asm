; Inicialização
addi $1 $0 -128
addi $2 $0 -128
addi $3 $0 127
addi $4 $0 127
addi $5 $0 126
addi $6 $0 -127
addi $7 $0 0

; Saltos que devem ocorrer
beq $1 $2 2
addi $4 $0 77
beq $3 $4 2
addi $3 $0 77
beq $7 $0 2
addi $2 $0 77
beq $6 $6 2
addi $2 $0 77

; Saltos que nao devem ocorrer
beq $1 $6 8
beq $1 $7 7
beq $3 $1 6
beq $4 $5 5
beq $2 $6 4
beq $1 $0 3
beq $3 $0 2 ; Executa instrução destrutiva se tomado
beq $0 $0 2 ; Pula instrução destrutiva
addi $1 $0 77

; Saltos negativos e sempre tomados
beq $3 $3 4 ; 1
beq $7 $7 4 ; 3
beq $6 $6 4 ; 5
addi $7 $0 77 ; Instrução destrutiva pulada
beq $5 $5 -3 ; 2
beq $2 $2 -3 ; 4


; beq como NOPs
beq $0 $0 1
beq $1 $1 1
beq $2 $2 1
beq $3 $3 1
beq $4 $4 1
beq $5 $5 1
beq $6 $6 1
beq $7 $7 1
