.data
array:.word	9, 8, 7, 6, 5, 4, 3, 2, 1, 0
size: .word	10

.text
lui $s0 0x1001
addi $t9 $0 1
addi $t0, $0, 0
addi $s2, $0, 1
lw $s5, 0x28($s0)
add $zero $zero $zero
add $zero $zero $zero
add $zero $zero $zero
sub $s4, $s5, $t9
add $zero $zero $zero
add $zero $zero $zero
add $zero $zero $zero
j cond0
add $zero $zero $zero

loop0:
addi $t1, $0, 0
sub $s3, $s4, $t0
add $zero $zero $zero
j cond1
add $zero $zero $zero

loop1:
add $zero $zero $zero
add $zero $zero $zero
add $zero $zero $zero
sll $t4, $t1, 2
add $zero $zero $zero
add $zero $zero $zero
add $zero $zero $zero
add $t4, $s0, $t4 
add $zero $zero $zero
add $zero $zero $zero
add $zero $zero $zero
addi $t5, $t4, 4

lw $t6, 0($t4)
add $zero $zero $zero
add $zero $zero $zero
lw $t7, 0($t5)

add $zero $zero $zero
add $zero $zero $zero
add $zero $zero $zero

slt $t8, $t7, $t6
add $zero $zero $zero
add $zero $zero $zero
add $zero $zero $zero
beq $t8, $s2, if
add $zero $zero $zero
j exit
add $zero $zero $zero
if:
sw $t7, 0($t4)
sw $t6, 0($t5)
exit:
addi $t1, $t1, 1
add $zero $zero $zero
add $zero $zero $zero
add $zero $zero $zero

cond1:
slt $t2, $t1, $s3
add $zero $zero $zero
add $zero $zero $zero
add $zero $zero $zero
beq $t2, $s2, loop1
add $zero $zero $zero

addi $t0, $t0, 1
add $zero $zero $zero
add $zero $zero $zero
add $zero $zero $zero

cond0:
slt $t3, $t0, $s4
add $zero $zero $zero
add $zero $zero $zero
add $zero $zero $zero
beq $t3, $s2, loop0
add $zero $zero $zero

halt
