main:
	addi $at $zero 0x0001
	addi $t1 $zero 0x0006
	add $t0 $zero $zero
	j test
	add $zero $zero $zero
loop:
	addi $t2 $t2 0x0010
	lui $t3 0x0010
	ori $t4 $t4 0x1010
	sub $t5 $t5 $at
	xori $t6 $t6 0x3333
	add $t2 $t2 $t3
	sub $t3 $t3 $t4
	xor $t4 $t4 $t5
	and $t5 $t5 $t6
test:
	beq $t1 $t0 exit
	add $zero $zero $zero
	sub $t1 $t1 $at
	addi $t0 $t0 0x0001
	j loop
	add $zero $zero $zero
exit:
	add $s0 $zero $t5
	halt
