.data
_num_students: .word 0
_id_list: .word 
_credits_list: .word 
_names: .ascii

.align 2
_records: .space 0  # Must be 8 * num_students
_table: .space 20  # Must be 4 * table_size
_table_size: .word 5
_id_to_delete: .word 1264352

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
# X X X X X
la $s1, _table


# The below file will call the delete function with _id_to_delete
.include "p6_tester.asm"
