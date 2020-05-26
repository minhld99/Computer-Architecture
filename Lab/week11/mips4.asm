.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv COUNTER         0xFFFF0013
.eqv MASK_CAUSE_COUNTER 0x00000400 
.eqv MASK_CAUSE_KEYMATRIX 0x00000800

.data
msg_keypress: .asciiz "Someone has pressed a key!\n" 
msg_counter: .asciiz "Time inteval!\n"

.text
main:
	li 	$t1, IN_ADRESS_HEXA_KEYBOARD
	li 	$t3, 0x80 		# bit 7 = 1 to enable
	
	sb 	$t3, 0($t1)
	li 	$t1, COUNTER 
	sb 	$t1, 0($t1)
Loop:
	nop
	nop
	nop	
sleep:	addi 	$v0, $zero, 32
	li	$a0, 200
	syscall
	nop
	b 	Loop
end_main:

.ktext 0x80000180
IntSR:	
dis_int:
	li 	$t1, COUNTER 		# BUG: must disable with Time Counter
	sb 	$zero, 0($t1)		
get_caus:
	mfc0 	$t1, $13
IsCount:
	li	$t2, MASK_CAUSE_COUNTER
	and 	$at, $t1, $t2
	beq 	$at, $t2, Counter_Intr
IsKeyMa:
	li 	$t2, MASK_CAUSE_KEYMATRIX
	and	$at, $t1, $t2
	beq 	$at, $t2, Keymatrix_Intr
others: j 	end_process

Keymatrix_Intr: 
	li 	$v0, 4 			# Processing Key Matrix Interrupt 
	la 	$a0, msg_keypress
	syscall
	j 	end_process
Counter_Intr: 
	li 	$v0, 4 			# Processing Counter Interrupt 
	la 	$a0, msg_counter	
	syscall
	j 	end_process
end_process:
	mtc0 	$zero, $13
en_int:
	li 	$t1, COUNTER
	sb 	$t1, 0($t1)
next_pc:
	mfc0 	$at, $14
	addi	$at, $at, 4
	mtc0	$at, $14
return:	eret