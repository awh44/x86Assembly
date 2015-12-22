.text
	.global _start
	.global _exit
	.global _atoi

_exit:
	movq $60, %rax #Exit is syscall 60
	movq $123, %rdi #Exit with status 0
	syscall #Execute the syscall

/**
	_atoi: Computes the (unsigned) integer representation of a character array. Currently works
	       with unsigned integers only
		int atoi(char *s, int length);
	@param %rdi - pointer to the string buffer (char *s)
	@param %rsi - length of the string (int length) @return %rax - the unsigned integer representation of the string
	@return %rax - the integer representation of the string
*/
_atoi:
	#Initialize the return value and the loop counter
	####################
	movq $0, %rax 
	movq $0, %rcx
	####################

	atoi_loop_start:
		#Exit the loop if the loop counter equals the index
		####################
		cmpq %rsi, %rcx
		je atoi_loop_exit
		####################

		#Otherwise, "shift" the return value by a place
		####################
		imul $10, %rax
		####################
	
		#Extract the current character from the string and "convert" it from ascii to integer
		#by subtracting the ascii value of '0'
		####################
		movb (%rdi, %rcx), %dl
		subq $48, %rdx
		####################

		#Add the converted character to the return value
		####################
		addq %rdx, %rax
		####################

		#Increment the loop counter and start the loop over
		####################
		inc %rcx
		jmp atoi_loop_start
		####################
		
	atoi_loop_exit:
		ret

_int_print:
	subq $4, %rsp #Make room on the stack
	movb $10, 1(%rsp) #Place the character '\n' on the stack
	movb $48, (%rsp) #Place the character '0' at the top/bottom of the stack

	movq $1, %rax
	movq $1, %rdi
	movq %rsp, %rsi
	movq $2, %rdx
	syscall

	
	addq $4, %rsp #Restore the stack
	ret

/**
	triangular: computes the triangular number with the given upper bound, i.e., sum(i, i = 0..n)
		int triangular(int n);
	@param %rdi - the triangular number to compute; the upper bound (int n); must be >= 0
	@return %rax - the nth triangular number
*/
_triangular:
	#Initialize the return value and the loop counter
	###################
	movq $0, %rax
	movq $0, %rcx
	####################

	tri_loop_start:
		#If the loop counter equals the upper bound, exit the loop
		###################
		cmpq %rdi, %rcx
		jg tri_loop_exit
		###################

		#Perform the addition to the return value
		###################
		addq %rcx, %rax
		###################

		#Increment the loop counter and jump back to the beginning of the loop
		###################
		inc %rcx
		jmp tri_loop_start
		###################
		
	tri_loop_exit:
		ret
	
_start:
	#Output the prompt
	####################
	movq $1, %rax #set up syscall number 1 (write)
	movq $1, %rdi #$1 is stdout
	movq $prompt, %rsi #printing the prompt
	movq $len, %rdx #length of the prompt
	syscall #execute the syscall
	####################

	#Read in the number
	####################
	movq $0, %rax #set up syscall number 0 (read)
	movq $0, %rdi #$0 is stdin
	movq $buff, %rsi #read into the buff buffer
	movq $10, %rdx #read at most ten characters
	syscall #execute the syscall
	####################

	#"Remove" the trailing '\n'
	####################
	subq $1, %rax
	####################

	#Set up the arguments and call atoi
	####################
	movq $buff, %rdi
	movq %rax, %rsi
	call _atoi
	####################

	#Set up the argument and call triangular
	####################
	movq %rax, %rdi
	call _triangular
	####################

	#Set up the argument and call int_print
	####################
	movq %rax, %rdi
	call _int_print
	####################

	call _exit

.data

prompt:
	.ascii "Input (at most) a 10 digit number:\n"
	len = . - prompt

.bss
	.lcomm buff, 10
