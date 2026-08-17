.section .text.abstraction_bench::variance_two_pass,"ax",@progbits
	.globl	abstraction_bench::variance_two_pass
	.p2align	4
.type	abstraction_bench::variance_two_pass,@function
abstraction_bench::variance_two_pass:
	.cfi_startproc
	cvtsi2sd xmm1, rsi
	test rsi, rsi
	je .LBB3_1
	shl rsi, 3
	xorpd xmm2, xmm2
	xor eax, eax
	.p2align	4
.LBB3_3:
	addsd xmm2, qword ptr [rdi + rax]
	add rax, 8
	cmp rsi, rax
	jne .LBB3_3
	divsd xmm2, xmm1
	xorpd xmm0, xmm0
	xor eax, eax
	.p2align	4
.LBB3_5:
	movsd xmm3, qword ptr [rdi + rax]
	subsd xmm3, xmm2
	mulsd xmm3, xmm3
	addsd xmm0, xmm3
	add rax, 8
	cmp rsi, rax
	jne .LBB3_5
	divsd xmm0, xmm1
	ret
.LBB3_1:
	xorpd xmm0, xmm0
	divsd xmm0, xmm1
	ret
