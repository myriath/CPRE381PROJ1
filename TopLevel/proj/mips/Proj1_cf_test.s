.text
# Sets the stack pointer
addi $sp, $0, 0
lui $sp, 0x7FFF
addi $sp, $sp, 0xEFFC

addi $a0, $0, 10
jal fibr

halt

# Recursive fib function
fibr:
ble $a0, 2, fibr_else # if (a0 > 2) {
sub $a0, $a0, 1 #   a0--;
subi $sp, $sp, 8 #   // move stack pointer
sw $a0, 4($sp) #   // put a0 onto the stack
sw $ra, 8($sp) #   // put ra onto the stack
jal fibr #   f(a0);
lw $a0, 4($sp) #   // get a0 from stack
lw $ra, 8($sp) #   // get ra from stack
add $s1, $zero, $v0 #   s1 = f(n - 1);
sub $a0, $a0, 1 #   a0--;
sw $s1, 4($sp) #   // put s1 onto stack
sw $ra, 8($sp) #   // put ra onto the stack
jal fibr #   f(a0);
lw $s1, 4($sp) #   // get s1 from stack
lw $ra, 8($sp) #   // get ra from stack
addi $sp, $sp, 8 #   // move stack pointer
add $v0, $s1, $v0 #   return f(n - 1) + f(n - 2);
jr $ra # }
fibr_else: # else {
addi $v0, $zero, 1 #   return 1;
jr $ra # }
##### END FIBR #####
