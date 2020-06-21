# Final Project

.data
#-----------Pointer-----------
CharPtr: .word  0 	# Bien con tro, tro toi kieu asciiz
BytePtr: .word  0 	# Bien con tro, tro toi kieu Byte
WordPtr: .word  0 	# Bien con tro, tro toi mang kieu Word
CharPtr1: .word  0
CharPtr2: .word  0
ArrayPtr: .word  0 	# Bien con tro 2D array, tro toi mang kieu Word
#-----------Menu String-----------
option_menu: .asciiz "1. Cap phat bo nho\n2. Lay gia tri word/byte cua bien con tro\n3. Lay dia chi bien con tro\n4. Copy 2 xau con tro ki tu\n5. Tinh toan luong bo nho da cap phat co cac bien dong\n6. Ham malloc2 cap phat mang 2 chieu\n7. GetArray[i][j] và SetArray[i][j]\n\nELSE: Exit"
malloc_menu: .asciiz "1. CharPtr\n2. BytePtr\n3. WordPtr\n4. Return main menu\n\nELSE: Exit"
getset_menu: .asciiz "1. GetArray[i][j]\n2. SetArray[i][j]\n3. Return main menu\n\nELSE: Exit"
#-----------Dump Messages-----------
malloc_success: .asciiz "\nMalloc succesfully. "
charPtr_Add: .asciiz "\nCharPtr address: "
bytePtr_Add: .asciiz "\nBytePtr address: "
wordPtr_Add: .asciiz "\nWordPtr address: "
arrayPtr_Add: .asciiz "\nArrayPtr address: "
charPtr_Val: .asciiz "\nCharPtr value: "
bytePtr_Val: .asciiz "\nBytePtr value: "
wordPtr_Val: .asciiz "\nWordPtr value: "
arrow: .asciiz " --> "
tab: .asciiz "\t"
new_line: .asciiz "\n"
dash_line: .asciiz "\n---------------------------------------\n"
amount:	.asciiz "\nNhap so phan tu can cap phat: "
CharPtr1_Val: .asciiz "\nCharPtr1: "
oldCharPtr2_Val: .asciiz "CharPtr2 (before): "
newCharPtr2_Val: .asciiz "\nCharPtr2 (after): "
input_message: .asciiz "Nhap 1 string bat ky de thuc hien copy: "
used_total: .asciiz "\nTong luong bo nho da su dung (tinh ca lam tron de sua loi): "
allocated_total: .asciiz "\nTong luong bo nho da cap phat: "
byte: .asciiz " byte(s)"
unallocated: .asciiz "\nMang 2 chieu chua duoc cap phat!!!"
input_row: .asciiz "\nNhap so hang: "
input_col: .asciiz "\nNhap so cot: "
input_i: .asciiz "\nNhap vi tri hang: "
input_j: .asciiz "\nNhap vi tri cot: "
assign_val: .asciiz "\nNhap gia tri can gan: "
out_of_bound: .asciiz "\nIndex out of bound."
string_copy: .space  100

.kdata
# Bien chua dia chi dau tien cua vung nho con trong
Sys_TheTopOfFree: .word  1 
# Vung khong gian tu do, dung de	 cap bo nho cho cac bien con tro
Sys_MyFreeSpace: 

.text
	jal   	SysInitMem		# Khoi tao vung nho cap phat dong
	
	#---------->[ Cac thanh ghi luu tru bien toan cuc (global variable) ]<-----------
	
	li	$s2, 0			# Tong so byte(s) da cap phat
	li	$s3, 0			# So hang cua array (nrows) 
	li	$s4, 0			# So cot cua array (ncols) 
	
menu:	la	$a0, dash_line		# start new action
	li	$v0, 4
	syscall
	la 	$a0, option_menu	# In Menu String 
	li 	$v0, 51 
 	syscall 
  	move 	$s0, $a0      		# Cac option tuong ung voi 7 yeu cau trong de bai
  	beq 	$s0, 1, extra_menu1 
  	beq 	$s0, 2, case2 
  	beq 	$s0, 3, case3 
  	beq 	$s0, 4, case4 
  	beq 	$s0, 5, case5
  	beq 	$s0, 6, case6 
  	beq 	$s0, 7, extra_menu7
	j	end

extra_menu1:
	la 	$a0, malloc_menu	# 3 lua chon tuong ung voi yeu cau 1
	li 	$v0, 51 
 	syscall 
  	move 	$s0, $a0      		# switch case 
  	beq 	$s0, 1, case1.1 	# Malloc CharPtr
  	beq 	$s0, 2, case1.2 	# Malloc BytePtr
  	beq 	$s0, 3, case1.3 	# Malloc WordPtr
  	beq 	$s0, 4, menu 		# return menu
	j	end

extra_menu7:
	la 	$a0, getset_menu	# 2 lua chon get/set tuong ung yeu cau 7 
	li 	$v0, 51 
 	syscall 
  	move 	$s0, $a0      		# switch case 
  	beq 	$s0, 1, case7.1 	# getArray[i][j]
  	beq 	$s0, 2, case7.2 	# setArray[i][j]
  	beq 	$s0, 4, menu 		# return menu
	j	end
			
end:	li 	$v0, 10
	syscall

#-----------------------
#  Cap phat cho bien con tro CharPtr, gom 3 phan tu, moi phan tu 1 byte
#-----------------------
case1.1:
	la	$a0, amount		# In ra thong bao "Nhap so phan tu can cap phat: "
	li	$v0, 51
	syscall
	move	$a1, $a0
	la   	$a0, CharPtr
	la	$a3, charPtr_Add
	addi 	$a2, $zero, 1     
	jal 	malloc
	j 	menu
#-----------------------
#  Cap phat cho bien con tro BytePtr, gom 6 phan tu, moi phan tu 1 byte
#-----------------------
case1.2:
	la	$a0, amount		# In ra thong bao "Nhap so phan tu can cap phat: "
	li	$v0, 51
	syscall
	move	$a1, $a0
	la   	$a0, BytePtr
	la	$a3, bytePtr_Add
	addi 	$a2, $zero, 1
	jal  	malloc 
	j	menu
#-----------------------
#  Cap phat cho bien con tro WordPtr, gom 5 phan tu, moi phan tu 4 byte
#-----------------------
case1.3:
	la	$a0, amount		# In ra thong bao "Nhap so phan tu can cap phat: "
	li	$v0, 51
	syscall
	move	$a1, $a0
	la   	$a0, WordPtr
	la	$a3, wordPtr_Add
	addi 	$a2, $zero, 4
	jal  	malloc 
	j 	menu 
#------------------------------------------
#  In ra gia tri cac bien con tro
#------------------------------------------
case2:
	#----------->[ charPtr ]<-----------
	la	$a0, charPtr_Val
  	li	$v0, 4
  	syscall
	la   	$a0, CharPtr
	jal	ptr_val
	#----------->[ bytePtr ]<-----------
	la	$a0, bytePtr_Val
  	li	$v0, 4
  	syscall
	la   	$a0, BytePtr
	jal	ptr_val
	#----------->[ wordPtr ]<-----------
	la	$a0, wordPtr_Val
  	li	$v0, 4
  	syscall
	la   	$a0, WordPtr
	jal	ptr_val
	j	menu
#------------------------------------------
#  In ra dia chi cac bien con tro
#------------------------------------------
case3:
	#----------->[ charPtr ]<-----------
	la	$a0, charPtr_Add
  	li	$v0, 4
  	syscall
  	la   	$a0, CharPtr
	jal	ptr_add
	#----------->[ bytePtr ]<-----------
	la	$a0, bytePtr_Add
  	li	$v0, 4
  	syscall
  	la   	$a0, BytePtr
	jal	ptr_add
	#----------->[ wordPtr ]<-----------
	la	$a0, wordPtr_Add
  	li	$v0, 4
  	syscall
  	la   	$a0, WordPtr
	jal	ptr_add
	j	menu
#------------------------------------------
#  Ham thuc hien copy 2 xau ki tu
#------------------------------------------
case4:	
	# ----------------->[ Cac lenh syscall de in ra man hinh ]<-----------------
	li  	$v0, 54       		# System call for InputDialogString
  	la   	$a0, input_message     	# In ra thong bao "Input a string: "
  	la   	$a1, string_copy        # Dia chi luu string dung de copy
  	li	$a2, 100		# So ki tu toi da co the doc duoc = 100
  	syscall
  	la   	$a1, string_copy        # Load lai 1 lan
  	la 	$s1, CharPtr1		# Load dia chi cua CharPtr1     
  	sw 	$a1, 0($s1) 		# Luu string vua nhap vao CharPtr1
  	la	$a0, CharPtr1_Val	# In ra thong bao "CharPtr1: "
  	li	$v0, 4
  	syscall
  	la	$a0, CharPtr1
  	lw 	$a0, 0($a0)		# Lay gia tri luu trong word nho CharPtr1
  	li 	$v0, 4			# In so integer ra man hinh duoi dang hexa
  	syscall
  	la	$a0, oldCharPtr2_Val	# In ra thong bao "CharPtr2 (before): "
  	li	$v0, 4
  	syscall
  	la	$a0, CharPtr2
  	lw 	$a0, 0($a0)		# Lay gia tri luu trong word nho CharPtr2
  	li 	$v0, 34			# In so integer ra man hinh duoi dang hexa
  	syscall
  	la	$a0, newCharPtr2_Val	# In ra thong bao "CharPtr2 (after): "
  	li	$v0, 4
  	syscall
	
	# ----------------->[ Khoi tao gia tri de thuc hien copy ]<-----------------
	la	$a0, CharPtr2		# Load dia chi cua CharPtr2
	la   	$t9, Sys_TheTopOfFree   #
	lw   	$t8, 0($t9) 		# Lay dia chi dau tien con trong
	sw   	$t8, 0($a0)    		# Cat dia chi do vao bien con tro
	lw 	$t4, 0($t9)            	# Dem so luong ki tu trong string
	lw	$t1, 0($s1)		# Load gia tri con tro CharPtr1
  	lw 	$t2, 0($a0)	   	# Load gia tri con tro CharPtr2
copy_loop: 
  	lb 	$t3, 0($t1)             # Load 1 ki tu (tren cung) cua $t1 vao $t3
  	sb 	$t3, 0($t2)             # Luu 1 ki tu cua $t3 vao $t2 
  	addi 	$t4, $t4, 1           	# so luong ki tu trong string += 1
  	addi 	$t1, $t1, 1            	# Chuyen sang dia chi ki tu tiep theo cua CharPtr1
  	addi 	$t2, $t2, 1            	# Chuyen sang dia chi ki tu tiep theo cua CharPtr2
  	beq 	$t3, '\0', end_copy    	# Check null = end string
  	j 	copy_loop 
end_copy: 
  	sw 	$t4, 0($t9)             # Kich thuoc cap phat = do dai string
  	lw	$a0, 0($a0)		# Lay noi dung con tro CharPtr2
  	li 	$v0, 4                  # In ra gia tri vung nho CharPtr2 tro den		
  	syscall 
  	j 	menu 

#---------------------------------------------------------
#  Tinh toan bo luong bo nho da cap phat cho cac bien dong
#---------------------------------------------------------
case5:
	la	$a0, used_total		# In ra thong bao "Tong luong bo nho da su dung (tinh ca lam tron de sua loi): "
	li	$v0, 4
	syscall
	la   	$t9, Sys_TheTopOfFree
	lw	$t9, 0($t9)		# Load dia chi luu o Sys_TheTopOfFree
	la   	$t8, Sys_MyFreeSpace
	sub	$a0, $t9, $t8		# Sys_TheTopOfFree - Sys_MyFreeSpace
	li	$v0, 1
	syscall
	la	$a0, byte		# In ra don vi " byte(s)"
	li	$v0, 4
	syscall
	
	la	$a0, allocated_total	# In ra thong bao "Tong luong bo nho da cap phat: "
	li	$v0, 4
	syscall
	move	$a0, $s2
	li	$v0, 1
	syscall
	la	$a0, byte		# In ra don vi " byte(s)"
	li	$v0, 4
	syscall
	
	j	menu
	
#---------------------------------------------------------
#  Tao ham Malloc2 cap phat mang 2 chieu kieu .word
#---------------------------------------------------------
case6:
	la 	$a0, input_row		# In thong bao "Nhap so cot: " 
	li 	$v0, 51 		# Syscall to input dialog
 	syscall 
 	addi	$s3, $a0, 0		# Luu so hang (row) thanh bien toan cuc
 	la 	$a0, input_col		# In thong bao "Nhap so cot: " 
	li 	$v0, 51 		# Syscall to input dialog
 	syscall 
 	addi	$s4, $a0, 0		# Luu so cot (cot) thanh bien toan cuc
 	
 	addi	$a1, $s3, 0		# Luu so hang (row) vao $a1 de thuc hien malloc
 	addi	$a2, $s4, 0		# Luu so cot (col) vao $a2 de thuc hien malloc
 	la   	$a0, ArrayPtr		# Dia chi con tro cua array
	jal	malloc2
	j	menu
#---------------------------------------------------------
#  Tao ham get/set cho mang 2 chieu
#---------------------------------------------------------
case7.1:				# GetArray[i][j]
	la 	$a0, ArrayPtr 
  	lw 	$s1, 0($a0) 
  	beqz 	$s1, null      		# Neu gia tri cua con tro ArrayPtr = 0 tuc la mang chua cap phat
  	la	$a0, input_i		# In thong bao "Nhap vi tri hang: "
  	li 	$v0, 51 		# Syscall to input dialog
  	syscall
  	bge 	$a0, $s3, invalid_idx  	# Neu so hang > nrows -> error 
  	move	$t1, $a0		# Luu lai vi tri hang
  	la	$a0, input_j		# In thong bao "Nhap vi tri cot: "
  	li 	$v0, 51 		# Syscall to input dialog
  	syscall
  	bge 	$a2, $s4, invalid_idx  	# Neu so cot > ncols -> error
  	move	$a1, $t1		# Luu vi tri hang vao $a1 de thuc hien get
  	move	$a2, $a0		# Luu vi tri cot vao $a2 de thuc hien get
  	la 	$a0, ArrayPtr 		# Load dia chi ArrayPtr de thuc hien get
  	jal	get
  	move	$a0, $v0		# Luu gia tri vua get duoc vao $a0 de thuc hien syscall 1
  	li	$v0, 34			# Syscall to print integer
  	syscall
  	j	menu

case7.2:				# SetArray[i][j]
	la 	$a0, ArrayPtr 
  	lw 	$s1, 0($a0) 
  	beqz 	$s1, null      		# Neu gia tri cua con tro ArrayPtr = 0 tuc la mang chua cap phat
  	la	$a0, input_i		# In thong bao "Nhap vi tri hang: "
  	li 	$v0, 51 		# Syscall to input dialog
  	syscall
  	move	$t1, $a0		# Luu lai vi tri hang
  	la	$a0, input_j		# In thong bao "Nhap vi tri cot: "
  	li 	$v0, 51 		# Syscall to input dialog
  	syscall 
  	move	$a2, $a0		# Luu vi tri cot vao $a2 de thuc hien get
  	la	$a0, assign_val		# In thong bao "Nhap gia tri can gan: "
  	li 	$v0, 51 		# Syscall to input dialog
  	syscall 
  	move	$a3, $a0
  	move	$a1, $t1		# Luu vi tri hang vao $a1 de thuc hien get
  	la 	$a0, ArrayPtr 		# Load dia chi ArrayPtr de thuc hien get
  	jal	set
print_array:	
	li	$t1, 0			# row index
	li	$t2, 0			# col index	
	j	loop_j
loop_i:	
	addi	$t1, $t1, 1		# row index
	beq	$t1, $s3, end_print	# For i = 0 -> nrows
	la	$a0, new_line		# new line
	li	$v0, 4
	syscall
	li	$t2, 0			# reset col index
loop_j:
	beq	$t2, $s4, loop_i	# For j = 0 -> ncols
	la 	$a0, ArrayPtr
	addi	$a1, $t1, 0
	addi	$a2, $t2, 0
	jal	get
	move	$a0, $v0		# Luu gia tri vua get duoc vao $a0 de thuc hien syscall 1
  	li	$v0, 1			# Syscall to print integer
  	syscall
  	la	$a0, tab		# space between integer
	li	$v0, 4
	syscall
	addi	$t2, $t2, 1		# col index
	j	loop_j
end_print:	
	j	menu

null:	la	$a0, unallocated
	li	$v0, 4
	syscall
	j	extra_menu7
invalid_idx:
	la	$a0, out_of_bound
	li	$v0, 4
	syscall
	j	extra_menu7
#------------------------------------------
#  Ham khoi tao cho viec cap phat dong
#  @param    khong co
#  @detail   Danh dau vi tri bat dau cua vung nho co the cap phat duoc
#------------------------------------------
SysInitMem:  	
	la   	$t9, Sys_TheTopOfFree  	# Lay con tro chua  dau tien con trong, khoi tao
	la   	$t7, Sys_MyFreeSpace 	# Lay dia chi dau tien con trong, khoi tao
	sw   	$t7, 0($t9) 		# Luu lai
	jr	$ra
#------------------------------------------
#  Ham cap phat bo nho dong cho cac bien con tro
#  @param  [in/out]   $a0   Chua dia chi cua bien con tro can cap phat
#                           Khi ham ket thuc, dia chi vung nho duoc cap phat se luu tru vao bien con tro
#  @param  [in]       $a1   So phan tu can cap phat
#  @param  [in]       $a2   Kich thuoc 1 phan tu, tinh theo byte
#  @return            $v0   Dia chi vung nho duoc cap phat
#------------------------------------------
malloc:	la   	$t9, Sys_TheTopOfFree   #
	lw   	$t8, 0($t9) 		# Lay dia chi dau tien con trong
	li	$t1, 4			# Do dai 1 word nho
	bne	$a2, $t1, valid		# Neu khong phai cap phat kieu WORD thi OK
	divu	$t8, $t1		# Kiem tra dia chi bat dau cap phat co chia het cho 4 khong
	mfhi	$t2			# Luu phan du (remainder) vao $t2
	beqz	$t2, valid		# Phan du = 0 -> Kich thuoc hop le
	sub	$t3, $t1, $t2		# Phan du != 0, can cap phat them (4-remainder) bits
	add	$t8, $t8, $t3		# Dia chi bat dau cap phat
valid:	sw   	$t8, 0($a0)    		# Cat dia chi do vao bien con tro
	addi 	$v0, $t8, 0   		# Dong thoi la ket qua tra ve cua ham 
	mul 	$t7, $a1, $a2   	# Tinh kich thuoc cua mang can cap phat
	add  	$t6, $t8, $t7  		# Tinh dia chi dau tien con trong 
	sw   	$t6, 0($t9)    		# Luu tro lai dia chi dau tien do vao bien Sys_TheTopOfFree
	add	$s2, $s2, $t7		# Cap nhap tong luong bo nho da cap phat
	
	#----------->[ Cap phat thanh cong. In ra man hinh ]<-----------
	la	$a0, malloc_success	# In ra thong bao malloc successfully
  	li	$v0, 4
  	syscall
  	move	$a0, $a3		# In ra kieu malloc
  	li	$v0, 4
  	syscall
  	addi	$a0, $t8, 0		# Malloc start address
	li 	$v0, 34			# In so integer ra man hinh duoi dang hexa
  	syscall
  	la	$a0, arrow		# In ra man hinh " --> "
  	li	$v0, 4
  	syscall
  	addi	$a0, $t6, 0		# Malloc end address
	li 	$v0, 34			# In so integer ra man hinh duoi dang hexa
  	syscall
	jr  	$ra
#------------------------------------------
#  Ham cap phat bo nho dong cho bien con tro mang 2 chieu
#  @param  [in/out]   $a0   Chua dia chi cua bien con tro can cap phat
#                           Khi ham ket thuc, dia chi vung nho duoc cap phat se luu tru vao bien con tro
#  @param  [in]       $a1   So hang cua array (Number of row)
#  @param  [in]       $a2   So cot cua array (Number of col)
#  @return            $v0   Dia chi vung nho duoc cap phat
#------------------------------------------
malloc2:
	addiu 	$sp, $sp, -4      	# them 1 phan tu vao stack
  	sw 	$ra, 4($sp)        	# push $ra
  	mul 	$a1, $a1, $a2       	# tra ve so phan tu cua Array
  	li 	$a2, 4 			# Mang kieu .word (4 bytes)
  	la	$a3, arrayPtr_Add
  	jal 	malloc 			# thuc hien cap phat cho mang voi so phan tu = row x col (4 bytes)
 	lw 	$ra, 4($sp) 		# pop $ra khoi stack de return
  	addiu 	$sp, $sp, 4       	# xoa bo nho stack da cap phat
 	jr 	$ra 
#------------------------------------------
#  Ham get/set gia tri cua 1 phan tu trong mang 2 chieu
#  @param  [in]       $a0   Chua dia chi cua mang 2 chieu
#  @param  [in]       $a1   Vi tri hang (ROW INDEX)
#  @param  [in]       $a2   Vi tri cot (COL INDEX)
#  @param  [in]       $a3   Gia tri can gan cho A[i][j]: input cua ham set
#  @param  [in]       $s4   So cot cua mang 2 chieu (NCOLS)
#  @return            $v0   Gia tri A[i][j]: ket qua tra ve cua ham get
#------------------------------------------
get: 	mul 	$t0, $s4, $a1 		# Cong thuc xac dinh vi tri cua A[i][j]:
  	addu 	$t0, $t0, $a2        	# Index = i * ncols + j
  	sll 	$t0, $t0, 2 		# Imm = index * 4 (bytes)
  	lw	$t3, 0($a0)		# Load dia chi ArrayPtr tro den
  	addu 	$t0, $t0, $t3        	# Dia chi A[i][j] = Dia chi co so Array + Imm
  	lw 	$v0, 0($t0) 
  	jr 	$ra 

set:	mul 	$t0, $s4, $a1 		# Cong thuc xac dinh vi tri cua A[i][j]:
  	addu 	$t0, $t0, $a2        	# index = i * ncols + j
  	sll 	$t0, $t0, 2 		# imm = index * 4 (bytes)
  	lw	$t3, 0($a0)		# Load dia chi ArrayPtr tro den
  	addu 	$t0, $t0, $t3        	# Dia chi A[i][j] = Dia chi co so Array + imm
  	sw 	$a3, 0($t0) 
  	jr 	$ra 
	
#------------------------------------------
#  2 ham in ra dia chi va gia tri cua pointer
#  @detail   	ptr_val: in gia tri
#		ptr_add: in dia chi
#------------------------------------------
ptr_val: 
  	lw 	$a0, 0($a0)		# Lay gia tri luu trong word nho
ptr_add:
  	li 	$v0, 34			# In so integer ra man hinh duoi dang hexa
  	syscall
  	jr 	$ra 
