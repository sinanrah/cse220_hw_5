.data
_num_students: .word 1
_id_list: .word 3126375 
_credits_list: .word 314
_names: .ascii "Kevin T. McDonnell\0"

.align 2
_records: .space 8  # Must be 8 * num_students
_table: .space 20  # Must be 4 * table_size
_table_size: .word 5
_id_to_delete: .word 3126375

.text
main:
# Initialize student records array (same for all test cases)
lw $a0, _num_students
la $a1, _id_list
la $a2, _credits_list
la $a3, _names

addi $sp, $sp, -4
la $t0, _records
sw $t0, 0($sp)

jal init_student_array
addi $sp, $sp, 4

# Populate the table
# 5 X X X X
la $s1, _table

la $s0, _records
sw $s0, 0($s1)  # Store at index 1

# The below file will call the delete function with _id_to_delete
.include "p6_tester.asm"
