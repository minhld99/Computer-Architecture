.text
main:
	li $s0,-10
	li $s1,20
	li $s2,-30
	li $s3,0
	li $s4,10
	li $s5,-20
	li $s6,30
	li $s7,-40
	li $t1,1
	li $t2,1
	li $t3,1
	jal init
	nop
	li $t4,9
	sub $a0,$t4,$t2
	sub $a1,$t4,$t3
	j end
	nop
endmain:
init:
	add $v0,$s7,$zero
	add $v1,$s7,$zero
push:
	addi $sp,$sp,-32
	sw $s0,28($sp)
	sw $s1,24($sp)
	sw $s2,20($sp)
	sw $s3,16($sp)
	sw $s4,12($sp)
	sw $s5,8($sp)
	sw $s6,4($sp)
	sw $s7,0($sp)
pop:
	addi $sp,$sp,4
	lw $a1,0($sp)
	addi $t1,$t1,1
	sub $t0,$a1,$v0
	bltz $t0,okay1
	nop
	add $v0,$a1,$zero
	add $t2,$t1,$zero
okay1:
	sub $t0,$a1,$v1
	bgtz $t0,okay2
	nop
	add $v1,$a1,$zero
	add $t3,$t1,$zero
okay2:
	bne $a1,$s0,pop
	nop
done:
	jr $ra
# Largest: $v0,$a0
# Smallest: $v1,$a1
end: