.section .rodata
filename:
    .string "input.txt"
read_mode:
	.string "r"
str_yes:
	.string "Yes\n"
str_no:
	.string "No\n"

.section .text
.globl main

main:
	addi sp, sp, -48
	sd ra, 40(sp)
	sd s1, 32(sp)
	sd s2, 24(sp)
	sd s3, 16(sp)
	sd s4, 8(sp)
	sd s5, 0(sp)

	la a0, filename
	la a1, read_mode
	call fopen
	mv s1, a0

	mv a0, s1
	li a1, 0
	li a2, 2
	call fseek

	mv a0, s1
	call ftell
	addi s3, a0, -1

	mv a0, s1
	li a1, 0
	li a2, 0
	call fseek

	li s2, 0

loop:
	bge s2, s3, is_palindrome

	mv a0, s1
	mv a1, s2
	li a2, 0
	call fseek
	mv a0, s1
	call fgetc
	mv s4, a0
    
	mv a0, s1
	mv a1, s3
	li a2, 0
	call fseek
	mv a0, s1
	call fgetc
	mv s5, a0

	bne s4, s5, not_palindrome

	addi s2, s2, 1
	addi s3, s3, -1
	j loop

is_palindrome:
	mv a0, s1
	call fclose
	la a0, str_yes
	call printf
	j done

not_palindrome:
	mv a0, s1
	call fclose
	la a0, str_no
	call printf

done:
	ld ra, 40(sp)
	ld s1, 32(sp)
	ld s2, 24(sp)
	ld s3, 16(sp)
	ld s4, 8(sp)
	ld s5, 0(sp)
	addi sp, sp, 48
	li a0, 0
	ret
