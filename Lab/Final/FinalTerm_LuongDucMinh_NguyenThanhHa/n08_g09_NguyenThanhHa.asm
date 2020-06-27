.data
	start:  .asciiz "     Disk1              Disk2              Disk3      \n "
	string: .asciiz " --------------     --------------     -------------- \n"
	a1:  .asciiz "|     "
	a2: .asciiz "     |   "
	b1: .asciiz "[[ "
	b2: .asciiz "]]   "
	prompt: .asciiz "Nhap chuoi ki tu : "
	contPrompt: .asciiz "\nAn ENTER de thuc hien lai..."
	message1: .asciiz "\n\n----------- Let's start -----------\n"
	error: .asciiz "\ndo dai xau phai la boi cua 8\n"
	error2:.asciiz "\nXau khong duoc rong\n"
	hex:	.byte	'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
	.align 2							# luu digit_to_hex duoi dang ma HEX, ko co se tro thanh ma ascii
	buffer: .space  4000
	buff: .word 0
.text
	li  	$v0, 4      		# in thong diep start
    	la  	$a0, message1		# pointer to start message in memory4
    	syscall
begin:
	la $a0, prompt
	li $v0,4
	syscall  			#v0,4 la in string.
	la $a0, buffer
	li $a1, 4000
	li $v0 ,8 			#nhap vao xau co do dai 4000
	syscall
	la $s0, buffer			#$s0: luu tru dia chi dau tien cua buffer
#----------------kiem tra do dai cua chuoi-----------------------
#---------------dem tung ki tu trong buffer-------------
count:
	lb $t0, 0($s0)  		#load gia tri cua byte dau tien = t0 
					#load tung byte 1
	beq $t0, '\n', check	 	# neu t0=kí tu xuong dong, ket thuc chuoi
	addi $s0,$s0,1 			#tang s0++ , tang den phan tu tiep theo
	j count
check:
	sub $s0, $s0, $a0 		#s0 :do dai cua xau nhap vao
	srl $t0, $s0, 3 		#dich phai 3 bit, chia cho 2^3, xet truong hop xau rong
					#VD 0000
	andi $s0, $s0, 7		#kiem tra so co chia het cho 8 khong
	bne $s0, $zero, printerror 	# neu khong thi bao loi
	beq $t0, $zero, printerror2 	# ktra xem nhap vao xau hay chua
	la $a0, start
	li $v0,4
	syscall 			#in string ben tren
	jal print			# goi den print
	move $a0,$0		 	#gan a0 = zero
#----------------------in cac block ra man hinh-------------------------
loop:
	jal printline 			#goi ham print_line voi tham so a0(=0), a0 la khoi hien tai 1 khoi gom 2 block con
	addi $a0,$a0,1
	bne $a0,$t0,loop		#t0 la luong cac khoi 2 block
	jal print
	j readEnter

#bieu dien 1 hang(tach chuoi)
#load 8 byte: lay vi tri hang* 8 + vi tri cõ so
printline: 				#a0 = 0
	addiu $sp,$sp,-8 		#stack pointer, nhuong ra 2 o de ghi dia chi cua $ra cu
	sw $ra, 4($sp)
	sw $a0, 8($sp) 			# luu gia tri a0 vao stack
	rem $t6,$a0,3 			#chia 3 lay du
	sll $t1, $a0,3			#dich phai 3 bit,
	la $t2,buffer 			#load dia chi cua buffer vao t2
	add $t2,$t2,$t1 		#t2 
	lw $t3, 0($t2) 			#load 4 byte dau t2 luu t3
	lw $t4, 4($t2)			#load 4 byte tiep theo cua t2 luu t4
	xor $t5,$t3,$t4 		#luu KQ phep xor vao t5
	beqz $t6,row0
	beq $t6, 1, row1
	j row2

#------------------in cac block ra man hinh--------------------
row0:
	move $a1,$t3
	jal printblock  		#goi ham print_block voi tham so a1
	move $a1,$t4 			# truyen t4 vao a1
	jal printblock
	jal printxor
	j endswitch
row1:
	move $a1,$t3
	jal printblock
	jal printxor
	move $a1,$t4
	jal printblock
	j endswitch
row2:
	jal printxor
	move $a1,$t3
	jal printblock
	move $a1,$t4
	jal printblock
#-------------xuong dong-------------------
endswitch:
	li $a0,'\n'
	li $v0,11
	syscall 			# in ra ky tu '\n'
	lw $a0, 8($sp)
	lw $ra, 4($sp)
	addiu $sp,$sp,8
	jr $ra
#---------------in tung block--------------------------
printblock:				# nhan gia tri $a1 dau vao
	la $a0, a1 			#string a1 la dau | vao dong dau cach
	li $v0,4
	syscall 			#in string
	la $a0, buff
	sw $a1, 0($a0)
	li $v0,4
	syscall
	la $a0, a2			#string a2 la in ra dau cach roi den dau |
	li $v0,4
	syscall
	jr $ra 				# nhay den gia tri thanh ghi $ra
#-------------in ra ket qua cua phep xor-----------------
#t5 = t3 xor t4
printxor:
	la $a0, b1
	li $v0,4
	syscall				#in ra [[    .
	la $s1,hex

	srl $s0, $t5, 4 		# dich phai 4 bit
	and $s0,$s0,0xf  		# s0=7; giu lai gia tri cuoi cua s0;
	add $s2,$s1,$s0
	lb $a0,0($s2) 			# load byte s2 vao a0
	li $v0,11
	syscall 			#in ra ky tu thu nhat

	and $s0,$t5,0xf
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall	

	li $a0,','
	li $v0,11
	syscall

	srl $s0, $t5, 12
	and $s0,$s0,0xf
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	srl $s0, $t5, 8
	and $s0,$s0,0xf
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	li $a0,','
	li $v0,11
	syscall

	srl $s0, $t5, 20
	and $s0,$s0,0xf
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	srl $s0, $t5, 16
	and $s0,$s0,0xf
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	li $a0,','
	li $v0,11
	syscall

	srl $s0, $t5, 28
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	srl $s0, $t5, 24
	and $s0,$s0,0xf
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	la $a0, b2
	li $v0,4
	syscall
	jr $ra

print:
	la $a0, string			#print dau ngan cach ------
	li $v0,4
	syscall
	jr $ra 				# quay lai neu phia tren co lenh jal

printerror:
	la $a0,error
	li $v0,4
	syscall 			#in loi chuoi khong phai boi cua 8
	j readEnter
printerror2:
	la $a0,error2
	li $v0,4
	syscall 
	j readEnter			#in bao loi xau rong
#---------------------ket thuc ctrinh ------------------------ 
end:
	li $v0,10
	syscall 			#exit
readEnter: 				#yeu cau nguoi dung an enter de tiep tuc
    	li 	$v0, 4
    	la 	$a0, contPrompt
    	syscall
    	li 	$v0, 12
    	syscall
    	move 	$t0, $v0
    	bne 	$t0, 10, end 		#thoat khoi ctr neu khong an enter
    	j 	begin 			#quay lai begin

