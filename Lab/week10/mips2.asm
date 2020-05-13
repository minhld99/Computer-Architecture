.eqv MONITOR_SCREEN 0x10010000
.eqv RED            0x00FF0000
.text	
	li 	$k0, MONITOR_SCREEN	
	li	$s0, 1
	li	$s1, 1
	li	$t1, 8
	addi	$k0, $k0, 1584
loop:	
	beq	$s0, $t1, next_row 	
	li 	$t0, RED
	add	$k0, $k0, 4
	sw  	$t0, 0($k0)
	addi	$s0, $s0, 1
	j	loop
next_row:
	addi	$s1, $s1, 1	
	beq	$s1, $t1, end
	addi	$k0, $k0, 100
	li	$s0, 1
	j 	loop
end: