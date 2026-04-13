.section .rodata
fmt_d:
	.string "%ld"
space:
	.string " "
newline:
	.string "\n"

.section .text
.globl main

main:
	addi sp, sp, -80
	sd ra, 72(sp)
    sd s0, 64(sp)
	sd s1, 56(sp)
	sd s2, 48(sp)
	sd s3, 40(sp)
	sd s4, 32(sp)
	sd s5, 24(sp)
	sd s6, 16(sp)
	sd s7, 8(sp)

	mv s0, sp
	addi s1, a0, -1
	mv s5, a1

	beq	s1, x0, done

	slli t0, s1, 3
	slli t1, s1, 4
	add t2, t0, t1
	sub sp, sp, t2
	andi sp, sp, -16

	mv s2, sp
	slli t0, s1, 3
	add s3, s2, t0
	add	s4, s3, t0

	li s6, 0

loop0:
	bge	s6, s1, done0
	slli t0, s6, 3
	addi t0, t0, 8
	add t1, s5, t0
	ld a0, 0(t1)
	call atoi
	slli t0, s6, 3
	add t1, s2, t0
	sd a0, 0(t1)
	addi s6, s6, 1
	j loop0

done0:
	li s6, 0

loop1:
	bge	s6, s1, done1
	slli t0, s6, 3
	add	t1, s4, t0
	li t2, -1
	sd t2, 0(t1)
	addi s6, s6, 1
	j loop1

done1:
	li s6, -1
	addi s7, s1, -1

loop2:
	bltz s7, done2
	slli t0, s7, 3
	add	t1, s2, t0
	ld t3, 0(t1)

loop3:
	bltz s6, done3
	slli t0, s6, 3
	add	t1, s3, t0
	ld t4, 0(t1)
	slli t0, t4, 3
	add	t1, s2, t0
	ld t5, 0(t1)
	bgt	t5, t3, done3
	addi s6, s6, -1
	j loop3
done3:

	bltz s6, push
	slli t0, s6, 3
	add	t1, s3, t0
	ld t4, 0(t1)
	slli t0, s7, 3
	add	t1, s4, t0
	sd t4, 0(t1)

push:
	addi s6, s6, 1
	slli t0, s6, 3
	add	t1, s3, t0
	sd s7, 0(t1)
	addi s7, s7, -1
	j loop2

done2:
	li s6, 0

print_loop:
	bge	s6, s1, print_done
	beq	s6, x0, skip
	la a0, space
	call printf

skip:
	slli t0, s6, 3
	add	t1, s4, t0
	ld a1, 0(t1)
	la a0, fmt_d
	call printf

	addi s6, s6, 1
	j print_loop

print_done:
	la a0, newline
	call printf

done:
	mv sp, s0
	ld ra, 72(sp)
	ld s1, 56(sp)
	ld s2, 48(sp)
	ld s3, 40(sp)
	ld s4, 32(sp)
	ld s5, 24(sp)
	ld s6, 16(sp)
	ld s7, 8(sp)
	ld s0, 64(sp)
	addi sp, sp, 80
	li a0, 0
	ret
    