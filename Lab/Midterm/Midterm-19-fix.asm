# Midterm Ex19 FIX

.data
input: .space 100 
array: .word	0:10			# split number into individual digit and store in array
message1: .asciiz "\n\n----------- Let's start -----------"
str_err: .asciiz "\nERROR!! The number contains alpha character"
toolarge: .asciiz "\nERROR!! The number is too large"
message: .asciiz "\nInput: "
result:	.asciiz	"\nResult is: "
contPrompt: .asciiz "\nPress ENTER to continue..."
.text
	li  	$v0, 4      		# print start message
    	la  	$a0, message1		# pointer to start message in memory
    	syscall
	
start:	li  	$v0, 4      		# print input message
    	la  	$a0, message		# pointer to input message in memory
    	syscall
	li  	$v0, 8      		# read a string
	la 	$a0, input		# pointer to input message in memory
	la	$a1, 100		# max readable 100 characters
    	syscall
    	
    	li	$t0, 10			# modulo 10
    	li	$s2, 0			# String index i
check_input:
	slt	$t1, $s2, $t0		# if i < 10, continue
	beqz	$t1, error2		# else -> error: int number is too large (>10 digits)
    	add	$t1, $s2, $a0		# load string[i] address
    	lb	$t2, 0($t1)		# $t2 = string[i]
    	beq	$t2, 10, input_ok	# read until last element '\n'
    	
	slti	$t3, $t2, 48		# if ascii code is less than 48
	bne	$t3, $zero, error1	# it's a character
	slti	$t3, $t2, 58		# if ascii code is greater than 57
	beq	$t3, $zero, error1	# it's a character
	
	addi	$s2, $s2, 1		# i = i + 1
	j	check_input
# After this step, array = [2, 4, 5]
# Array size = $s2 = 3 
input_ok:
	add	$s0, $zero, $a0		# load input to $s0
	jal	init
	
	li  	$v0, 4      		# print result message
    	la  	$a0, result		# pointer to result message in memory
    	syscall
    	move	$a0, $s3		# save result to $v0 for printing
    	li  	$v0, 1     		# print result
    	syscall
    	j	readEnter		# enter to continue
error1:
	li  	$v0, 4      		# print error string
    	la  	$a0, str_err		# pointer to error message in memory
    	syscall
    	j 	readEnter
error2: 
	li  	$v0, 4      		# print error string
    	la  	$a0, toolarge		# pointer to error message in memory
    	syscall
    	j	readEnter
exit:
	li  	$v0, 10     		# exit
    	syscall
############################# Nested loop ###############################
# result = 0								#
# For i = 0 -> array_size:						#
#    tmp = 0								#
#    for j = array_size -> 0:						#
#          if ( i != j ): tmp = tmp * 10 + array[j]			#
#    result = max(result, tmp)						#
#########################################################################
init:
	add	$s1, $t2, $zero	
	li	$s3, 0			# result
	add	$s4, $s2, -1		# nested loop index j = array_size - 1 = 2
loop_i:
	li	$s5, 0 			# nested loop j = 0
	slt	$t2, $s4, $zero		# if i < 0
	bnez	$t2, end		# exit j loop
	li	$s6, 0			# tmp = 0
	j	loop_j			# execute j loop
loop_j:
	slt 	$t2, $s5, $s2		# if j < array_size continue
	beqz 	$t2, check		# exit j loop
	bne	$s4, $s5, update_tmp	# if i != j, update tmp
	addi	$s5, $s5, 1		# else j = j + 1
	j	loop_j
update_tmp:
	mult	$s6, $t0		# tmp * 10
	mflo	$s6			# tmp = tmp * 10
	add	$t2, $s5, $s0		# load string[j] address
	lb	$t2, 0($t2)		# load string[j] value
	addi	$t2, $t2, -48		# atoi(string[i])
	add	$s6, $s6, $t2		# tmp = tmp + string[j]
	addi	$s5, $s5, 1		# j = j + 1
	j	loop_j
check:	slt	$t2, $s3, $s6		# if result < tmp
	bnez	$t2, swap		# result = tmp 
	addi	$s4, $s4, -1		# else i = i - 1
	j	loop_i
swap:	add	$s3, $zero, $s6		# result = tmp
	addi	$s4, $s4, -1		# i = i - 1
	j	loop_i
end:					
	jr	$ra			# return to main
#################################################################################
#				Enter to continue 				#
#################################################################################
readEnter: 				# Ask user to press ENTER to continue
    	li 	$v0, 4
    	la 	$a0, contPrompt
    	syscall
    	li 	$v0, 12 		# sys code for readchar
    	syscall

    	move 	$t0, $v0

    	bne 	$t0, 10, exit 		# exit if not ENTER

    	j 	start 			# return to the calling subroutine
