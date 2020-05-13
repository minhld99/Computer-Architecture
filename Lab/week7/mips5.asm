#Laboratory Exercise 7, Assignment 5
.data
comma: .asciiz ", "
newline: .asciiz "\n"
.text
main:		li	$s0,8		
		li	$s1,7
		li	$s2,6
		li	$s3,5
		li	$s4,4
		li	$s5,3
		li	$s6,2
		li	$s7,1
		li	$t4,0		#current index in stack
		li	$t7,7		#last index in list
init_max:	addi	$t0,$s0,0	#initiate max value = $s0
		li	$t1,0		#save max's position
init_min:	addi	$t2,$s0,0	#initiate min value = $s0
		li	$t3,0		#save min's position
push:		addi	$sp,$sp,-32	#adjust the stack pointer
		sw 	$s0,28($sp)	#push $s0 to stack
		sw	$s1,24($sp)	#push $s1 to stack
		sw 	$s2,20($sp)	#push $s2 to stack
		sw	$s3,16($sp)	#push $s3 to stack
		sw 	$s4,12($sp)	#push $s4 to stack
		sw	$s5,8($sp)	#push $s5 to stack
		sw 	$s6,4($sp)	#push $s6 to stack
		sw	$s7,0($sp)	#push $s7 to stack			
iter:		lw 	$t5,0($sp)	#pop the current top value of stack to $t5
		addi	$sp,$sp,4	#free the current address
		beq	$t4,8,print	#if index = 8 -> done
		beq	$t5,$t0,iter	#if current top value = max -> next iter
		beq	$t5,$t2,iter	#if current top value = min -> next iter
		slt	$t6,$t5,$t2	#if current top value < min
		bne	$t6,$zero,min	#then swap min
		sgt	$t6,$t5,$t0	#if current top value > max
		bne	$t6,$zero,max	#then swap max
max:		add 	$t0,$t5,$zero 	#set max = $t5
		sub	$t1,$t7,$t4	#set index of max = 8 - $t4
		addi 	$t4,$t4,1	#increase index
		j	iter
min:		add 	$t2,$t5,$zero 	#set Min = $t5
		add 	$t3,$t7,$t4 	#set index of Min = 7 - $t4
		addi 	$t4,$t4,1	#increase index
		j	iter	
print:		li	$v0,1
		move	$a0,$t0		#print max value
		syscall	
		li 	$v0, 4  	#print comma
    		la 	$a0, comma      #load address of comma
    		syscall
		li	$v0,1
		move	$a0,$t1		#print max's index
		syscall
		li 	$v0, 4  	#print newline
    		la 	$a0, newline    #load address of newline
    		syscall
		li	$v0,1
		move	$a0,$t2		#print min value
		syscall
		li 	$v0, 4  	#print comma
    		la 	$a0, comma      #load address of comma
    		syscall
		li	$v0,1
		move	$a0,$t3		#print min's index
		syscall
		li 	$v0, 4  	#print newline
    		la 	$a0, newline    #load address of newline
    		syscall
		li 	$v0,10		#terminate		
		syscall
endmain: