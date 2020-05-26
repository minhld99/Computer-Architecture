.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012 
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014
.data
Message: .asciiz "Key scan code "
.text
main:
	li 	$t1, IN_ADRESS_HEXA_KEYBOARD 
	li 	$t3, 0x80 		# bit 7 = 1 to enable 
	li	$t4, 1
	sb 	$t3, 0($t1)
	
	xor 	$s0, $s0, $s0
Loop:	addi	$s0, $s0, 1
prn_seq:
	addi	$v0, $zero, 1
	add	$a0, $s0, $zero
	syscall
prn_eol:
	addi	$v0, $zero, 11
	li	$a0, '\n'
	syscall
sleep:
	addi	$v0, $zero, 32
	li	$a0, 300
	syscall
	nop
	b	Loop
end_main:

.ktext 0x80000180
IntSR:
	addi 	$sp, $sp, 4
	sw 	$ra, 0($sp)
	addi 	$sp, $sp, 4
	sw 	$at, 0($sp)
	addi 	$sp, $sp, 4
	sw 	$v0, 0($sp)
	addi 	$sp, $sp, 4
	sw 	$a0, 0($sp)
	addi 	$sp, $sp, 4
	sw 	$t1, 0($sp)
	addi 	$sp, $sp, 4
	sw 	$t3, 0($sp)
prn_msg:
	addi 	$v0, $zero, 4 
	la 	$a0, Message
	syscall 
get_cod:
	li 	$t1, IN_ADRESS_HEXA_KEYBOARD
	li 	$t3, 0x80
	add	$t3, $t3, $t4 
	sb 	$t3, 0($t1)
	li 	$t1, OUT_ADRESS_HEXA_KEYBOARD
	lb 	$a0, 0($t1)
	beq	$a0, $zero, continue
	j	prn_cod
continue:
	sll	$t4, $t4, 1
	beq	$t4, 8, prn_cod
	j	get_cod
prn_cod:
	li 	$v0, 34
	syscall
	li 	$v0, 11 
	li 	$a0, '\n' 
	syscall
next_pc:
	mfc0 	$at, $14 
	addi 	$at, $at, 4
	mtc0 	$at, $14
restore:
	lw	$t3, 0($sp)
	addi	$sp, $sp, -4
	lw	$t1, 0($sp)
	addi	$sp, $sp, -4
	lw	$a0, 0($sp)
	addi	$sp, $sp, -4
	lw	$v0, 0($sp)
	addi	$sp, $sp, -4
	lw	$ra, 0($sp)
	addi	$sp, $sp, -4
	lw	$ra, 0($sp)	
	addi	$sp, $sp, -4
return: eret
