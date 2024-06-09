	.file	"demo.cpp"
	.section .rdata,"dr"
LC0:
	.ascii "%s: \0"
LC1:
	.ascii "%016llx\11\0"
	.text
	.globl	__Z12print_hex_64PKcPKyi
	.def	__Z12print_hex_64PKcPKyi;	.scl	2;	.type	32;	.endef
__Z12print_hex_64PKcPKyi:
LFB23:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$LC0, (%esp)
	call	_printf
	movl	$0, -12(%ebp)
L3:
	cmpl	$4, -12(%ebp)
	jg	L2
	movl	-12(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, 4(%esp)
	movl	%edx, 8(%esp)
	movl	$LC1, (%esp)
	call	_printf
	addl	$1, -12(%ebp)
	jmp	L3
L2:
	movl	$10, (%esp)
	call	_putchar
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE23:
	.globl	__Z15bytes_to_uint64PKh
	.def	__Z15bytes_to_uint64PKh;	.scl	2;	.type	32;	.endef
__Z15bytes_to_uint64PKh:
LFB24:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$0, -8(%ebp)
	movl	$0, -4(%ebp)
	movl	$0, -12(%ebp)
L6:
	cmpl	$7, -12(%ebp)
	jg	L5
	movl	-8(%ebp), %eax
	movl	-4(%ebp), %edx
	shldl	$8, %eax, %edx
	sall	$8, %eax
	movl	%eax, -8(%ebp)
	movl	%edx, -4(%ebp)
	movl	-12(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	orl	%eax, -8(%ebp)
	orl	%edx, -4(%ebp)
	addl	$1, -12(%ebp)
	jmp	L6
L5:
	movl	-8(%ebp), %eax
	movl	-4(%ebp), %edx
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE24:
	.globl	__Z15uint64_to_bytesyPh
	.def	__Z15uint64_to_bytesyPh;	.scl	2;	.type	32;	.endef
__Z15uint64_to_bytesyPh:
LFB25:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -20(%ebp)
	movl	$7, -4(%ebp)
L10:
	cmpl	$0, -4(%ebp)
	js	L11
	movl	-4(%ebp), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movl	-24(%ebp), %edx
	movb	%dl, (%eax)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	shrdl	$8, %edx, %eax
	shrl	$8, %edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	subl	$1, -4(%ebp)
	jmp	L10
L11:
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE25:
	.section .rdata,"dr"
LC2:
	.ascii "%s:\0"
LC3:
	.ascii " %02x\0"
LC4:
	.ascii " (%d bytes)\12\0"
	.text
	.globl	__Z9print_hexPKcPKhj
	.def	__Z9print_hexPKcPKhj;	.scl	2;	.type	32;	.endef
__Z9print_hexPKcPKhj:
LFB26:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$LC2, (%esp)
	call	_printf
	movl	$0, -12(%ebp)
L14:
	movl	-12(%ebp), %eax
	cmpl	16(%ebp), %eax
	jnb	L13
	movl	12(%ebp), %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, 4(%esp)
	movl	$LC3, (%esp)
	call	_printf
	addl	$1, -12(%ebp)
	jmp	L14
L13:
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$LC4, (%esp)
	call	_printf
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE26:
	.section .rdata,"dr"
LC5:
	.ascii "ciphertext\0"
	.text
	.globl	__Z13ascon_encryptPKhS0_S0_jS0_jPhS1_
	.def	__Z13ascon_encryptPKhS0_S0_jS0_jPhS1_;	.scl	2;	.type	32;	.endef
__Z13ascon_encryptPKhS0_S0_jS0_jPhS1_:
LFB27:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	subl	$68, %esp
	.cfi_offset 7, -12
	leal	-48(%ebp), %edx
	movl	$0, %eax
	movl	$10, %ecx
	movl	%edx, %edi
	rep stosl
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z16ascon_initializePyPKhS1_
	movl	20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z29ascon_process_associated_dataPyPKhj
	movl	28(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z23ascon_process_plaintextPyPhPKhj
	movl	28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$LC5, (%esp)
	call	__Z9print_hexPKcPKhj
	movl	36(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z14ascon_finalizePyPKhPh
	nop
	addl	$68, %esp
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE27:
	.section .rdata,"dr"
LC6:
	.ascii "plaintext_receive\0"
LC7:
	.ascii "check_tag\0"
LC8:
	.ascii "tag\0"
	.text
	.globl	__Z13ascon_decryptPKhS0_S0_jS0_jS0_Ph
	.def	__Z13ascon_decryptPKhS0_S0_jS0_jS0_Ph;	.scl	2;	.type	32;	.endef
__Z13ascon_decryptPKhS0_S0_jS0_jS0_Ph:
LFB28:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	subl	$84, %esp
	.cfi_offset 7, -12
	leal	-48(%ebp), %edx
	movl	$0, %eax
	movl	$10, %ecx
	movl	%edx, %edi
	rep stosl
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z16ascon_initializePyPKhS1_
	movl	20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z29ascon_process_associated_dataPyPKhj
	movl	28(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	36(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z24ascon_process_ciphertextPyPhPKhj
	movl	28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	36(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$LC6, (%esp)
	call	__Z9print_hexPKcPKhj
	leal	-64(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z14ascon_finalizePyPKhPh
	movl	$16, 8(%esp)
	leal	-64(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$LC7, (%esp)
	call	__Z9print_hexPKcPKhj
	movl	$16, 8(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$LC8, (%esp)
	call	__Z9print_hexPKcPKhj
	movl	$16, 8(%esp)
	leal	-64(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	32(%ebp), %eax
	movl	%eax, (%esp)
	call	_memcmp
	testl	%eax, %eax
	jne	L17
	movl	$0, %eax
	jmp	L19
L17:
	movl	$-1, %eax
L19:
	addl	$84, %esp
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE28:
	.globl	__Z14bytes_to_statePyPKh
	.def	__Z14bytes_to_statePyPKh;	.scl	2;	.type	32;	.endef
__Z14bytes_to_statePyPKh:
LFB29:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$36, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movl	$0, -20(%ebp)
L24:
	cmpl	$4, -20(%ebp)
	jg	L25
	movl	-20(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	$0, (%eax)
	movl	$0, 4(%eax)
	movl	$0, -24(%ebp)
L23:
	cmpl	$7, -24(%ebp)
	jg	L22
	movl	-20(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	8(%ebp), %eax
	leal	(%edx,%eax), %edi
	movl	-20(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, -48(%ebp)
	movl	%edx, -44(%ebp)
	movl	-20(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	-24(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, %ebx
	movl	$0, %esi
	movl	$7, %eax
	subl	-24(%ebp), %eax
	leal	0(,%eax,8), %ecx
	shldl	%cl, %ebx, %esi
	sall	%cl, %ebx
	testb	$32, %cl
	je	L26
	movl	%ebx, %esi
	xorl	%ebx, %ebx
L26:
	movl	%ebx, %eax
	movl	%esi, %edx
	movl	-48(%ebp), %ecx
	movl	-44(%ebp), %ebx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -40(%ebp)
	movl	%edx, %eax
	orl	%ebx, %eax
	movl	%eax, -36(%ebp)
	movl	-40(%ebp), %eax
	movl	-36(%ebp), %edx
	movl	%eax, (%edi)
	movl	%edx, 4(%edi)
	addl	$1, -24(%ebp)
	jmp	L23
L22:
	addl	$1, -20(%ebp)
	jmp	L24
L25:
	nop
	addl	$36, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE29:
	.section .rdata,"dr"
	.align 4
__ZZ17ascon_permutationPyiE9constants:
	.byte	-16
	.byte	-31
	.byte	-46
	.byte	-61
	.byte	-76
	.byte	-91
	.byte	-106
	.byte	-121
	.byte	120
	.byte	105
	.byte	90
	.byte	75
	.text
	.globl	__Z17ascon_permutationPyi
	.def	__Z17ascon_permutationPyi;	.scl	2;	.type	32;	.endef
__Z17ascon_permutationPyi:
LFB30:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$268, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movl	$12, %eax
	subl	12(%ebp), %eax
	movl	%eax, -28(%ebp)
L33:
	cmpl	$11, -28(%ebp)
	jg	L34
	movl	8(%ebp), %eax
	leal	16(%eax), %esi
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	(%eax), %ecx
	movl	4(%eax), %ebx
	movl	-28(%ebp), %eax
	addl	$__ZZ17ascon_permutationPyiE9constants, %eax
	movzbl	(%eax), %eax
	movb	%al, -257(%ebp)
	movzbl	-257(%ebp), %eax
	movl	$0, %edx
	movl	%ecx, %edi
	xorl	%eax, %edi
	movl	%edi, -104(%ebp)
	movl	%ebx, %edi
	xorl	%edx, %edi
	movl	%edi, -100(%ebp)
	movl	-104(%ebp), %eax
	movl	-100(%ebp), %edx
	movl	%eax, (%esi)
	movl	%edx, 4(%esi)
	movl	8(%ebp), %eax
	movl	(%eax), %ecx
	movl	4(%eax), %ebx
	movl	8(%ebp), %eax
	addl	$32, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%ecx, %edi
	xorl	%eax, %edi
	movl	%edi, -112(%ebp)
	movl	%ebx, %edi
	xorl	%edx, %edi
	movl	%edi, -108(%ebp)
	movl	8(%ebp), %eax
	movl	-112(%ebp), %edx
	movl	-108(%ebp), %ecx
	movl	%edx, (%eax)
	movl	%ecx, 4(%eax)
	movl	8(%ebp), %eax
	leal	32(%eax), %esi
	movl	8(%ebp), %eax
	addl	$32, %eax
	movl	(%eax), %ecx
	movl	4(%eax), %ebx
	movl	8(%ebp), %eax
	addl	$24, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%ecx, %edi
	xorl	%eax, %edi
	movl	%edi, -120(%ebp)
	movl	%ebx, %edi
	xorl	%edx, %edi
	movl	%edi, -116(%ebp)
	movl	-120(%ebp), %eax
	movl	-116(%ebp), %edx
	movl	%eax, (%esi)
	movl	%edx, 4(%esi)
	movl	8(%ebp), %eax
	leal	16(%eax), %esi
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	(%eax), %ecx
	movl	4(%eax), %ebx
	movl	8(%ebp), %eax
	addl	$8, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%ecx, %edi
	xorl	%eax, %edi
	movl	%edi, -128(%ebp)
	movl	%ebx, %edi
	xorl	%edx, %edi
	movl	%edi, -124(%ebp)
	movl	-128(%ebp), %eax
	movl	-124(%ebp), %edx
	movl	%eax, (%esi)
	movl	%edx, 4(%esi)
	movl	$0, -32(%ebp)
L30:
	cmpl	$4, -32(%ebp)
	jg	L29
	movl	-32(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %ebx
	movl	4(%eax), %esi
	movl	-32(%ebp), %eax
	leal	1(%eax), %ecx
	movl	$1717986919, %edx
	movl	%ecx, %eax
	imull	%edx
	sarl	%edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, %edx
	sall	$2, %edx
	addl	%eax, %edx
	movl	%ecx, %eax
	subl	%edx, %eax
	leal	0(,%eax,8), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, %edi
	notl	%edi
	movl	%edi, -96(%ebp)
	movl	%edx, %eax
	notl	%eax
	movl	%eax, -92(%ebp)
	movl	-32(%ebp), %eax
	leal	2(%eax), %ecx
	movl	$1717986919, %edx
	movl	%ecx, %eax
	imull	%edx
	sarl	%edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, %edx
	sall	$2, %edx
	addl	%eax, %edx
	movl	%ecx, %eax
	subl	%edx, %eax
	leal	0(,%eax,8), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	-96(%ebp), %edi
	andl	%eax, %edi
	movl	%edi, -136(%ebp)
	movl	%edx, %eax
	andl	-92(%ebp), %eax
	movl	%eax, -132(%ebp)
	movl	-136(%ebp), %eax
	movl	-132(%ebp), %edx
	movl	%eax, %edi
	xorl	%ebx, %edi
	movl	%edi, -144(%ebp)
	xorl	%edx, %esi
	movl	%esi, -140(%ebp)
	movl	-32(%ebp), %eax
	movl	-144(%ebp), %ebx
	movl	-140(%ebp), %esi
	movl	%ebx, -80(%ebp,%eax,8)
	movl	%esi, -76(%ebp,%eax,8)
	addl	$1, -32(%ebp)
	jmp	L30
L29:
	movl	$0, -36(%ebp)
L32:
	cmpl	$4, -36(%ebp)
	jg	L31
	movl	-36(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	8(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-36(%ebp), %eax
	movl	-76(%ebp,%eax,8), %edx
	movl	-80(%ebp,%eax,8), %eax
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	addl	$1, -36(%ebp)
	jmp	L32
L31:
	movl	8(%ebp), %eax
	leal	8(%eax), %esi
	movl	8(%ebp), %eax
	addl	$8, %eax
	movl	(%eax), %ecx
	movl	4(%eax), %ebx
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%ecx, %edi
	xorl	%eax, %edi
	movl	%edi, -152(%ebp)
	movl	%ebx, %edi
	xorl	%edx, %edi
	movl	%edi, -148(%ebp)
	movl	-152(%ebp), %eax
	movl	-148(%ebp), %edx
	movl	%eax, (%esi)
	movl	%edx, 4(%esi)
	movl	8(%ebp), %eax
	movl	(%eax), %ecx
	movl	4(%eax), %ebx
	movl	8(%ebp), %eax
	addl	$32, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%ecx, %esi
	xorl	%eax, %esi
	movl	%esi, -160(%ebp)
	movl	%ebx, %esi
	xorl	%edx, %esi
	movl	%esi, -156(%ebp)
	movl	8(%ebp), %eax
	movl	-160(%ebp), %ebx
	movl	-156(%ebp), %esi
	movl	%ebx, (%eax)
	movl	%esi, 4(%eax)
	movl	8(%ebp), %eax
	leal	24(%eax), %esi
	movl	8(%ebp), %eax
	addl	$24, %eax
	movl	(%eax), %ecx
	movl	4(%eax), %ebx
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%ecx, %edi
	xorl	%eax, %edi
	movl	%edi, -168(%ebp)
	xorl	%edx, %ebx
	movl	%ebx, -164(%ebp)
	movl	-168(%ebp), %eax
	movl	-164(%ebp), %edx
	movl	%eax, (%esi)
	movl	%edx, 4(%esi)
	movl	8(%ebp), %eax
	leal	16(%eax), %ecx
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, %esi
	notl	%esi
	movl	%esi, -176(%ebp)
	movl	%edx, %eax
	notl	%eax
	movl	%eax, -172(%ebp)
	movl	-176(%ebp), %eax
	movl	-172(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	$19, 8(%esp)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__Z4rotryi
	movl	%eax, %ebx
	movl	%edx, %esi
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	$28, 8(%esp)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__Z4rotryi
	movl	%ebx, %edi
	xorl	%eax, %edi
	movl	%edi, -184(%ebp)
	movl	%esi, %ebx
	xorl	%edx, %ebx
	movl	%ebx, -180(%ebp)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	-184(%ebp), %ebx
	movl	-180(%ebp), %esi
	movl	%ebx, %ecx
	xorl	%eax, %ecx
	movl	%ecx, -192(%ebp)
	movl	%edx, %eax
	xorl	%esi, %eax
	movl	%eax, -188(%ebp)
	movl	8(%ebp), %eax
	movl	-192(%ebp), %ebx
	movl	-188(%ebp), %esi
	movl	%ebx, (%eax)
	movl	%esi, 4(%eax)
	movl	8(%ebp), %eax
	addl	$8, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	$61, 8(%esp)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__Z4rotryi
	movl	%eax, %ebx
	movl	%edx, %esi
	movl	8(%ebp), %eax
	addl	$8, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	$39, 8(%esp)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__Z4rotryi
	movl	%ebx, %edi
	xorl	%eax, %edi
	movl	%edi, -200(%ebp)
	xorl	%edx, %esi
	movl	%esi, -196(%ebp)
	movl	8(%ebp), %eax
	leal	8(%eax), %ecx
	movl	8(%ebp), %eax
	addl	$8, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	-200(%ebp), %ebx
	movl	-196(%ebp), %esi
	movl	%ebx, %edi
	xorl	%eax, %edi
	movl	%edi, -208(%ebp)
	movl	%edx, %eax
	xorl	%esi, %eax
	movl	%eax, -204(%ebp)
	movl	-208(%ebp), %eax
	movl	-204(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	$1, 8(%esp)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__Z4rotryi
	movl	%eax, %ebx
	movl	%edx, %esi
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	$6, 8(%esp)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__Z4rotryi
	movl	%ebx, %ecx
	xorl	%eax, %ecx
	movl	%ecx, -216(%ebp)
	movl	%esi, %ebx
	xorl	%edx, %ebx
	movl	%ebx, -212(%ebp)
	movl	8(%ebp), %eax
	leal	16(%eax), %ecx
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	-216(%ebp), %ebx
	movl	-212(%ebp), %esi
	movl	%ebx, %edi
	xorl	%eax, %edi
	movl	%edi, -224(%ebp)
	movl	%edx, %eax
	xorl	%esi, %eax
	movl	%eax, -220(%ebp)
	movl	-224(%ebp), %eax
	movl	-220(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	movl	8(%ebp), %eax
	addl	$24, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	$10, 8(%esp)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__Z4rotryi
	movl	%eax, %ebx
	movl	%edx, %esi
	movl	8(%ebp), %eax
	addl	$24, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	$17, 8(%esp)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__Z4rotryi
	movl	%ebx, %ecx
	xorl	%eax, %ecx
	movl	%ecx, -232(%ebp)
	xorl	%edx, %esi
	movl	%esi, -228(%ebp)
	movl	8(%ebp), %eax
	leal	24(%eax), %ecx
	movl	8(%ebp), %eax
	addl	$24, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	-232(%ebp), %ebx
	movl	-228(%ebp), %esi
	movl	%ebx, %edi
	xorl	%eax, %edi
	movl	%edi, -240(%ebp)
	movl	%edx, %eax
	xorl	%esi, %eax
	movl	%eax, -236(%ebp)
	movl	-240(%ebp), %eax
	movl	-236(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	movl	8(%ebp), %eax
	addl	$32, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	$7, 8(%esp)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__Z4rotryi
	movl	%eax, %ebx
	movl	%edx, %esi
	movl	8(%ebp), %eax
	addl	$32, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	$41, 8(%esp)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__Z4rotryi
	movl	%ebx, %ecx
	xorl	%eax, %ecx
	movl	%ecx, -248(%ebp)
	movl	%esi, %ebx
	xorl	%edx, %ebx
	movl	%ebx, -244(%ebp)
	movl	8(%ebp), %eax
	leal	32(%eax), %ecx
	movl	8(%ebp), %eax
	addl	$32, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	-248(%ebp), %ebx
	movl	-244(%ebp), %esi
	movl	%ebx, %edi
	xorl	%eax, %edi
	movl	%edi, -256(%ebp)
	movl	%edx, %eax
	xorl	%esi, %eax
	movl	%eax, -252(%ebp)
	movl	-256(%ebp), %eax
	movl	-252(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	addl	$1, -28(%ebp)
	jmp	L33
L34:
	nop
	addl	$268, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE30:
	.globl	__Z4rotryi
	.def	__Z4rotryi;	.scl	2;	.type	32;	.endef
__Z4rotryi:
LFB31:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%esi
	pushl	%ebx
	subl	$24, %esp
	.cfi_offset 6, -12
	.cfi_offset 3, -16
	movl	8(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-16(%ebp), %ebx
	movl	-12(%ebp), %esi
	movl	16(%ebp), %ecx
	movl	%ebx, %eax
	movl	%esi, %edx
	shrdl	%cl, %edx, %eax
	shrl	%cl, %edx
	testb	$32, %cl
	je	L37
	movl	%edx, %eax
	xorl	%edx, %edx
L37:
	movl	%eax, -32(%ebp)
	movl	%edx, -28(%ebp)
	movl	16(%ebp), %eax
	negl	%eax
	andl	$63, %eax
	movl	%eax, %ecx
	movl	%ebx, %eax
	movl	%esi, %edx
	shldl	%cl, %eax, %edx
	sall	%cl, %eax
	testb	$32, %cl
	je	L38
	movl	%eax, %edx
	xorl	%eax, %eax
L38:
	movl	-32(%ebp), %ebx
	movl	-28(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -24(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -20(%ebp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	addl	$24, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE31:
	.globl	__Z13reverse_bytesy
	.def	__Z13reverse_bytesy;	.scl	2;	.type	32;	.endef
__Z13reverse_bytesy:
LFB32:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$108, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movl	8(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -20(%ebp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$24, %edx
	movl	%eax, -32(%ebp)
	movl	%edx, -28(%ebp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$8, %edx
	movl	%eax, %ecx
	andl	$0, %ecx
	movl	%ecx, %esi
	movl	%edx, %eax
	andl	$16711680, %eax
	movl	%eax, %edi
	movl	-32(%ebp), %eax
	orl	%esi, %eax
	movl	%eax, -40(%ebp)
	movl	-28(%ebp), %eax
	orl	%edi, %eax
	movl	%eax, -36(%ebp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	shldl	$24, %eax, %edx
	sall	$24, %eax
	movl	%eax, %edi
	andl	$0, %edi
	movl	%edi, -48(%ebp)
	movl	%edx, %eax
	andl	$65280, %eax
	movl	%eax, -44(%ebp)
	movl	-40(%ebp), %ecx
	movl	-36(%ebp), %ebx
	movl	%ecx, %edi
	movl	-48(%ebp), %eax
	movl	-44(%ebp), %edx
	orl	%eax, %edi
	movl	%edi, -56(%ebp)
	movl	%ebx, %edi
	orl	%edx, %edi
	movl	%edi, -52(%ebp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	shldl	$8, %eax, %edx
	sall	$8, %eax
	movl	%eax, %ebx
	andl	$0, %ebx
	movl	%ebx, -64(%ebp)
	movzbl	%dl, %eax
	movl	%eax, -60(%ebp)
	movl	-56(%ebp), %esi
	movl	-52(%ebp), %edi
	movl	%esi, %ecx
	movl	-64(%ebp), %eax
	movl	-60(%ebp), %edx
	orl	%eax, %ecx
	movl	%ecx, -72(%ebp)
	orl	%edx, %edi
	movl	%edi, -68(%ebp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	shrdl	$8, %edx, %eax
	shrl	$8, %edx
	movl	%eax, %esi
	andl	$-16777216, %esi
	movl	%esi, -80(%ebp)
	movl	%edx, %eax
	andl	$0, %eax
	movl	%eax, -76(%ebp)
	movl	-72(%ebp), %ecx
	movl	-68(%ebp), %ebx
	movl	%ecx, %edi
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	orl	%eax, %edi
	movl	%edi, -88(%ebp)
	orl	%edx, %ebx
	movl	%ebx, -84(%ebp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	shrdl	$24, %edx, %eax
	shrl	$24, %edx
	movl	%eax, %esi
	andl	$16711680, %esi
	movl	%esi, -96(%ebp)
	movl	%edx, %eax
	andl	$0, %eax
	movl	%eax, -92(%ebp)
	movl	-88(%ebp), %ecx
	movl	-84(%ebp), %ebx
	movl	%ecx, %edi
	movl	-96(%ebp), %eax
	movl	-92(%ebp), %edx
	orl	%eax, %edi
	movl	%edi, -104(%ebp)
	movl	%ebx, %ecx
	orl	%edx, %ecx
	movl	%ecx, -100(%ebp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%edx, %eax
	xorl	%edx, %edx
	shrl	$8, %eax
	movl	%eax, %ebx
	andl	$65280, %ebx
	movl	%ebx, -112(%ebp)
	movl	%edx, %eax
	andl	$0, %eax
	movl	%eax, -108(%ebp)
	movl	-104(%ebp), %ebx
	movl	-100(%ebp), %esi
	movl	%ebx, %ecx
	movl	-112(%ebp), %eax
	movl	-108(%ebp), %edx
	orl	%eax, %ecx
	movl	%ecx, -120(%ebp)
	orl	%edx, %esi
	movl	%esi, -116(%ebp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%edx, %eax
	xorl	%edx, %edx
	shrl	$24, %eax
	movl	-120(%ebp), %ebx
	movl	-116(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -24(%ebp)
	movl	%esi, %ebx
	orl	%edx, %ebx
	movl	%ebx, %eax
	movl	%eax, -20(%ebp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	addl	$108, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE32:
	.section .rdata,"dr"
	.align 4
__ZZ16ascon_initializePyPKhS1_E2iv:
	.byte	-128
	.byte	64
	.byte	12
	.byte	6
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.text
	.globl	__Z16ascon_initializePyPKhS1_
	.def	__Z16ascon_initializePyPKhS1_;	.scl	2;	.type	32;	.endef
__Z16ascon_initializePyPKhS1_:
LFB33:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$172, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movl	__ZZ16ascon_initializePyPKhS1_E2iv, %eax
	movl	__ZZ16ascon_initializePyPKhS1_E2iv+4, %edx
	movl	%eax, -68(%ebp)
	movl	%edx, -64(%ebp)
	leal	-68(%ebp), %eax
	addl	$8, %eax
	movl	12(%ebp), %edx
	movl	(%edx), %ecx
	movl	%ecx, -168(%ebp)
	movl	4(%edx), %ecx
	movl	%ecx, -164(%ebp)
	movl	8(%edx), %ecx
	movl	%ecx, -160(%ebp)
	movl	12(%edx), %edi
	movl	%edi, -156(%ebp)
	movl	-168(%ebp), %ecx
	movl	%ecx, (%eax)
	movl	-164(%ebp), %edi
	movl	%edi, 4(%eax)
	movl	-160(%ebp), %ecx
	movl	%ecx, 8(%eax)
	movl	-156(%ebp), %edi
	movl	%edi, 12(%eax)
	leal	-68(%ebp), %eax
	addl	$24, %eax
	movl	16(%ebp), %edx
	movl	(%edx), %ecx
	movl	%ecx, -168(%ebp)
	movl	4(%edx), %edi
	movl	%edi, -164(%ebp)
	movl	8(%edx), %ecx
	movl	%ecx, -160(%ebp)
	movl	12(%edx), %edi
	movl	%edi, -156(%ebp)
	movl	-168(%ebp), %ecx
	movl	%ecx, (%eax)
	movl	-164(%ebp), %edi
	movl	%edi, 4(%eax)
	movl	-160(%ebp), %ecx
	movl	%ecx, 8(%eax)
	movl	-156(%ebp), %edi
	movl	%edi, 12(%eax)
	leal	-68(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z14bytes_to_statePyPKh
	movl	$12, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z17ascon_permutationPyi
	leal	-108(%ebp), %edx
	movl	$0, %eax
	movl	$10, %ecx
	movl	%edx, %edi
	rep stosl
	leal	-108(%ebp), %eax
	addl	$24, %eax
	movl	12(%ebp), %edx
	movl	(%edx), %ecx
	movl	%ecx, -168(%ebp)
	movl	4(%edx), %edi
	movl	%edi, -164(%ebp)
	movl	8(%edx), %ecx
	movl	%ecx, -160(%ebp)
	movl	12(%edx), %edx
	movl	%edx, -156(%ebp)
	movl	-168(%ebp), %edi
	movl	%edi, (%eax)
	movl	-164(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	-160(%ebp), %ecx
	movl	%ecx, 8(%eax)
	movl	-156(%ebp), %edi
	movl	%edi, 12(%eax)
	leal	-108(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z14bytes_to_statePyPKh
	movl	$0, -28(%ebp)
L43:
	cmpl	$4, -28(%ebp)
	jg	L44
	movl	-28(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	8(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-28(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, -168(%ebp)
	movl	%edx, -164(%ebp)
	movl	-28(%ebp), %eax
	movl	-148(%ebp,%eax,8), %edx
	movl	-152(%ebp,%eax,8), %eax
	movl	-168(%ebp), %edi
	xorl	%eax, %edi
	movl	%edi, %ebx
	movl	-164(%ebp), %edi
	xorl	%edx, %edi
	movl	%edi, %esi
	movl	%ebx, (%ecx)
	movl	%esi, 4(%ecx)
	addl	$1, -28(%ebp)
	jmp	L43
L44:
	nop
	addl	$172, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE33:
	.globl	__Z29ascon_process_associated_dataPyPKhj
	.def	__Z29ascon_process_associated_dataPyPKhj;	.scl	2;	.type	32;	.endef
__Z29ascon_process_associated_dataPyPKhj:
LFB34:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$204, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	cmpl	$0, 16(%ebp)
	je	L46
	movl	16(%ebp), %eax
	shrl	$3, %eax
	movl	%eax, -32(%ebp)
	movl	16(%ebp), %eax
	andl	$7, %eax
	movl	%eax, -36(%ebp)
	movl	$0, -28(%ebp)
L48:
	movl	-28(%ebp), %eax
	cmpl	-32(%ebp), %eax
	jnb	L47
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, -200(%ebp)
	movl	%edx, -196(%ebp)
	movl	-28(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %ebx
	movl	%edx, %esi
	movl	%ebx, %esi
	movl	$0, %ebx
	sall	$24, %esi
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	1(%eax), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$16, %edx
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -64(%ebp)
	movl	%esi, %edi
	orl	%edx, %edi
	movl	%edi, -60(%ebp)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	2(%eax), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$8, %edx
	movl	-64(%ebp), %ebx
	movl	-60(%ebp), %esi
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -72(%ebp)
	movl	%edx, %edi
	orl	%esi, %edi
	movl	%edi, -68(%ebp)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	3(%eax), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	movl	-72(%ebp), %ebx
	movl	-68(%ebp), %esi
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -80(%ebp)
	movl	%edx, %edi
	orl	%esi, %edi
	movl	%edi, -76(%ebp)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	4(%eax), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$24, %eax, %edx
	sall	$24, %eax
	movl	-80(%ebp), %ebx
	movl	-76(%ebp), %esi
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -88(%ebp)
	movl	%edx, %edi
	orl	%esi, %edi
	movl	%edi, -84(%ebp)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	5(%eax), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$16, %eax, %edx
	sall	$16, %eax
	movl	-88(%ebp), %ebx
	movl	-84(%ebp), %esi
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -96(%ebp)
	movl	%edx, %edi
	orl	%esi, %edi
	movl	%edi, -92(%ebp)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	6(%eax), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$8, %eax, %edx
	sall	$8, %eax
	movl	-96(%ebp), %ebx
	movl	-92(%ebp), %esi
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -104(%ebp)
	orl	%esi, %edx
	movl	%edx, -100(%ebp)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	7(%eax), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	-104(%ebp), %ebx
	movl	-100(%ebp), %esi
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -112(%ebp)
	orl	%esi, %edx
	movl	%edx, -108(%ebp)
	movl	-200(%ebp), %eax
	movl	-196(%ebp), %edx
	movl	%eax, %edi
	movl	-112(%ebp), %ebx
	movl	-108(%ebp), %esi
	xorl	%ebx, %edi
	movl	%edi, -120(%ebp)
	movl	%edx, %eax
	xorl	%esi, %eax
	movl	%eax, -116(%ebp)
	movl	8(%ebp), %eax
	movl	-120(%ebp), %esi
	movl	-116(%ebp), %edi
	movl	%esi, (%eax)
	movl	%edi, 4(%eax)
	movl	$6, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z17ascon_permutationPyi
	addl	$1, -28(%ebp)
	jmp	L48
L47:
	movl	$0, -44(%ebp)
	movl	$0, -40(%ebp)
	movl	-32(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	12(%ebp), %eax
	addl	%eax, %edx
	movl	-36(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-44(%ebp), %eax
	movl	%eax, (%esp)
	call	_memcpy
	leal	-44(%ebp), %edx
	movl	-36(%ebp), %eax
	addl	%edx, %eax
	movb	$-128, (%eax)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, -64(%ebp)
	movl	%edx, -60(%ebp)
	movzbl	-44(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$24, %edx
	movl	%eax, %ecx
	movl	%edx, %ebx
	movzbl	-43(%ebp), %eax
	movb	%al, -72(%ebp)
	movzbl	-72(%ebp), %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$16, %edx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -128(%ebp)
	movl	%ebx, %esi
	orl	%edx, %esi
	movl	%esi, -124(%ebp)
	movzbl	-42(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$8, %edx
	movl	-128(%ebp), %ecx
	movl	-124(%ebp), %ebx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -136(%ebp)
	movl	%edx, %eax
	orl	%ebx, %eax
	movl	%eax, -132(%ebp)
	movzbl	-41(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	movl	-136(%ebp), %ecx
	movl	-132(%ebp), %ebx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -144(%ebp)
	movl	%edx, %eax
	orl	%ebx, %eax
	movl	%eax, -140(%ebp)
	movzbl	-40(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$24, %eax, %edx
	sall	$24, %eax
	movl	-144(%ebp), %ecx
	movl	-140(%ebp), %ebx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -152(%ebp)
	movl	%edx, %eax
	orl	%ebx, %eax
	movl	%eax, -148(%ebp)
	movzbl	-39(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$16, %eax, %edx
	sall	$16, %eax
	movl	-152(%ebp), %ecx
	movl	-148(%ebp), %ebx
	movl	%ecx, %edi
	orl	%eax, %edi
	movl	%edi, -160(%ebp)
	movl	%edx, %eax
	orl	%ebx, %eax
	movl	%eax, -156(%ebp)
	movzbl	-38(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$8, %eax, %edx
	sall	$8, %eax
	movl	-160(%ebp), %ecx
	movl	-156(%ebp), %ebx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -168(%ebp)
	movl	%edx, %eax
	orl	%ebx, %eax
	movl	%eax, -164(%ebp)
	movzbl	-37(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	-168(%ebp), %ecx
	movl	-164(%ebp), %ebx
	movl	%ecx, %edi
	orl	%eax, %edi
	movl	%edi, -176(%ebp)
	movl	%edx, %eax
	orl	%ebx, %eax
	movl	%eax, -172(%ebp)
	movl	-176(%ebp), %eax
	movl	-172(%ebp), %edx
	movl	%eax, %ebx
	movl	-64(%ebp), %esi
	movl	-60(%ebp), %edi
	xorl	%esi, %ebx
	movl	%ebx, -184(%ebp)
	movl	%edi, %esi
	xorl	%edx, %esi
	movl	%esi, -180(%ebp)
	movl	8(%ebp), %eax
	movl	-184(%ebp), %esi
	movl	-180(%ebp), %edi
	movl	%esi, (%eax)
	movl	%edi, 4(%eax)
	movl	$6, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z17ascon_permutationPyi
L46:
	movl	8(%ebp), %eax
	leal	32(%eax), %ecx
	movl	8(%ebp), %eax
	addl	$32, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, %edi
	xorl	$1, %edi
	movl	%edi, -192(%ebp)
	movl	%edx, %eax
	xorb	$0, %ah
	movl	%eax, -188(%ebp)
	movl	-192(%ebp), %eax
	movl	-188(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	nop
	addl	$204, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE34:
	.globl	__Z23ascon_process_plaintextPyPhPKhj
	.def	__Z23ascon_process_plaintextPyPhPKhj;	.scl	2;	.type	32;	.endef
__Z23ascon_process_plaintextPyPhPKhj:
LFB35:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$220, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movl	20(%ebp), %eax
	shrl	$3, %eax
	movl	%eax, -36(%ebp)
	movl	20(%ebp), %eax
	andl	$7, %eax
	movl	%eax, -40(%ebp)
	movl	$0, -28(%ebp)
L51:
	movl	-28(%ebp), %eax
	cmpl	-36(%ebp), %eax
	jnb	L50
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, -208(%ebp)
	movl	%edx, -204(%ebp)
	movl	-28(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %ebx
	movl	%edx, %esi
	movl	%ebx, %esi
	movl	$0, %ebx
	sall	$24, %esi
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	1(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$16, %edx
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -80(%ebp)
	movl	%esi, %edi
	orl	%edx, %edi
	movl	%edi, -76(%ebp)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	2(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$8, %edx
	movl	-80(%ebp), %ebx
	movl	-76(%ebp), %esi
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -88(%ebp)
	movl	%edx, %edi
	orl	%esi, %edi
	movl	%edi, -84(%ebp)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	3(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	movl	-88(%ebp), %ebx
	movl	-84(%ebp), %esi
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -96(%ebp)
	movl	%edx, %edi
	orl	%esi, %edi
	movl	%edi, -92(%ebp)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	4(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$24, %eax, %edx
	sall	$24, %eax
	movl	-96(%ebp), %ebx
	movl	-92(%ebp), %esi
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -104(%ebp)
	movl	%edx, %edi
	orl	%esi, %edi
	movl	%edi, -100(%ebp)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	5(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$16, %eax, %edx
	sall	$16, %eax
	movl	-104(%ebp), %ebx
	movl	-100(%ebp), %esi
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -112(%ebp)
	movl	%edx, %edi
	orl	%esi, %edi
	movl	%edi, -108(%ebp)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	6(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$8, %eax, %edx
	sall	$8, %eax
	movl	-112(%ebp), %ebx
	movl	-108(%ebp), %esi
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -120(%ebp)
	movl	%edx, %edi
	orl	%esi, %edi
	movl	%edi, -116(%ebp)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	7(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	-120(%ebp), %ebx
	movl	-116(%ebp), %esi
	movl	%ebx, %edi
	orl	%eax, %edi
	movl	%edi, -128(%ebp)
	movl	%edx, %edi
	orl	%esi, %edi
	movl	%edi, -124(%ebp)
	movl	-208(%ebp), %eax
	movl	-204(%ebp), %edx
	movl	%eax, %ebx
	movl	-128(%ebp), %esi
	movl	-124(%ebp), %edi
	xorl	%esi, %ebx
	movl	%ebx, -136(%ebp)
	movl	%edx, %eax
	xorl	%edi, %eax
	movl	%eax, -132(%ebp)
	movl	8(%ebp), %eax
	movl	-136(%ebp), %esi
	movl	-132(%ebp), %edi
	movl	%esi, (%eax)
	movl	%edi, 4(%eax)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, -48(%ebp)
	movl	%edx, -44(%ebp)
	movl	-28(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-48(%ebp), %eax
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	xorl	%edx, %edx
	shrl	$24, %eax
	movb	%al, (%ecx)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	1(%eax), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-48(%ebp), %eax
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	xorl	%edx, %edx
	shrl	$16, %eax
	movb	%al, (%ecx)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	2(%eax), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-48(%ebp), %eax
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	xorl	%edx, %edx
	shrl	$8, %eax
	movb	%al, (%ecx)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	3(%eax), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-48(%ebp), %eax
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	xorl	%edx, %edx
	movb	%al, (%ecx)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	4(%eax), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-48(%ebp), %eax
	movl	-44(%ebp), %edx
	shrdl	$24, %edx, %eax
	shrl	$24, %edx
	movb	%al, (%ecx)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	5(%eax), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-48(%ebp), %eax
	movl	-44(%ebp), %edx
	shrdl	$16, %edx, %eax
	shrl	$16, %edx
	movb	%al, (%ecx)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	6(%eax), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-48(%ebp), %eax
	movl	-44(%ebp), %edx
	shrdl	$8, %edx, %eax
	shrl	$8, %edx
	movb	%al, (%ecx)
	movl	-28(%ebp), %eax
	sall	$3, %eax
	leal	7(%eax), %edx
	movl	12(%ebp), %eax
	addl	%eax, %edx
	movl	-48(%ebp), %eax
	movb	%al, (%edx)
	movl	$6, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z17ascon_permutationPyi
	addl	$1, -28(%ebp)
	jmp	L51
L50:
	movl	$0, -64(%ebp)
	movl	$0, -60(%ebp)
	movl	-36(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	16(%ebp), %eax
	addl	%eax, %edx
	movl	-40(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	_memcpy
	leal	-64(%ebp), %edx
	movl	-40(%ebp), %eax
	addl	%edx, %eax
	movb	$-128, (%eax)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, -80(%ebp)
	movl	%edx, -76(%ebp)
	movzbl	-64(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$24, %edx
	movl	%eax, %ecx
	movl	%edx, %ebx
	movzbl	-63(%ebp), %eax
	movb	%al, -88(%ebp)
	movzbl	-88(%ebp), %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$16, %edx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -144(%ebp)
	movl	%ebx, %esi
	orl	%edx, %esi
	movl	%esi, -140(%ebp)
	movzbl	-62(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$8, %edx
	movl	-144(%ebp), %ecx
	movl	-140(%ebp), %ebx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -152(%ebp)
	movl	%edx, %eax
	orl	%ebx, %eax
	movl	%eax, -148(%ebp)
	movzbl	-61(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	movl	-152(%ebp), %ecx
	movl	-148(%ebp), %ebx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -160(%ebp)
	movl	%edx, %eax
	orl	%ebx, %eax
	movl	%eax, -156(%ebp)
	movzbl	-60(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$24, %eax, %edx
	sall	$24, %eax
	movl	-160(%ebp), %ecx
	movl	-156(%ebp), %ebx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -168(%ebp)
	movl	%edx, %eax
	orl	%ebx, %eax
	movl	%eax, -164(%ebp)
	movzbl	-59(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$16, %eax, %edx
	sall	$16, %eax
	movl	-168(%ebp), %ecx
	movl	-164(%ebp), %ebx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -176(%ebp)
	movl	%edx, %eax
	orl	%ebx, %eax
	movl	%eax, -172(%ebp)
	movzbl	-58(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$8, %eax, %edx
	sall	$8, %eax
	movl	-176(%ebp), %ecx
	movl	-172(%ebp), %ebx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -184(%ebp)
	movl	%edx, %eax
	orl	%ebx, %eax
	movl	%eax, -180(%ebp)
	movzbl	-57(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	-184(%ebp), %ecx
	movl	-180(%ebp), %ebx
	movl	%ecx, %edi
	orl	%eax, %edi
	movl	%edi, -192(%ebp)
	movl	%edx, %eax
	orl	%ebx, %eax
	movl	%eax, -188(%ebp)
	movl	-192(%ebp), %eax
	movl	-188(%ebp), %edx
	movl	%eax, %ebx
	movl	-80(%ebp), %esi
	movl	-76(%ebp), %edi
	xorl	%esi, %ebx
	movl	%ebx, -200(%ebp)
	movl	%edi, %esi
	xorl	%edx, %esi
	movl	%esi, -196(%ebp)
	movl	8(%ebp), %eax
	movl	-200(%ebp), %esi
	movl	-196(%ebp), %edi
	movl	%esi, (%eax)
	movl	%edi, 4(%eax)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, -56(%ebp)
	movl	%edx, -52(%ebp)
	movl	$0, -32(%ebp)
L53:
	movl	-32(%ebp), %eax
	cmpl	-40(%ebp), %eax
	jnb	L54
	movl	-36(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	-32(%ebp), %eax
	addl	%eax, %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ebx
	movl	-32(%ebp), %edx
	movl	$0, %eax
	subl	%edx, %eax
	sall	$3, %eax
	leal	56(%eax), %ecx
	movl	-56(%ebp), %eax
	movl	-52(%ebp), %edx
	shrdl	%cl, %edx, %eax
	shrl	%cl, %edx
	testb	$32, %cl
	je	L55
	movl	%edx, %eax
	xorl	%edx, %edx
L55:
	movb	%al, (%ebx)
	addl	$1, -32(%ebp)
	jmp	L53
L54:
	nop
	addl	$220, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE35:
	.globl	__Z24ascon_process_ciphertextPyPhPKhj
	.def	__Z24ascon_process_ciphertextPyPhPKhj;	.scl	2;	.type	32;	.endef
__Z24ascon_process_ciphertextPyPhPKhj:
LFB36:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%esi
	pushl	%ebx
	subl	$256, %esp
	.cfi_offset 6, -12
	.cfi_offset 3, -16
	movl	20(%ebp), %eax
	shrl	$3, %eax
	movl	%eax, -20(%ebp)
	movl	20(%ebp), %eax
	andl	$7, %eax
	movl	%eax, -24(%ebp)
	movl	$0, -12(%ebp)
L58:
	movl	-12(%ebp), %eax
	cmpl	-20(%ebp), %eax
	jnb	L57
	movl	-12(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$24, %edx
	movl	%eax, %ebx
	movl	%edx, %esi
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	1(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$16, %edx
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -96(%ebp)
	orl	%edx, %esi
	movl	%esi, -92(%ebp)
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	2(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$8, %edx
	movl	-96(%ebp), %ebx
	movl	-92(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -104(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -100(%ebp)
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	3(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	movl	-104(%ebp), %ebx
	movl	-100(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -112(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -108(%ebp)
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	4(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$24, %eax, %edx
	sall	$24, %eax
	movl	-112(%ebp), %ebx
	movl	-108(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -120(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -116(%ebp)
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	5(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$16, %eax, %edx
	sall	$16, %eax
	movl	-120(%ebp), %ebx
	movl	-116(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -128(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -124(%ebp)
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	6(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$8, %eax, %edx
	sall	$8, %eax
	movl	-128(%ebp), %ebx
	movl	-124(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -136(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -132(%ebp)
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	7(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	-136(%ebp), %ebx
	movl	-132(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -32(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -28(%ebp)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, %esi
	xorl	-32(%ebp), %esi
	movl	%esi, -144(%ebp)
	movl	%edx, %eax
	xorl	-28(%ebp), %eax
	movl	%eax, -140(%ebp)
	movl	8(%ebp), %eax
	movl	-144(%ebp), %edx
	movl	-140(%ebp), %ecx
	movl	%edx, (%eax)
	movl	%ecx, 4(%eax)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, -40(%ebp)
	movl	%edx, -36(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-40(%ebp), %eax
	movl	-36(%ebp), %edx
	movl	%edx, %eax
	xorl	%edx, %edx
	shrl	$24, %eax
	movb	%al, (%ecx)
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	1(%eax), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-40(%ebp), %eax
	movl	-36(%ebp), %edx
	movl	%edx, %eax
	xorl	%edx, %edx
	shrl	$16, %eax
	movb	%al, (%ecx)
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	2(%eax), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-40(%ebp), %eax
	movl	-36(%ebp), %edx
	movl	%edx, %eax
	xorl	%edx, %edx
	shrl	$8, %eax
	movb	%al, (%ecx)
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	3(%eax), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-40(%ebp), %eax
	movl	-36(%ebp), %edx
	movl	%edx, %eax
	xorl	%edx, %edx
	movb	%al, (%ecx)
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	4(%eax), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-40(%ebp), %eax
	movl	-36(%ebp), %edx
	shrdl	$24, %edx, %eax
	shrl	$24, %edx
	movb	%al, (%ecx)
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	5(%eax), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-40(%ebp), %eax
	movl	-36(%ebp), %edx
	shrdl	$16, %edx, %eax
	shrl	$16, %edx
	movb	%al, (%ecx)
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	6(%eax), %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-40(%ebp), %eax
	movl	-36(%ebp), %edx
	shrdl	$8, %edx, %eax
	shrl	$8, %edx
	movb	%al, (%ecx)
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	7(%eax), %edx
	movl	12(%ebp), %eax
	addl	%eax, %edx
	movl	-40(%ebp), %eax
	movb	%al, (%edx)
	movl	8(%ebp), %ecx
	movl	-32(%ebp), %eax
	movl	-28(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	movl	$6, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z17ascon_permutationPyi
	addl	$1, -12(%ebp)
	jmp	L58
L57:
	movl	$0, -72(%ebp)
	movl	$0, -68(%ebp)
	movl	-20(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	16(%ebp), %eax
	addl	%eax, %edx
	movl	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-72(%ebp), %eax
	movl	%eax, (%esp)
	call	_memcpy
	movzbl	-72(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$24, %edx
	movl	%eax, %ecx
	movl	%edx, %ebx
	movzbl	-71(%ebp), %eax
	movb	%al, -96(%ebp)
	movzbl	-96(%ebp), %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$16, %edx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -152(%ebp)
	orl	%edx, %ebx
	movl	%ebx, -148(%ebp)
	movzbl	-70(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$8, %edx
	movl	-152(%ebp), %ebx
	movl	-148(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -160(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -156(%ebp)
	movzbl	-69(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	movl	-160(%ebp), %ebx
	movl	-156(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -168(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -164(%ebp)
	movzbl	-68(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$24, %eax, %edx
	sall	$24, %eax
	movl	-168(%ebp), %ebx
	movl	-164(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -176(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -172(%ebp)
	movzbl	-67(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$16, %eax, %edx
	sall	$16, %eax
	movl	-176(%ebp), %ebx
	movl	-172(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -184(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -180(%ebp)
	movzbl	-66(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$8, %eax, %edx
	sall	$8, %eax
	movl	-184(%ebp), %ebx
	movl	-180(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -192(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -188(%ebp)
	movzbl	-65(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	-192(%ebp), %ebx
	movl	-188(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -48(%ebp)
	movl	%esi, %ebx
	orl	%edx, %ebx
	movl	%ebx, %eax
	movl	%eax, -44(%ebp)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, %ecx
	xorl	-48(%ebp), %ecx
	movl	%ecx, -56(%ebp)
	movl	%edx, %eax
	xorl	-44(%ebp), %eax
	movl	%eax, -52(%ebp)
	movl	$0, -16(%ebp)
L60:
	movl	-16(%ebp), %eax
	cmpl	-24(%ebp), %eax
	jnb	L59
	movl	-20(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	-16(%ebp), %eax
	addl	%eax, %edx
	movl	12(%ebp), %eax
	leal	(%edx,%eax), %ebx
	movl	-16(%ebp), %edx
	movl	$0, %eax
	subl	%edx, %eax
	sall	$3, %eax
	leal	56(%eax), %ecx
	movl	-56(%ebp), %eax
	movl	-52(%ebp), %edx
	shrdl	%cl, %edx, %eax
	shrl	%cl, %edx
	testb	$32, %cl
	je	L61
	movl	%edx, %eax
	xorl	%edx, %edx
L61:
	movb	%al, (%ebx)
	addl	$1, -16(%ebp)
	jmp	L60
L59:
	movl	$8, 8(%esp)
	movl	$0, 4(%esp)
	leal	-80(%ebp), %eax
	movl	%eax, (%esp)
	call	_memset
	movl	20(%ebp), %eax
	subl	-24(%ebp), %eax
	movl	%eax, %edx
	movl	12(%ebp), %eax
	addl	%eax, %edx
	movl	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-80(%ebp), %eax
	movl	%eax, (%esp)
	call	_memcpy
	leal	-80(%ebp), %edx
	movl	-24(%ebp), %eax
	addl	%edx, %eax
	movb	$-128, (%eax)
	movzbl	-80(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$24, %edx
	movl	%eax, %ecx
	movl	%edx, %ebx
	movzbl	-79(%ebp), %eax
	movb	%al, -96(%ebp)
	movzbl	-96(%ebp), %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$16, %edx
	movl	%ecx, %esi
	orl	%eax, %esi
	movl	%esi, -200(%ebp)
	orl	%edx, %ebx
	movl	%ebx, -196(%ebp)
	movzbl	-78(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$8, %edx
	movl	-200(%ebp), %ebx
	movl	-196(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -208(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -204(%ebp)
	movzbl	-77(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	movl	-208(%ebp), %ebx
	movl	-204(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -216(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -212(%ebp)
	movzbl	-76(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$24, %eax, %edx
	sall	$24, %eax
	movl	-216(%ebp), %ebx
	movl	-212(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -224(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -220(%ebp)
	movzbl	-75(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$16, %eax, %edx
	sall	$16, %eax
	movl	-224(%ebp), %ebx
	movl	-220(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -232(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -228(%ebp)
	movzbl	-74(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$8, %eax, %edx
	sall	$8, %eax
	movl	-232(%ebp), %ebx
	movl	-228(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -240(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -236(%ebp)
	movzbl	-73(%ebp), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	-240(%ebp), %ebx
	movl	-236(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -64(%ebp)
	orl	%edx, %esi
	movl	%esi, %eax
	movl	%eax, -60(%ebp)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, %ebx
	xorl	-64(%ebp), %ebx
	movl	%ebx, -248(%ebp)
	movl	%edx, %eax
	xorl	-60(%ebp), %eax
	movl	%eax, -244(%ebp)
	movl	8(%ebp), %eax
	movl	-248(%ebp), %ebx
	movl	-244(%ebp), %esi
	movl	%ebx, (%eax)
	movl	%esi, 4(%eax)
	nop
	addl	$256, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE36:
	.section .rdata,"dr"
LC9:
	.ascii "demo.cpp\0"
LC10:
	.ascii "key != NULL\0"
	.text
	.globl	__Z14ascon_finalizePyPKhPh
	.def	__Z14ascon_finalizePyPKhPh;	.scl	2;	.type	32;	.endef
__Z14ascon_finalizePyPKhPh:
LFB37:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%esi
	pushl	%ebx
	subl	$176, %esp
	.cfi_offset 6, -12
	.cfi_offset 3, -16
	cmpl	$0, 12(%ebp)
	jne	L63
	movl	$358, 8(%esp)
	movl	$LC9, 4(%esp)
	movl	$LC10, (%esp)
	call	__assert
L63:
	movl	12(%ebp), %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$24, %edx
	movl	%eax, %ebx
	movl	%edx, %esi
	movl	12(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$16, %edx
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -48(%ebp)
	orl	%edx, %esi
	movl	%esi, -44(%ebp)
	movl	12(%ebp), %eax
	addl	$2, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$8, %edx
	movl	-48(%ebp), %ebx
	movl	-44(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -56(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -52(%ebp)
	movl	12(%ebp), %eax
	addl	$3, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	movl	-56(%ebp), %ebx
	movl	-52(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -64(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -60(%ebp)
	movl	12(%ebp), %eax
	addl	$4, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$24, %eax, %edx
	sall	$24, %eax
	movl	-64(%ebp), %ebx
	movl	-60(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -72(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -68(%ebp)
	movl	12(%ebp), %eax
	addl	$5, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$16, %eax, %edx
	sall	$16, %eax
	movl	-72(%ebp), %ebx
	movl	-68(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -80(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -76(%ebp)
	movl	12(%ebp), %eax
	addl	$6, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$8, %eax, %edx
	sall	$8, %eax
	movl	-80(%ebp), %ebx
	movl	-76(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -88(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -84(%ebp)
	movl	12(%ebp), %eax
	addl	$7, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	-88(%ebp), %ebx
	movl	-84(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -24(%ebp)
	orl	%edx, %esi
	movl	%esi, %eax
	movl	%eax, -20(%ebp)
	movl	12(%ebp), %eax
	addl	$8, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$24, %edx
	movl	%eax, %ebx
	movl	%edx, %esi
	movl	12(%ebp), %eax
	addl	$9, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$16, %edx
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -96(%ebp)
	orl	%edx, %esi
	movl	%esi, -92(%ebp)
	movl	12(%ebp), %eax
	addl	$10, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	sall	$8, %edx
	movl	-96(%ebp), %ebx
	movl	-92(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -104(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -100(%ebp)
	movl	12(%ebp), %eax
	addl	$11, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	%eax, %edx
	movl	$0, %eax
	movl	-104(%ebp), %ebx
	movl	-100(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -112(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -108(%ebp)
	movl	12(%ebp), %eax
	addl	$12, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$24, %eax, %edx
	sall	$24, %eax
	movl	-112(%ebp), %ebx
	movl	-108(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -120(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -116(%ebp)
	movl	12(%ebp), %eax
	addl	$13, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$16, %eax, %edx
	sall	$16, %eax
	movl	-120(%ebp), %ebx
	movl	-116(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -128(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -124(%ebp)
	movl	12(%ebp), %eax
	addl	$14, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	shldl	$8, %eax, %edx
	sall	$8, %eax
	movl	-128(%ebp), %ebx
	movl	-124(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -136(%ebp)
	movl	%edx, %eax
	orl	%esi, %eax
	movl	%eax, -132(%ebp)
	movl	12(%ebp), %eax
	addl	$15, %eax
	movzbl	(%eax), %ecx
	movzbl	%cl, %eax
	movl	$0, %edx
	movl	-136(%ebp), %ebx
	movl	-132(%ebp), %esi
	movl	%ebx, %ecx
	orl	%eax, %ecx
	movl	%ecx, -32(%ebp)
	orl	%edx, %esi
	movl	%esi, %eax
	movl	%eax, -28(%ebp)
	movl	8(%ebp), %eax
	leal	8(%eax), %ecx
	movl	8(%ebp), %eax
	addl	$8, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, %ebx
	xorl	-24(%ebp), %ebx
	movl	%ebx, -144(%ebp)
	movl	%edx, %eax
	xorl	-20(%ebp), %eax
	movl	%eax, -140(%ebp)
	movl	-144(%ebp), %eax
	movl	-140(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	movl	8(%ebp), %eax
	leal	16(%eax), %ecx
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, %esi
	xorl	-32(%ebp), %esi
	movl	%esi, -152(%ebp)
	movl	%edx, %eax
	xorl	-28(%ebp), %eax
	movl	%eax, -148(%ebp)
	movl	-152(%ebp), %eax
	movl	-148(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	movl	$12, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	__Z17ascon_permutationPyi
	movl	8(%ebp), %eax
	leal	24(%eax), %ecx
	movl	8(%ebp), %eax
	addl	$24, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, %ebx
	xorl	-24(%ebp), %ebx
	movl	%ebx, -160(%ebp)
	movl	%edx, %eax
	xorl	-20(%ebp), %eax
	movl	%eax, -156(%ebp)
	movl	-160(%ebp), %eax
	movl	-156(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	movl	8(%ebp), %eax
	leal	32(%eax), %ecx
	movl	8(%ebp), %eax
	addl	$32, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, %esi
	xorl	-32(%ebp), %esi
	movl	%esi, -168(%ebp)
	movl	%edx, %eax
	xorl	-28(%ebp), %eax
	movl	%eax, -164(%ebp)
	movl	-168(%ebp), %eax
	movl	-164(%ebp), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	movl	$0, -12(%ebp)
L65:
	cmpl	$7, -12(%ebp)
	jg	L66
	movl	-12(%ebp), %edx
	movl	16(%ebp), %eax
	leal	(%edx,%eax), %ebx
	movl	8(%ebp), %eax
	addl	$24, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	$7, %ecx
	subl	-12(%ebp), %ecx
	sall	$3, %ecx
	shrdl	%cl, %edx, %eax
	shrl	%cl, %edx
	testb	$32, %cl
	je	L67
	movl	%edx, %eax
	xorl	%edx, %edx
L67:
	movb	%al, (%ebx)
	movl	-12(%ebp), %eax
	leal	8(%eax), %edx
	movl	16(%ebp), %eax
	leal	(%edx,%eax), %ebx
	movl	8(%ebp), %eax
	addl	$32, %eax
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	$7, %ecx
	subl	-12(%ebp), %ecx
	sall	$3, %ecx
	shrdl	%cl, %edx, %eax
	shrl	%cl, %edx
	testb	$32, %cl
	je	L68
	movl	%edx, %eax
	xorl	%edx, %edx
L68:
	movb	%al, (%ebx)
	addl	$1, -12(%ebp)
	jmp	L65
L66:
	nop
	addl	$176, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE37:
	.def	___main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
LC11:
	.ascii "key\0"
LC12:
	.ascii "nonce\0"
LC13:
	.ascii "plaintext\0"
LC14:
	.ascii "Decryption successful\0"
LC15:
	.ascii "Decryption failed\0"
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
LFB38:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$160, %esp
	call	___main
	movb	$1, 140(%esp)
	movb	$2, 141(%esp)
	movb	$3, 142(%esp)
	movb	$4, 143(%esp)
	movb	$5, 144(%esp)
	movb	$6, 145(%esp)
	movb	$7, 146(%esp)
	movb	$8, 147(%esp)
	movb	$9, 148(%esp)
	movb	$0, 149(%esp)
	movb	$1, 150(%esp)
	movb	$2, 151(%esp)
	movb	$3, 152(%esp)
	movb	$4, 153(%esp)
	movb	$5, 154(%esp)
	movb	$6, 155(%esp)
	movb	$1, 124(%esp)
	movb	$2, 125(%esp)
	movb	$3, 126(%esp)
	movb	$4, 127(%esp)
	movb	$5, 128(%esp)
	movb	$6, 129(%esp)
	movb	$7, 130(%esp)
	movb	$8, 131(%esp)
	movb	$9, 132(%esp)
	movb	$0, 133(%esp)
	movb	$1, 134(%esp)
	movb	$2, 135(%esp)
	movb	$3, 136(%esp)
	movb	$4, 137(%esp)
	movb	$5, 138(%esp)
	movb	$6, 139(%esp)
	movl	$1329812289, 100(%esp)
	movl	$858927438, 104(%esp)
	movl	$926299444, 108(%esp)
	movl	$842086712, 112(%esp)
	movl	$909456435, 116(%esp)
	movl	$3749943, 120(%esp)
	movl	$1819043144, 89(%esp)
	movl	$1210068079, 93(%esp)
	movw	$31093, 97(%esp)
	movb	$0, 99(%esp)
	movl	$16, 8(%esp)
	leal	140(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$LC11, (%esp)
	call	__Z9print_hexPKcPKhj
	movl	$16, 8(%esp)
	leal	124(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$LC12, (%esp)
	call	__Z9print_hexPKcPKhj
	movl	$11, 8(%esp)
	leal	89(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$LC13, (%esp)
	call	__Z9print_hexPKcPKhj
	leal	46(%esp), %eax
	movl	%eax, 28(%esp)
	leal	62(%esp), %eax
	movl	%eax, 24(%esp)
	movl	$11, 20(%esp)
	leal	89(%esp), %eax
	movl	%eax, 16(%esp)
	movl	$24, 12(%esp)
	leal	100(%esp), %eax
	movl	%eax, 8(%esp)
	leal	124(%esp), %eax
	movl	%eax, 4(%esp)
	leal	140(%esp), %eax
	movl	%eax, (%esp)
	call	__Z13ascon_encryptPKhS0_S0_jS0_jPhS1_
	leal	35(%esp), %eax
	movl	%eax, 28(%esp)
	leal	46(%esp), %eax
	movl	%eax, 24(%esp)
	movl	$11, 20(%esp)
	leal	62(%esp), %eax
	movl	%eax, 16(%esp)
	movl	$24, 12(%esp)
	leal	100(%esp), %eax
	movl	%eax, 8(%esp)
	leal	124(%esp), %eax
	movl	%eax, 4(%esp)
	leal	140(%esp), %eax
	movl	%eax, (%esp)
	call	__Z13ascon_decryptPKhS0_S0_jS0_jS0_Ph
	movl	%eax, 156(%esp)
	cmpl	$0, 156(%esp)
	jne	L70
	movl	$LC14, (%esp)
	call	_puts
	jmp	L71
L70:
	movl	$LC15, (%esp)
	call	_puts
L71:
	movl	$0, %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE38:
	.ident	"GCC: (MinGW.org GCC-6.3.0-1) 6.3.0"
	.def	_printf;	.scl	2;	.type	32;	.endef
	.def	_putchar;	.scl	2;	.type	32;	.endef
	.def	_memcmp;	.scl	2;	.type	32;	.endef
	.def	_memcpy;	.scl	2;	.type	32;	.endef
	.def	_memset;	.scl	2;	.type	32;	.endef
	.def	__assert;	.scl	2;	.type	32;	.endef
	.def	_puts;	.scl	2;	.type	32;	.endef
