.data
input: .space 32 
message1: .asciiz "\n\n----------- Let's start -----------"
toolarge: .asciiz "\nThe number is too large"
message: .asciiz "\nInput: "
result:	.asciiz	"\nResult is: "
array: .word	0:10			# split number into individual digit and store in array
contPrompt: .asciiz "\nPress ENTER to continue..."
.text
	li  	$v0, 4      		# print start message
    	la  	$a0, message1		# pointer to start message in memory
    	syscall
	
start:	li  	$v0, 4      		# print input message
    	la  	$a0, message		# pointer to input message in memory
    	syscall
	li  	$v0, 5      		# read an integer
    	syscall
    	
	li	$t0, 10			# modulo 10
	add	$s0, $zero, $v0		# load input to $s0
	la	$s1, array		# load array address to $s1
	li	$s2, 0			# array index
main:	
	jal	split
	li  	$v0, 4      		# print result message
    	la  	$a0, result		# pointer to result message in memory
    	syscall
    	move	$a0, $s3		# save result to $v0 for printing
    	li  	$v0, 1     		# print result
    	syscall
    	j	readEnter		# enter to continue
exit:
	li  	$v0, 10     		# exit
    	syscall
######### Split number into individual digit and store in array #########
# Lấy ví dụ số 245: Đầu tiên cần tách 3 số vào 1 mảng			#
# 245 % 10 = 5 --> lưu số 5 vào mảng					#
# 245 / 10 = 24								#
# 24 % 10 = 4 --> lưu số 4 vào mảng					#
# 24 / 10 = 2								#
# 2 % 10 = 2 --> lưu số 2 vào mảng					#
#########################################################################	
split:
	slt	$t2, $s2, $t0		# if i < 10, continue
	beqz	$t2, error		# else -> error: int number is too large (>10 digits)
	div	$s0, $t0		# 245 % 10 = 24(quotient) + 5(remainder)
	mfhi	$t1			# remainder
	sll	$t2, $s2, 2		# 4 * i
	add	$t2, $s1, $t2		# load array[i] address
	sw 	$t1, 0($t2)	 	# save remainder to array[i]
	mflo	$s0			# quotient
	beqz	$s0, init		# if quotient = 0 (2 % 10 = 0) -> go to next step
	addi	$s2, $s2, 1		# else i = i + 1
	j	split
# After this step, array = [5, 4, 2]
# Array size = $s2 = 3
error:
	li  	$v0, 4      		# print error string
    	la  	$a0, toolarge		# pointer to error message in memory
    	syscall
    	j 	exit
############################# Nested loop ###############################
# result = 0								#
# For i = 0 -> array_size:						#
#    tmp = 0								#
#    for j = array_size -> 0:						#
#          if ( i != j ): tmp = tmp * 10 + array[j]			#
#    result = max(result, tmp)						#
#########################################################################
init:	
	li	$s3, 0			# result
	li	$s4, 0			# loop index i = 0
	addi	$t3, $s2, 1		# array_size
loop_i:
	add	$s5, $s2, $zero		# nested loop index j = array_size - 1 = 2
	slt 	$t2, $s4, $t3		# if i < array_size continue
	beqz 	$t2, end		# else -> end
	li	$s6, 0			# tmp = 0
	j	loop_j			# execute j loop
loop_j:
	slt	$t2, $s5, $zero		# if j < 0
	bnez	$t2, check		# exit j loop
	bne	$s4, $s5, update_tmp	# if i != j, update tmp
	addi	$s5, $s5, -1		# else j = j - 1
	j	loop_j
update_tmp:
	mult	$s6, $t0		# tmp * 10
	mflo	$s6			# tmp = tmp * 10
	sll	$t2, $s5, 2		# j = j * 4
	add	$t2, $t2, $s1		# load array[j] address
	lb	$t2, 0($t2)		# load array[j] value
	add	$s6, $s6, $t2		# tmp = tmp + array[j]
	addi	$s5, $s5, -1		# j = j - 1
	j	loop_j
check:	slt	$t2, $s3, $s6		# if result < tmp
	bnez	$t2, swap		# result = tmp 
	addi	$s4, $s4, 1		# else i = i + 1
	j	loop_i
swap:	add	$s3, $zero, $s6		# result = tmp
	addi	$s4, $s4, 1		# i = i + 1
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