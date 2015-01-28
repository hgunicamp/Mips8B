; Inicialização
addi $1 $0 77
addi $2 $0 -128
addi $3 $0 127
addi $4 $0 -1
addi $5 $0 -133
addi $6 $0 84
addi $7 $0 -48 ; (-48 = 207)

; Salva na mem com base (249 a 254)
sb $6 $7 42
sb $5 $7 43
sb $4 $7 44
sb $3 $7 45
sb $2 $7 46
sb $1 $7 47

; Carrega da mem com base
lb $6 $7 44
lb $5 $7 47
lb $4 $7 45
lb $3 $7 42
lb $2 $7 46
lb $1 $7 43
