# Test program for part 4
.data
_v0: .asciiz "$v0: "

.text
# Call insert
lw $a0, _record_to_insert
la $s0, _table
lw $s2, _table_size

move $a1, $s0  # table
move $a2, $s2  # table_size
jal insert

# Print v0
move $s1, $v0  # Save $v0 value
la $a0, _v0
li $v0, 4
syscall

move $a0, $s1
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

# Print the contents of the hash table
li $s1, 0  # Counter

_print_loop:
	beq $s1, $s2, _exit_print_loop
	lw $t0, 0($s0)

	beqz $t0, _print_null
	li $t1, -1
	beq $t0, $t1, _print_tombstone
	
	move $a0, $t0
	jal print_student
	j _increment
	
	_print_null:
	li $a0, 'X'
	li $v0, 11
	syscall
	j _increment

	_print_tombstone:
	li $a0, 'T'
	li $v0, 11
	syscall
	
	_increment:
	li $a0, '\n'
	li $v0, 11
	syscall
	
	addi $s0, $s0, 4
	addi $s1, $s1, 1
	j _print_loop

_exit_print_loop:

# Exit
li $v0, 10
syscall

.include "../hw5.asm"
