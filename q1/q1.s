.section .text
.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    mv s1, a0

    li a0, 24
    call malloc

    mv s0, a0

    sw s1, 0(s0)
    sd x0, 8(s0)
    sd x0, 16(s0)

    mv a0, s0

    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    addi sp, sp, 32
    ret

insert:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    mv s0, a0
    mv s1, a1

    bne s0, x0, insert_notnull
    mv a0, s1
    call make_node
    j insert_done

insert_notnull:
    lw t0, 0(s0)
    beq s1, t0, insert_return_root
    bge s1, t0, insert_right

insert_left:
    ld a0, 8(s0)
    mv a1, s1
    call insert
    sd a0, 8(s0)
    j insert_return_root

insert_right:
    ld a0, 16(s0)
    mv a1, s1
    call insert
    sd a0, 16(s0)

insert_return_root:
    mv a0, s0

insert_done:
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    addi sp, sp, 32
    ret

get:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    mv s0, a0
    mv s1, a1

    bne s0, x0, get_notnull
    li a0, 0
    j get_done

get_notnull:
    lw t0, 0(s0)
    bne s1, t0, get_notequal
    mv a0, s0
    j get_done

get_notequal:
    bge s1, t0, get_right

get_left:
    ld a0, 8(s0)
    mv a1, s1
    call get
    j get_done

get_right:
    ld a0, 16(s0)
    mv a1, s1
    call get

get_done:
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    addi sp, sp, 32
    ret

getAtMost:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    sd s2, 0(sp)

    mv s0, a0
    mv s1, a1

    bne s1, x0, getAtMost_notnull
    li a0, -1
    j getAtMost_done

getAtMost_notnull:
    lw t0, 0(s1)

    beq t0, s0, getAtMost_exact
    blt s0, t0, getAtMost_go_left

getAtMost_candidate:
    mv s2, t0

    mv a0, s0
    ld a1, 16(s1)
    call getAtMost

    li t0, -1
    bne a0, t0, getAtMost_done
    mv a0, s2
    j getAtMost_done

getAtMost_exact:
    mv a0, s0
    j getAtMost_done

getAtMost_go_left:
    mv a0, s0
    ld a1, 8(s1)
    call getAtMost

getAtMost_done:
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    ld s2, 0(sp)
    addi sp, sp, 32
    ret
    