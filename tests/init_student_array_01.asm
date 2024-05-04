.data
_num_students: .word 3
_id_list: .word 3126375 1264356 553656
_credits_list: .word 314 511 290
_names: .ascii "Kevin T. McDonnell\0Wolfie Seawolf\0Kelly Chen\0"

.align 2
_records: .space 24  # Must be 8 * num_students

.include "p3_tester.asm"
