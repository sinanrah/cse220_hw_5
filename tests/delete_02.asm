.data
_num_students: .word 3
_id_list: .word 3126377 1264352 553654
_credits_list: .word 314 511 290
_names: .ascii "Kevin T. McDonnell\0Wolfie Seawolf\0Kelly Chen\0"

.align 2
_records: .space 24  # Must be 8 * num_students
_table: .space 20  # Must be 4 * table_size
_table_size: .word 5
_id_to_delete: .word 1264

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
# X X 7 2 4
la $s1, _table

la $s0, _records
sw $s0, 8($s1)  # Store at index 2

addi $s0, $s0, 8  # Next record
sw $s0, 12($s1)  # Store at index 3

addi $s0, $s0, 8  
sw $s0, 16($s1)  # Store at index 4

# The below file will call the delete function with _id_to_delete
.include "p6_tester.asm"
