.data
_num_students: .word 3
_id_list: .word 3126312, 1264324, 553617
_credits_list: .word 314, 511, 290
_names: .ascii "Kevin T. McDonnell\0Wolfie Seawolf\0Kelly Chen\0"

.align 2
_records: .space 24  # Must be 8 * num_students
_table: .space 20  # Must be 4 * table_size
_table_size: .word 5
_record_to_insert: .word 0  # Filled later

.text
main:
# Initialize student records array
lw $a0, _num_students
la $a1, _id_list
la $a2, _credits_list
la $a3, _names

addi $sp, $sp, -4
la $t0, _records
sw $t0, 0($sp)

jal init_student_array
addi $sp, $sp, 4

# Populate the table with existing records to nearly full
la $s1, _table
la $s0, _records

sw $s0, 8($s1)   # Store at index 2
addi $s0, $s0, 8
sw $s0, 16($s1)   # Store at index 4
addi $s0, $s0, 8

li $s2, -1
sw $s2, 12($s1)

sw $s0, _record_to_insert

# Now include the tester which will call the insert function
.include "p4_tester.asm"
