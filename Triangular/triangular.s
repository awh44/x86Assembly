.text
	.global _start
	.global _exit

_exit:
	movl $1, %eax
	movl $0, %ebx
	int $0x80

_triangular:
	ret

_start:
	#Output the prompt
	####################
	movl $len, %edx
	movl $prompt, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80
	####################

	#Read in the number
	####################
	movl $3, %eax
	movl $0, %ebx
	movl $buff, %ecx
	movl $10, %edx
	int $0x80
	####################

/*	
	movl $4, %eax
	movl $1, %ebx
	movl $buff, %ecx
	movl $10, %edx
	int $0x80
*/
	call _exit
	
	


.data

prompt:
	.ascii "Input (at most) a 10 digit number:\n"
	len = . - prompt

.bss
	.lcomm buff, 10
