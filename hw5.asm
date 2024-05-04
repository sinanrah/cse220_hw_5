.data

.text
# rmb when to use move vs la *****
# void init_student(int id, int credits, char *name, struct student *record)
# $a0 = id (22 bits)
# $a1 = credits (10 bits)
# $a2 = *name (32 bits)
# $a3 = *record (8 bytes)



init_student:
	
    # store id first, 22 bits 
    sll $a0, $a0, 10           # shift id left 22
    sw $a0, 0($a3)             # then store in first word

    # store creds next
    andi $a1, $a1, 0x3FF       # preserve only rightmost 10 bits
    or $a0, $a0, $a1           # now or the two
    sw $a0, 0($a3)             # store in the record first 4

    # store name ptr
    sw $a2, 4($a3)             # store in the record last 4

    jr $ra                     # return
	
			
# void print_student(struct student *record)
print_student:

	# load and extract id & credits
	lw $t0, 0($a0) 		# load id, credits for use
	srl $t1, $t0, 10	# extract id, put in $t1
	andi $t2, $t0, 0x3FF 	# extract credits (cut off  id), put in $t2
	
	# load, save ptr
	lw $t3, 4($a0)

	# PRINT
	li $v0, 1
	move $a0, $t1
	syscall			# print id
	
	li $v0, 11
	li $a0, ' '	
	syscall			# print space CHAR
	
	li $v0, 1
	move $a0, $t2
	syscall			# print creds
	
	li $v0, 11
	li $a0, ' '	
	syscall			# print space CHAR
	
	li $v0, 4
	move $a0, $t3
	syscall			# print name STRING

	jr $ra

# void init_student_array(int num_students, int id_list[], int credits_list[], char *names, struct student records[])
# $a0 = num_students
# $a1 = id_list
# $a2 = int credits_list		wrong ignore
# $a3 = *names
# $a4 = records
init_student_array:
	# stack stuff
	addi $sp, $sp, -20		# make space on stack, 16 (4 regs) ---
	sw $ra, 0($sp)			# ra
	sw $s0, 4($sp)			# s0
	sw $s1, 8($sp)			# s1
	sw $s2, 12($sp)			# s2
	sw $s3, 16($sp)			# s3
	
	# move to saved / t regs
    	move $s0, $a0       		# num_students to $s0
    	move $s1, $a1       		# id_list to $s1
    	move $s2, $a2       		# credits_list to $s2
    	move $s3, $a3       		# names to $s3
    	lw $t0, 20($sp)     		# records to $t0 from stack
    	
    	li $t1, 0			# make t2 counter (i) for the loop
   
# loop runs num_students times, goes through names, ids, credits, initializes, then iterates	
init_loop:
	beq $t1, $s0, end 		# if (i == num_students) break;
	
	# find the current id, creds, ready args for init_student
	sll  $t2, $t1, 2 		# $t2 increments by 4 bytes --> $t2 = $t1(i) * 4 (both lists are of ints, offset is 4)
	add $t3, $s1, $t2		# $t3 has addr of id_list[i]
	add $t4, $s2, $t2  		# $t5 has addr of credits_list[i]
	
    	lw $a0, 0($t3)      		# $a0 = id_list[i]		 arg1, id
    	lw $a1, 0($t4)      		# $a1 = credits_list[i]	arg2, creds
    	
    		
    	# get ptr of current name (arg3)
    	move $a2, $s3 			# $a2 = names (current name)
    	
    	# get current student record addr
    	sll $t2, $t1, 3			# t3 = i * 8 -- records offset
    	add $a3, $t0, $t2		# addr of records[i]		
	
	# args done now init
	jal init_student
	
	#iterate to next name
	move $t4, $s3              	# t4 is current name ptr
	
	# now need to ccheck if names pts to next name
	check_null_loop:
		lb $t5, 0($t4)		# t6 is what names points to currently
		beqz $t5, if_null	# check if it points to (first char) '\0', goto if_null
		addi $t4, $t4, 1	# if not then keep going, loop
		j check_null_loop
	
	if_null:
		addi $s3, $t4, 1 	# final increment since now we are 1 past the null terminator, or front of next name
		addi $t1, $t1, 1	# finally increment i, loop again
		j init_loop
		
	end:
	# restore the stack, increment sp
		lw $ra, 0($sp)      	# ra
    		lw $s0, 4($sp)      	# s0  
    		lw $s1, 8($sp)      	# s1
		lw $s2, 12($sp)     	# s2
		lw $s3, 16($sp)		# S3
    		addi $sp, $sp, 20  	# deallocate (add)
    		jr $ra              	# return


# int insert(struct student *record, struct student *table[], int table_size)	
insert:

# calc hash index, iterate thru table to insert, check for all cases

	#stack stuff
	addiu $sp, $sp, -20 		# allocate space -- 5 regs
    	sw $ra, 0($sp)      		# $ra 
    	sw $s0, 4($sp)      		# $s0 
    	sw $s1, 8($sp)      		# $s1
    	sw $s2, 12($sp)     		# $s2 
    	sw $s3, 16($sp)     		# $s3 for counter	
    	
    	# move to saved regs
    	move $s0, $a0       		# record to $s0
    	move $s1, $a1       		# table to $s1
    	move $s2, $a2       		# table_size $s2
    	
    	# hash index calculation id mod table size
    	lw $t0, 0($s0)      		# record -> id to t0
    	divu $t0, $s2       		# mod table size
    	mfhi $t1            		# hash index in t1, mod value
    	li $s3, 0           		# set s3 = i = 0

# now iterate thru table, find empty spot or return if table full    	
insert_loop:
    	beq $s3, $s2, if_full  	# table is full if i(s3) = table size

    	# get current index
    	addu $t2, $t1, $s3  
    	divu $t2, $s2
    	mfhi $t2			# hash index + i mod tablesize


    	# check empty: NULL or tombstone: 0xFFFFFFFF
    	
    	sll $t3, $t2, 2     		## current index * 4
    	
    	addu $t4, $s1, $t3  		# t4 points to table[current index]
    	
    	# do both checks
    	lw $t5, 0($t4)      		# t5 is value of table[current index]
    	beqz $t5, do_insert 		# shortcut to check if table[current index] is null, then we continue with insertion at this spot
    	li $t6, -1			# load -1 in reg to do next line
    	beq $t5, $t6, do_insert 	# if it's -1 (tombstone) insert at this spot

    	addi $s3, $s3, 1    		# then iterate i++	
    	j insert_loop			# loop

	do_insert:
		
    		sw $s0, 0($t4)		# store pointer to rec
    		move $v0, $t2		# move index to return reg
    		j insert_complete

	if_full:
	
    		li $v0, -1		# return -1

	insert_complete:
		# revert stack stuff
    		lw $ra, 0($sp)      	# $ra 
    		lw $s0, 4($sp)      	# s0
    		lw $s1, 8($sp)      	# s1 
    		lw $s2, 12($sp)     	# s2
    		lw $s3, 16($sp)     	# s3
    		addiu $sp, $sp, 20  	# deallocate (add 20)
		jr $ra			# return
	
	
# (struct student*, int) search(int id, struct student *table[], int table_size)
search:

	# stack
    	addiu $sp, $sp, -16     	# stack space - 16
    	sw $ra, 0($sp)          	# ra
    	sw $s0, 4($sp)          	# $s0
   	sw $s1, 8($sp)          	# $s1
   	sw $s2, 12($sp)         	# $s2
    
    	# init variables
    	move $s0, $a0           	# id to s0
    	move $s1, $a1           	# table to s1
    	move $s2, $a2          		# table size to s2
    
    	# get hash index
    	divu $s0, $s2           	# 
    	mfhi $t0                	# $s0 mod $s2 to t0 (hash index)
    	
    	li $t1, 0               	# index = t1 = i = 0
    
    	search_loop:
       		beq $t1, $s2, not_found # if iterate through entire loop --> i = table size, so not found
        
        	# get current index
        	addu $t2, $t0, $t1          
        	divu $t2, $s2
        	mfhi $t2		# (hash index + i) mod table size
        
        	# table [current index]
        	sll $t3, $t2, 2         # offset is 4, 4 * current index 
        	addu $t4, $s1, $t3      # address of table at cur index
        	lw $t5, 0($t4)          # value
        
        	# check empty (NULL) or tombstone (-1)
        	beqz $t5, not_found  	# if null, not found
        	li $t6, -1		# to check next line
        	beq $t5, $t6, not_found  # if -1, not found
        
       		# check id match
        	lw $t6, 0($t5)              # id
		srl $t6, $t6, 10            # shift right 10
        	bne $t6, $s0, search_next   # check equality, if not eq search next
        
        	# if not then entry found
        	move $v0, $t5               # value 
        	move $v1, $t2               # current index
        	j search_end
        
    	search_next:
        	addiu $t1, $t1, 1           # increment i
        	j search_loop
    
    	not_found:
        	li $v0, 0                   # NULL
        	li $v1, -1                  # -1
    
    	search_end:
       	# revert stack
        lw $ra, 0($sp)              	# ra
        lw $s0, 4($sp)             	# $s0
        lw $s1, 8($sp)              	# $s1
        lw $s2, 12($sp)             	# $s2
        addiu $sp, $sp, 16          	# deallocate, add
        jr $ra                      	# return


# int delete(int id, struct student *table[], int table_size)
delete:
    # stack
    addiu $sp, $sp, -16    	 	# allocate
    sw $ra, 0($sp)         	 	# ra
    sw $s0, 4($sp)         	 	# a0
    sw $s1, 8($sp)         	 	# $s1
    sw $s2, 12($sp)       		# $s2
    
    # set up arg for seach
    move $s0, $a0          	 	# i
    move $s1, $a1           		# table
    move $s2, $a2           		# table_size
    jal search
    
    # determine result
    beqz $v0, delete_not_found     	# if null, not found
    
    # delete if found
    sll $t0, $v1, 2         		# index * 4
    addu $t1, $s1, $t0      		# address table[index]
    li $t2, -1				# to do next line
    sw $t2, 0($t1)          		# table[index] = -1 
    
    move $v0, $v1           		# index to v0
    j delete_end
    
    delete_not_found:
        li $v0, -1          		# -1 to v0
    
    delete_end:

        lw $ra, 0($sp)      		# ra
        lw $s0, 4($sp)      		# $s0
        lw $s1, 8($sp)      		# $s1
        lw $s2, 12($sp)    		# $s2
        addiu $sp, $sp, 16  		# deallocate, add
        jr $ra              		# return
