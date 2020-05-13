# Laboratory Exercise 5, Assignment 2
.data
Message1: 	.asciiz 	"Nhap so nguyen thu nhat: "
Message2: 	.asciiz 	"Nhap so nguyen thu hai: "
Result1:	.asciiz		"The sum of "
Result2:	.asciiz		" and "
Result3:	.asciiz		" is "
.text
	# getting first input.
	li 	$v0, 4
	la 	$a0, Message1
    	syscall
    	li 	$v0, 5
    	syscall
    	move 	$s0, $v0
    	# getting second input.
    	la 	$a0, Message2
    	li 	$v0, 4
    	syscall
    	li 	$v0, 5
    	syscall
    	move 	$s1, $v0
   	# calculate & print out the result.
    	add 	$s3, $s0, $s1
  
    	li 	$v0, 4
	la 	$a0, Result1
    	syscall
    	li 	$v0, 1
    	move 	$a0, $s0
    	syscall
    	li 	$v0, 4
	la 	$a0, Result2
    	syscall
    	li 	$v0, 1
    	move 	$a0, $s1
    	syscall
    	li 	$v0, 4
	la 	$a0, Result3
    	syscall
    	li 	$v0, 1
    	move 	$a0, $s3
    	syscall
    	# end program.
    	li 	$v0, 10
    	syscall
 
 
 