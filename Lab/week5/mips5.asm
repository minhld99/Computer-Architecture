#Laboratory Exercise 5, Assignment 5
.data
input: .space 21
Message: .asciiz "Nhap tung ki tu (max 20): "
.text
	li	$s1, 0			# i = 0
	li	$s2, 20			# max length = 20
	la	$s3, input		# luu dia chi string vao $s3
	
	li 	$v0, 4
	la 	$a0, Message 
	syscall				# in message
loop:
     	li 	$v0, 12 
     	syscall				# read character
     	beq	$v0, '\n', end_input	# kiem tra co phai ki tu enter
     	add	$t0, $s3, $s1		# lay dia chi ki tu thu i
     	sb	$v0, 0($t0)		# luu ki tu do vao dia chi tuong ung
	sgt 	$t1, $s1, $s2		# i > 20 -> 1 : 0?
	bne	$t1, $zero, exceed_max	# vuot qua 20 -> ket thuc
	addi	$s1, $s1, 1		# i = i + 1 
	j 	loop
end_input: 			
exceed_max: 
	subi 	$s1, $s1, 1		# remove null pointer
print_reverse:
	slt	$t0, $s1, $0		# i < 0 -> 1 : 0?
	bne	$t0, $zero, exit	# i < 0 thi exit
	add	$t0, $s3, $s1		# lay dia chi ki tu thu i
	lb	$t1, 0($t0)		# luu ki tu i vao thanh ghi $t1
	li	$v0, 11			# in string ra man hinh
	move 	$a0, $t1		# move ki tu i qua $a0
	subi	$s1, $s1, 1		# i = i - 1
	syscall
	j	print_reverse
exit:
			 
