#Laboratory Exercise 4, Home Assignment 1
.text
start:
	#addi	$s1, $zero, 10
	#addi	$s2, $zero, 8
	#addi	$s1, $zero, -2
	#addi	$s2, $zero, -1
	li	$s1, 0x7FFFFFFE
	li	$s2, 0x7FFFFFFF
	#li	$s1, 0x80000000
	#li	$s2, 0x80000001
	#addi	$s1, $zero, 5
	#addi	$s2, $zero, 4

	li 	$t0, 0			# No Overflow is default status
	addu 	$s3, $s1, $s2 		# s3 = s1 + s2
	xor 	$t1, $s1, $s2		# Test if $s1 and $s2 have the same sign
	
	bltz 	$t1, EXIT		# If not, exit
	xor	$t2, $s3, $s1 		# Test if $s1 and $s3 have the different sign
	bgtz 	$t2, EXIT		# If not, exit
	li	$t0, 1			# the result is overflow
EXIT:


