#Laboratory Exercise 4, Assignment 5
.text
	addi 	$s0, $zero, 1			# $s0 = 1
	addi	$s1, $zero, 0			# count = 0
	addi	$s2, $zero, 4			# max 2*4
	addi	$s4, $zero, 1			# step = 1
loop:
	slt	$t1, $s1, $s2			# if s1 < 4 : t1 = 1 else = 0
	beq	$t1, $zero, endloop
	sll 	$s3, $s0, 1
	move	$s0, $s3
	add	$s1, $s1, $s4
	j 	loop
endloop:

