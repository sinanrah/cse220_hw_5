# Test program for part 6
.data
_null: .asciiz "NULL"
_v0: .asciiz "$v0: "

.text
# Call search function
lw $a0, _id_to_delete
la $a1, _table
lw $a2, _table_size

jal delete

# Save $v0
move $s0, $v0

# Print $v0
la $a0, _v0
li $v0, 4
syscall

move $a0, $s0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

# Print the contents of the hash table
la $s0, _table
li $s1, 0  # Counter
lw $s2, _table_size

_print_loop:
	beq $s1, $s2, _exit_print_loop
	lw $t0, 0($s0)

	beqz $t0, _print_null
	li $t9, -1
	beq $t0, $t9, _print_tombstone
	
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
li $v0, 10
syscall

.include "../hw5.asm"
