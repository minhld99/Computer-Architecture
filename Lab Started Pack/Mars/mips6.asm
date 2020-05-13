.data
X: .word 4
Y: .word 5
.text
	la $t8, X
	lw $t1, 4($t8)
	add 	$t0, $t1, $t2
	addi 	$t0, $t1, 100