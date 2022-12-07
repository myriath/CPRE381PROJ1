main:
	ori $s0, $zero 0x1234
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	lui $t2 0x1001
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	add $s0 $s0,$s0
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	sw $s0 4($t2)
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	ori $s1 $zero 0x1234
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
Secont:
	lui $s2 0x1202
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	beq $s0 $s1 skip2
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	add $s1 $zero $s0
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	j Secont
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
skip2:
	jal fun
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	xori $s3 $zero 0x1234
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	addi $s3 $s3 0x0032
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	bne $s0 $zero Jay
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	ori $s4 $zero 0x1234
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	lui $t0 0x00f0
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	addiu $t0 $ra 0x2255
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	and $s4 $t0 $s3
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	addu $t0 $t0 $s4
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	andi $t1 $s3 0x1200
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	sw $t4 0($t2)
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	slt $s4 $t0 $s3
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	sll $s4 $t0 5
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	srl $s4 $t0 8
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	sra $s4 $t0 9
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	repl.qb $t1 0x12 
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	sw $t1 8($t2)
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	subu $s4 $t0 $s3
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	j exit
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
Jay:
	movn $t1 $s0 $s0
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	sub $s0 $s0 $t1
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	slti $s4 $t4 0x256 
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	or $s4 $s4 $t1
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	xor $t1 $s4 $zero
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	j skip2
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero

fun:
	lw $t4 4($t2)
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	ori $s2 $zero 0x1234
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	sub $s3 $s1 $s3
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	nor $s2 $s2 $s1
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	jr $ra
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	add $zero $zero $zero
	
exit:
	halt


