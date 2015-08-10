.text
	.global _start
	.global _exit
	.global atoi

_exit:
	movq $1, %rax
	movq $234, %rbx
	int $0x80

_atoi:
	#Initialize the return value and the loop counter
	####################
	movq $0, %rax 
	movq $0, %rcx
	####################

	loop_start:
		#Exit the loop if the loop counter equals the index
		####################
		cmpq %rsi, %rcx
		je loop_exit
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
		jmp loop_start
		####################
		
	loop_exit:
		ret

_int_print:
	subq $4, %rsp #make room on the stack for a single character string
	movq $10, %rbx #initialize a constant
	movq $0, %rdx
	idiv %rbx
	addq $48, %rdx
	movq %rdx, (%rsp)
	movq $4, %rax
	movq $1, %rbx
	movq %rsp, %rcx
	movq $1, %rdx
	int $0x80
	addq $4, %rsp
	ret

_triangular:
	movq $0, %rax
	movq $0, %rcx

_start:
	#Output the prompt
	####################
	movq $4, %rax
	movq $1, %rbx #$1 is stdout
	movq $prompt, %rcx
	movq $len, %rdx
	int $0x80
	####################

	#Read in the number
	####################
	movq $3, %rax
	movq $0, %rbx #$0 is stdin
	movq $buff, %rcx
	movq $10, %rdx
	int $0x80
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

/*
	#Set up the arguments and call triangular
	####################
	movq %rax, %rdi
	####################
*/

	call _exit
	
	


.data

prompt:
	.ascii "Input (at most) a 10 digit number:\n"
	len = . - prompt

.bss
	.lcomm buff, 10
