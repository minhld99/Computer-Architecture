.eqv KEY_CODE   0xFFFF0004
.eqv KEY_READY  0xFFFF0000
.eqv DISPLAY_CODE 0xFFFF000C 
.eqv DISPLAY_READY 0xFFFF0008
.eqv MASK_CAUSE_KEYBOARD 0x0000034
.text 
	li   	$k0, KEY_CODE
        li   	$k1, KEY_READY
	li   	$s0, DISPLAY_CODE
	li	$s1, DISPLAY_READY
loop: 	nop
WaitForKey:  
	lw	$t1, 0($k1)
	beq 	$t1, $zero, WaitForKey
MakeIntR: 
	teqi 	$t1, 1
	j 	loop
	
.ktext 0x80000180
get_caus:
	mfc0 	$t1, $13
IsCount:
	li 	$t2, MASK_CAUSE_KEYBOARD
	and   	$at, $t1, $t2
	beq   	$at, $t2, Counter_Keyboard
	j    	end_process
Counter_Keyboard:
ReadKey:
	lw 	$t0, 0($k0)
WaitForDis:
	lw	$t2, 0($s1)
	beq	$t2, $zero, WaitForDis
Encrypt:
	addi	$t0, $t0, 1
ShowKey:
	sw 	$t0, 0($s0)
	nop
end_process:
next_pc: 
	mfc0 	$at, $14
	addi    $at, $at, 4
	mtc0 	$at, $14	
return: eret
