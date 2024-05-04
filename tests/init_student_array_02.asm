.data
_num_students: .word 1
_id_list: .word 123456
_credits_list: .word 78
_names: .ascii "John Doe\0"

.align 2
_records: .space 8  # Must be 8 * num_students

.include "p3_tester.asm"
