; Inicialização
addi $1 $0 -76
addi $2 $0 -128
addi $3 $0 127
addi $4 $0 -1
addi $5 $0 53
addi $6 $0 64
addi $7 $0 72

; Salva na mem
sb $7 $0 248
sb $6 $0 249
sb $5 $0 250
sb $4 $0 251
sb $3 $0 252
sb $2 $0 253
sb $1 $0 254

; Carrega ordenado da mem
lb $7 $0 252
lb $6 $0 248
lb $5 $0 249
lb $4 $0 250
lb $3 $0 251
lb $2 $0 254
lb $1 $0 253

; $0 como destino
lb $0 $0 252
lb $0 $0 248
lb $0 $0 249
lb $0 $0 250
lb $0 $0 251
lb $0 $0 254
lb $0 $0 253

; Sb com base (negativa) - salva permutação inversa
addi $1 $0 -5
sb $2 $1 248
sb $3 $1 249
sb $4 $1 250
sb $5 $1 251
sb $6 $1 252
sb $7 $1 253

; Carrega ordenado descrescente da mem, com base (negativa)
lb $7 $1 252
lb $6 $1 248
lb $5 $1 249
lb $4 $1 250
lb $3 $1 251
lb $2 $1 254
