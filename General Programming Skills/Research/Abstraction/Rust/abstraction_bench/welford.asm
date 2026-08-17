.section .text.abstraction_bench::variance_welford,"ax",@progbits
	.globl	abstraction_bench::variance_welford
	.p2align	4
.type	abstraction_bench::variance_welford,@function
abstraction_bench::variance_welford:
	.cfi_startproc
	test rsi, rsi
	je .LBB1_1
	mov rax, rsi
	neg rax
	xorpd xmm1, xmm1
	mov ecx, 1
	xorpd xmm0, xmm0
	.p2align	4
.LBB1_3:
	movapd xmm2, xmm1
	movsd xmm3, qword ptr [rdi + 8*rcx - 8]
	movapd xmm4, xmm3
	subsd xmm4, xmm1
	xorps xmm5, xmm5
	cvtsi2sd xmm5, rcx
	movapd xmm1, xmm4
	divsd xmm1, xmm5
	addsd xmm1, xmm2
	subsd xmm3, xmm1
	mulsd xmm3, xmm4
	addsd xmm0, xmm3
	lea rdx, [rax + rcx]
	inc rdx
	inc rcx
	cmp rdx, 1
	jne .LBB1_3
	xorps xmm1, xmm1
	cvtsi2sd xmm1, rsi
	divsd xmm0, xmm1
	ret
.LBB1_1:
	xorpd xmm0, xmm0
	cvtsi2sd xmm1, rsi
	divsd xmm0, xmm1
	ret
