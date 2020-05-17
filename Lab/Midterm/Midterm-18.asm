# Midterm Exercise 18

.data
tmp: .space 32				# save current word that we have just read
input: .space 100			# save user input
start: .asciiz "\n\n----------- Let's start -----------"
request: .asciiz "\nInput: "
message1: .asciiz "\nThe longest length is: " 
message2: .asciiz "\nLongest words is: " 
newline: .asciiz "\n\t"
contPrompt: .asciiz "\nPress ENTER to continue..."

.text
	li  	$v0, 4      		# print_string 
    	la  	$a0, start		# start message
    	syscall

init:	li  	$v0, 4     		# print_string call number
	la 	$a0, request
    	syscall

	li 	$v0, 8	
	la 	$a0, input 		# pointer to string in memory
	la 	$a1, 100 
	syscall
    	
	li  	$s0, 0      		# i = 0 run through all text
    	li	$s2, 0			# j = 0 is the index of tmp
    	li	$s4, 0			# current longest length of result
    	li	$s6, 0			# k = 0: index to clear tmp 
	la	$a2, tmp		# load tmp address
	
main: 	jal	checkNonAlpha		# loop through input string
	
	li  	$v0, 4      		# print_string 
    	la  	$a0, message1		# message to print longest length
    	syscall
    	
    	li  	$v0, 1      		# print_integer
    	add  	$a0, $s4, $zero		# longest length
    	syscall
    	
    	li  	$v0, 4      		# print_string 
    	la  	$a0, message2		# message to print longest words
    	syscall
    	
    	la 	$a1, input		# load input address into $a1
    	j	printWord		# print all words with max length

exit:	li	$v0, 10			# syscall to terminate
	syscall	
#################################################################################################
#	checkNonAlpha method: if current character is non-alphabet --> we got a word 		#
#################################################################################################
checkNonAlpha:
	add	$t4, $s0, $a0		# address of A[i] in $t4
	lb	$s1, 0($t4)		# load value of A[i]
	
	slti	$t1, $s1, 65		# if ascii code is less than 48
	bne	$t1, $zero, checkLength	# get a word
	
	slti	$t1, $s1, 91		# if ascii code is greater than 90
					# and
	slti	$t2, $s1, 97		# if ascii code is less than 97
	slt	$t3, $t1, $t2
	bne	$t3, $zero, checkLength	# get a word
	
	slti	$t1, $s1, 123		# if ascii character is greater than 122
	beq	$t1, $zero, checkLength	# get a word
	
	addi	$s0, $s0, 1		# i = i + 1
	addi	$s2, $s2, 1		# j = j + 1
	j	checkNonAlpha		# go to checkNonAlpha
#########################################################################################
#	checkLength method: if current word's length > max -> we have new max length	#
#########################################################################################
checkLength:
	slt 	$t3, $s2, $s4		# if length of current word is not longer than current max (j < Max)
	bnez 	$t3, next		# reset j and move to the next one
	add	$s4, $zero, $s2		# else, we have new longest length
next:	beq	$s1, 10, done		# if A[i] = '\n' -> done
	addi	$s0, $s0, 1		# i = i + 1
	li	$s2, 0			# j = 0
	j	checkNonAlpha		# proceed next character	
done:	li  	$s0, 0
	li	$s2, 0
	jr	$ra			# return to main	
#################################################################################################
#	checkNonAlpha method: if current character is non-alphabet --> we got a word 		#
#################################################################################################
printWord:
	add	$t4, $s0, $a1		# address of A[i] in $t4
	lb	$s1, 0($t4)		# load value of A[i]
	
	slti	$t1, $s1, 65		# if ascii code is less than 65
	bne	$t1, $zero, compare	# get a word
	
	slti	$t1, $s1, 91		# if ascii code is greater than 90
					# and
	slti	$t2, $s1, 97		# if ascii code is less than 97
	slt	$t3, $t1, $t2
	bne	$t3, $zero, compare	# get a word
	
	slti	$t1, $s1, 123		# if ascii character is greater than 122
	beq	$t1, $zero, compare	# get a word
	
	add	$t5, $s2, $a2		# address of tmp[i] in $t5 
	sb	$s1, 0($t5)		# store current character to tmp[i]
	addi	$s0, $s0, 1		# i = i + 1
	addi	$s2, $s2, 1		# j = j + 1
	j	printWord		# go to checkNonAlpha
#################################################################################
#	compare	method: if current word's length = max length -> print 		#
#################################################################################
compare:
	beq 	$s2, $s4, print		# if length of current word is equal to current max
	j	reset			# reset j and move to the next one
print:	
	li  	$v0, 4      		# print_word
    	la  	$a0, newline 		# line break and tab
    	syscall
	li  	$v0, 4      		# print_string
    	la  	$a0, tmp		# word with max length
    	syscall
reset:	
	addi	$s0, $s0, 1		# i = i + 1
	li	$s6, 0			# k = 0
clear_tmp:
	beq	$s6, $s2, return	# if k = j end
	add	$t4, $s6, $a2		# loop through tmp string
	sb	$0, 0($t4)		# turn tmp[k] into 0
	addi	$s6, $s6, 1		# k = k + 1
	j	clear_tmp		# continue to clear
return:	
	li	$s2, 0			# j = 0
	beq	$s1, 10, readEnter	# if A[i] = '\n' -> done. Press enter to continue
	j	printWord		# proceed next character	
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

    	j 	init 			# return to the calling subroutine
