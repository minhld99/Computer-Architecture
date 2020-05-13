# Assignment 4
.data
A: .word 7, -2, 4, 1, 5, 6, 7, 3, 6, 8, 8, 59, 5
.text
main:		la 	$a0,A    		#$a0 = Address(A[0])
    		li 	$s0,13  		#length of array $s0,  length 
    		j 	sort      		#sort
after_sort:  	li 	$v0, 10 		#exit
		syscall
end_main:
#-----------------------------------------------------------------
sort:  		li 	$t0, 1   		# i = 1
		li 	$t1, 0   		# key = 0 (the next element we need to sort)
		li 	$t2, 0   		# j = 0
loop:		slt 	$v0, $t0, $s0 		# set $v0 = 1 when i < length
		beq 	$v0, $zero, end_loop   	# if i >= length --> end loop
    		add 	$t3, $t0, $t0      	# $t3 = 2i
     		add 	$t3, $t3, $t3      	# $t3 = 4i
     		add 	$t3, $t3, $a0      	# $t3 stores address of A[i]
    		lw 	$t1, 0($t3)         	# key = A[i]
     		add 	$t2, $t0, -1       	# j = i - 1
while:		slt 	$v0, $t2, $zero     	# set $v0 = 1 when j < 0
    		bne 	$v0, $zero, end
    		add 	$t3, $t2, $t2       	# $t3 = 2*j
    		add 	$t3, $t3, $t3       	# $t3 = 4*j
    		add 	$t3, $t3, $a0       	# $t3 stores address A[j]
    		lw 	$t4, 0($t3)          	# Load A[j]
    		slt 	$v0, $t1, $t4       	# $v0 = 1 if A[j] > key
    		beq 	$v0, $zero, end   	# if key >=  A[j] --> end
    		sw 	$t4, 4($t3)          	# A[j+1] = A[j]
    		add 	$t2, $t2, -1        	# j = j - 1
    		j 	while
end:		add 	$t3, $t2, $t2       	# $t3 = 2j
    		add 	$t3, $t3, $t3       	# $t3 = 4j
    		add 	$t3, $t3, $a0       	# $t3 stores address A[j]
    		sw 	$t1, 4($t3)          	# A[j+1] = key
    		add 	$t0, $t0, 1         	# i = i + 1
    		j 	loop
end_loop:


