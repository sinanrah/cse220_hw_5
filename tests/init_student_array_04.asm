.data
_num_students: .word 1
_id_list: .word 4194303
_credits_list: .word 1023
_names: .ascii "Max Value\0"

.align 2
_records: .space 8  # Must be 8 * num_students

.include "p3_tester.asm"
