# Test program for part 3
.text
lw $a0, _num_students
la $a1, _id_list
la $a2, _credits_list
la $a3, _names

addi $sp, $sp, -4
la $s0, _records
sw $s0, 0($sp)

jal init_student_array
addi $sp, $sp, 4

li $s1, 0  # Loop counter
lw $s2, _num_students

_print_loop:
	beq $s1, $s2, _exit_print_loop
	move $a0, $s0  # $s0 stores pointer to next student record
	jal print_student
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	addi $s0, $s0, 8  # Go to next student record
	addi $s1, $s1, 1
	j _print_loop

_exit_print_loop:

# Exit
li $v0, 10
syscall

.include "../hw5.asm"
