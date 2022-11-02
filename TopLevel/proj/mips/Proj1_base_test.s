#
# First part of the Lab 3 test program
#

# data section
.data

# code/instruction section
.text
addi  $1,  $0,  1
addiu	$2, $0, 2
add	$3, $1, $2
addu	$4, $1, $3
and	$5, $3, $2
andi	$6, $5, 1235
lui	$7, 45
nor	$8, $3, $2
xor	$9, $3, $2
xori	$10, $3, 1023
or	$11, $3, $2
ori	$12, $3, 1023
slt	$13, $2, $3
slti	$14, $3, 1023
sll	$15, $3, 2
srl	$16, $15, 2
sra	$17, $15, 2
sub	$18, $3, $2
#repl.qb	$19, $3
movn	$20, $3, $2

halt
