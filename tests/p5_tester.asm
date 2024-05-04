# Test program for part 5
.data
_null: .asciiz "NULL"
_v1: .asciiz "$v1: "

.text
# Call search function
lw $a0, _id_to_search
la $a1, _table
lw $a2, _table_size

jal search

# Save $v0
move $s0, $v0

# Print $v1
la $a0, _v1
li $v0, 4
syscall

move $a0, $v1
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

# Print returned student ptr
beqz $s0, _print_null

move $a0, $s0
jal print_student
j _exit

_print_null:
la $a0, _null
li $v0, 4
syscall

_exit:
li $v0, 10
syscall

.include "../hw5.asm"
