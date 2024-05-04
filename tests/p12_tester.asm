# Test program for parts 1, 2
.data
.align 2
_record: .space 8

.text
lw $a0, _id
lw $a1, _credits
la $a2, _name
la $a3, _record

jal init_student

la $a0, _record
jal print_student

# Exit
li $v0, 10
syscall

.include "../hw5.asm"
