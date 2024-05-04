.data
_num_students: .word 0
_id_list: .word
_credits_list: .word
_names: .ascii ""

.align 2
_records: .space 0  # Must be 8 * num_students

.include "p3_tester.asm"
