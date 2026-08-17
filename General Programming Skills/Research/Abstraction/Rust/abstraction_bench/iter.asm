.section .text.abstraction_bench::sum_squares_iter,"ax",@progbits
	.globl	abstraction_bench::sum_squares_iter
	.p2align	4
.type	abstraction_bench::sum_squares_iter,@function
abstraction_bench::sum_squares_iter:
	.cfi_startproc
	test rsi, rsi
	je .LBB0_1
	xor ecx, ecx
	xor edx, edx
	xor eax, eax
	.p2align	4
.LBB0_3:
	mov r8, qword ptr [rdi + 8*rdx]
	imul r8, r8
	test r8b, 1
	cmovne r8, rcx
	add rax, r8
	inc rdx
	cmp rsi, rdx
	jne .LBB0_3
	ret
.LBB0_1:
	xor eax, eax
	ret
