.data
.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014
.text
main:	li	$t1, IN_ADRESS_HEXA_KEYBOARD
	li	$t2, OUT_ADRESS_HEXA_KEYBOARD
	li 	$t3, 0x01			# check row 4 with key C, D, E, F
	li	$t4, 0x08
polling:
	sb	$t3, 0($t1)
	lb	$a0, 0($t2)
print:
	li	$v0, 34
	syscall
sleep:
	li	$a0, 100
	li	$v0, 32
	syscall
back_to_polling:
	beq	$t3, $t4, reset
	sll	$t3, $t3, 1
	j	polling 
reset:	
	li	$t3, 0x01
	jal	polling