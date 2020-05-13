# Laboratory Exercise 7 Assignment 1
.text 
main: 	li 	$a1,-50         	#load input parameter
	jal 	abs			#jump and link to abs procedure
	nop
	add 	$s0, $zero, $v0 
	li 	$v0,10			#terminate		
	syscall
endmain: 
#-------------------------------------------------------------------- 
# function abs
# param[in] 	$a1 	the interger need to be gained the absolute value
# return 	$v0 	absolute value 
#-------------------------------------------------------------------- 
abs:
	sub 	$v0,$zero,$a1		#put -(a1) in v0; in case (a1)<0
	
	bltz 	$a1,done		#if (a1)<0 then done
	nop
	add 	$v0,$a1,$zero		#else put (a1) in v0
done:
	jr 	$ra
	

