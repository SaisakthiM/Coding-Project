.section .text.abstraction_bench::sum_squares_boxed,"ax",@progbits
	.globl	abstraction_bench::sum_squares_boxed
	.p2align	4
.type	abstraction_bench::sum_squares_boxed,@function
abstraction_bench::sum_squares_boxed:
	.cfi_startproc
	push r14
	.cfi_def_cfa_offset 16
	push rbx
	.cfi_def_cfa_offset 24
	push rax
	.cfi_def_cfa_offset 32
	.cfi_offset rbx, -24
	.cfi_offset r14, -16
	mov rbx, rdi
	lea r14, [rdi + 8*rsi]
	call qword ptr [rip + __rustc::__rust_no_alloc_shim_is_unstable_v2@GOTPCREL]
	xor eax, eax
	.p2align	4
.LBB1_1:
	cmp rbx, r14
	je .LBB1_4
	mov rcx, qword ptr [rbx]
	add rbx, 8
	imul rcx, rcx
	test cl, 1
	jne .LBB1_1
	add rax, rcx
	jmp .LBB1_1
.LBB1_4:
	add rsp, 8
	.cfi_def_cfa_offset 24
	pop rbx
	.cfi_def_cfa_offset 16
	pop r14
	.cfi_def_cfa_offset 8
	ret
