# Laboratory Exercise 4, Assignment 4
.text
	#abs $s0,$s1
	
	#ori $s0, $zero, $s1     # copy $s1 vào $s0
        #slt $s3, $s1, $zero     # kiểm tra $s1 < 0?
        #beq $s3, $zero, skip   	# if $s1 là số dương, đi đến branch skip
        #sub $s0, $zero, $s1     # else: $s0 = 0 - $s1
#skip:

	#move $s0,$s1
	
	#addi $s0, $zero, 1
	#addi $s1, $zero, 2
	#add  $s0, $s0, $s1 
	
	#nor $s0, $s1, $zero
	
	ble $s1, $s2, label # if s1 <= s2 move
label:
	#slt $t1, $s2, $s1 # if $s2 < $s1: $t1 = 1 else $t1 = 0
	#beq $t1, 0, label
	
	