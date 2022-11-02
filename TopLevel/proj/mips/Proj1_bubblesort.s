.data
array:.word	9, 8, 7, 6, 5, 4, 3, 2, 1, 0
size: .word	10

.text
la $s0, array
lw $s5, size
sub $s4, $s5, 1
addi $s2, $0, 1

addi $t0, $0, 0
j cond0

loop0:
addi $t1, $0, 0
sub $s3, $s4, $t0
j cond1

loop1:
sll $t4, $t1, 2
add $t4, $s0, $t4 
addi $t5, $t4, 4

lw $t6, 0($t4)
lw $t7, 0($t5)

slt $t8, $t7, $t6
beq $t8, $s2, if
j exit
if:
sw $t7, 0($t4)
sw $t6, 0($t5)
exit:
addi $t1, $t1, 1
cond1:
slt $t2, $t1, $s3
beq $t2, $s2, loop1

addi $t0, $t0, 1
cond0:
slt $t3, $t0, $s4
beq $t3, $s2, loop0
