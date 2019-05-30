.data
	
fin:   	.asciiz "input.txt"      # filename for output
buffer: .space 256
        
num_0:	.asciiz  "zero"	
num_1:	.asciiz  "one"
num_2:	.asciiz  "two"
num_3:	.asciiz  "three"
num_4:	.asciiz  "four"
num_5:	.asciiz  "five"
num_6:	.asciiz  "six"
num_7:	.asciiz  "seven"
num_8:	.asciiz  "eight"
num_9:	.asciiz  "nine"

num_big_0: .asciiz  "Zero"	
num_big_1: .asciiz  "One"
num_big_2: .asciiz  "Two"
num_big_3: .asciiz  "Three"
num_big_4: .asciiz  "Four"
num_big_5: .asciiz  "Five"
num_big_6: .asciiz  "Six"
num_big_7: .asciiz  "Seven"
num_big_8: .asciiz  "Eight"
num_big_9: .asciiz  "Nine"

			
.text
	j main

write_num_to_character:
	mul $t0, $a0, 12
	la $t0, num_row + 0($t0)	#kucuk harfle baslicaksa yazim sira numarasina gore alt satira inip yazar
	jr $t0
num_row:
	la $v0, num_0
	jr $ra
	la $v0, num_1
	jr $ra
	la $v0, num_2
	jr $ra
	la $v0, num_3
	jr $ra
	la $v0, num_4
	jr $ra
	la $v0, num_5
	jr $ra
	la $v0, num_6
	jr $ra
	la $v0, num_7
	jr $ra
	la $v0, num_8
	jr $ra
	la $v0, num_9
	jr $ra
	
write_num_to_big_character:	
	mul $t0, $a0, 12
	la $t0, num_big_row + 0($t0)	#buyuk harfle baslicaksa yazim sira numarasina gore alt satira inip yazar
	jr $t0
num_big_row:
	la $v0, num_big_0
	jr $ra
	la $v0, num_big_1
	jr $ra
	la $v0, num_big_2
	jr $ra
	la $v0, num_big_3
	jr $ra
	la $v0, num_big_4
	jr $ra
	la $v0, num_big_5
	jr $ra
	la $v0, num_big_6
	jr $ra
	la $v0, num_big_7
	jr $ra
	la $v0, num_big_8
	jr $ra
	la $v0, num_big_9
	jr $ra

main:
	li   $v0, 13       # system call for open file
	la   $a0, fin      # input file name
	li   $a1, 0        # Open for writing (flags are 0: read, 1: write)
	li   $a2, 0
	syscall
	move $s0, $v0
	
	li $v0, 14 		# system call for reading from file
	move $a0, $s0		# file descriptor
	la $a1, buffer 		# address of buffer from which to read
	li $a2, 256 		# hardcoded buffer length
	syscall 		# read from file
	move $t1, $a1	
	move $t4, $a1
		
control_num:
	lb $t3, ($t1)
	
	li $t2, '\0'			#null mi kontrolu
	beq $t3, $t2, control_num_end
		
	li $t2, '0'			#sifirdan kucuk mu kontrolu
	blt $t3, $t2, print_number
	
	li $t2, '9'			#dokuzdan buyuk mu kontrolu
	bgt $t3, $t2, print_number

	addi $t4, $t4, 1		
	lb $t5,($t4)		#bir sonrasindaki 0 dan buyuk mu kontrol
	bge $t5, '0', control_num_right 
	j check_point
	
control_num_right:				#sagdaki karakterin 9 dan kucuk olma kontrolu 
	ble $t5, '9',print_number

control_num_left:
	addi $t4, $t4,-2
	lb $t5,($t4)
	bge $t5, '0', control_num_left_to_9 #sagdaki karakterin 0 dan buyuk olma kontrolu 
	j print_num_to_character

control_num_left_to_9: #soldaki karakter kontrolu 
	ble $t5, '9',print_number
	
check_point:
	li $t2, '.'
	beq $t5, $t2, check_point_to_num	#nokta mi kontrolu
	j control_num_left

check_point_to_num:
	addi $t4, $t4,1
	lb $t5,($t4)		
	bge $t5, '0', check_big_0	#0 dan buyuk mu kontrolu
	j control_num_left	
										
check_big_0:
	ble $t5, '9', print_number	#9 dan kucuk kontrolu
	j control_num_left
			
check_point_before:
	addi $t4, $t4,-1
	lb $t5,($t4)			#noktadan onceki sifirdan buyuk ise 9 dan kucuk kontrolune yollanir
	bge $t5, '0', check_less_9	#degilse buyuk yzmaya yolla
	j print_big_character
	
check_less_9:
	ble $t5, '9', print_number	#noktadan once sayi varsa rakamla yazar
	j print_big_character				#yoksa buyukle yazar

print_num_to_character:	
	addi $t4, $t4,-1	
	lb $t5,($t4)
	beq $t5, '.',print_big_character	#2 oncesi nokta ise buyuk harfli sayi yazma
	j control_point			#degilse bir oncesi kontrole yollar

control_point:
	addi $t4, $t4,1		# bi oncesi nokta mi diyr kontrol
	lb $t5,($t4)
	beq $t5, '.',check_point_before
	j print_small_character
	
print_big_character:			#buyuk harfli sayi yazma
	move $a0, $t3
	sub $a0, $a0, '0'
	jal write_num_to_big_character
	move $a0, $v0
	li $v0, 4
	syscall
	j end_print_number
	
print_small_character:					#kucuk harfli sayi yazma										
	move $a0, $t3
	sub $a0, $a0, '0'
	jal write_num_to_character

	move $a0, $v0
	li $v0, 4
	syscall
			
	j end_print_number

print_number:
	move $a0, $t3		#sayilari rakamla yazma
	li $v0, 11
	syscall

end_print_number:	
	add $t1, $t1, 1
	move  $t4, $t1		#adres artirilir
	j control_num

control_num_end:

end_main:
	li $v0, 10
	syscall
