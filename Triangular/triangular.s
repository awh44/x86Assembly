.text
	.global _start
	.global _exit
	.global _atoi

_exit:
	movq $60, %rax #Exit is syscall 60
	movq $0, %rdi #Exit with status 0
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

/**
	_int_print: Prints the (unsigned) integer contained in %rdi
		void int_print(int n);
	@param %rdi - the integer to print
*/
_int_print:
	subq $4, %rsp #Make room on the stack, but keep it 4-byte aligned
	movb $10, 3(%rsp) #Add a newline to the end of the string
	movq $3, %r12 #Indicate that there are three places left in the stack
	movq $1, %r13 #Indicate that the string is of length 1

	movq $10, %r14 #Set up the 10 to be divided by
	movq %rdi, %r15 #Move the argument to a temporary register

	_int_print_loop_start:
		movq %r15, %rax	#Set up the integer for division
		cqo #Sign extend %rax into %rdx for division
		div %r14 #Perform the division by 10
		movq %rax, %r15 #Move the quotient back to the temporary register for the next iteration
		addq $48, %rdx #'Convert' the integer remainder to a character

		cmpq $0, %r12 #See if the remaining room on the stack is zero
		jne _int_print_room_remaining #If the remaining room is not zero, continue on
		subq $4, %rsp #Otherwise, make room on the stack
		movq $4, %r12 #Indicate that there are 4 bytes available on the stack

	_int_print_room_remaining:
		subq $1, %r12 #Subtract one from the available room on the stack
		movb %dl, (%rsp, %r12, 1) #Move the character to the stack at %rsp + %r10 * 1
		addq $1, %r13 #Increase the length of the string by one

		cmpq $0, %r15
		jne _int_print_loop_start

	movq $1, %rax #1 is the syscall number for write
	movq $1, %rdi #1 is the file descriptor for stdout
	movq %rsp, %rsi #Make the stack pointer as buffer argument
	addq %r12, %rsi #Add the remaining 'empty' room on the stack to the stack pointer value
	movq %r13, %rdx #Indicate the length of the string/buffer to print
	syscall #Execute the write syscall

	addq %r13, %rsp #Add the string length back to the stack
	add %r12, %rsp #Add the remaining stack space back to the stack

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
