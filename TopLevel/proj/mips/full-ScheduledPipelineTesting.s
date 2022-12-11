main:
	ori $s0, $zero 0x1234 
	lui $t2 0x1001
	add $s0 $s0,$s0
	sw $s0 4($t2)
	ori $s1 $zero 0x1234
Secont:
	lui $s2 0x1202
	beq $s0 $s1 skip2
	add $s1 $zero $s0
	j Secont
skip2:
	jal fun
	xori $s3 $zero 0x1234
	addi $s3 $s3 0x0032
	bne $s0 $zero Jay
	ori $s4 $zero 0x1234
	lui $t0 0x00f0
	addiu $t0 $ra 0x2255
	and $s4 $t0 $s3
	addu $t0 $t0 $s4
	andi $t1 $s3 0x1200
	sw $t4 0($t2)
	slt $s4 $t0 $s3
	sll $s4 $t0 5
	srl $s4 $t0 8
	sra $s4 $t0 9
	repl.qb $t1 0x12 
	sw $t1 8($t2)
	subu $s4 $t0 $s3
	j exit
Jay:
	movn $t1 $s0 $s0
	sub $s0 $s0 $t1
	slti $s4 $t4 0x256 
	or $s4 $s4 $t1
	xor $t1 $s4 $zero
	j skip2

fun:
	lw $t4 4($t2)
	ori $s2 $zero 0x1234
	sub $s3 $s1 $s3
	
	nor $s2 $s2 $s1

	jr $ra

exit:
	halt


