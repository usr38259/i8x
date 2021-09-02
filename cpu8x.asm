
.386
.model flat

;USEFETCHOP	equ -1
;NOI8080	equ -1
;NOI8085	equ -1
;I386ONLY	equ -1
;MEMSUB		equ -1
EXACTF		equ -1
USEWRLOG	equ -1
COUNTERS	equ -1

I80	struct
	regBC	dw ?
	regDE	dw ?
	regHL	dw ?
	regSP	dw ?
	regPSW	dw ?
	regPC	dw ?
	regINTE	db ?
	imode	db ?
	flag	db ?
	mpoke	db ?
	mem	dd ?
	iexe	dd ?
	mrlow	dw ?
	mrhigh	dw ?
	mwlow	dw ?
	mwhigh	dw ?
	peekb	dd ?
	peekw	dd ?
	pokeb	dd ?
	pokew	dd ?
	inb	dd ?
	outb	dd ?
IFDEF	USEFETCHOP
	fetchop	dd ?
ENDIF
IFDEF	USEWRLOG
	pokeaddr dw ?
	pokeval	dw ?
ENDIF
IFDEF	COUNTERS
	itck	dd ?
	icount	dd ?
	ibytes	dd ?
ENDIF
I80	ends

I80r	struct
	regC	db ?
	regB	db ?
	regE	db ?
	regD	db ?
	regL	db ?
	regH	db ?
	regSPL	db ?
	regSPH	db ?
	regA	db ?
	regF	db ?
I80r	ends

.const

IFNDEF	NOI8080
_i80ilen label byte
	db 1, 3, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1
	db 1, 3, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1
	db 1, 3, 3, 1, 1, 1, 2, 1, 1, 1, 3, 1, 1, 1, 2, 1
	db 1, 3, 3, 1, 1, 1, 2, 1, 1, 1, 3, 1, 1, 1, 2, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 3, 3, 3, 1, 2, 1, 1, 1, 3, 1, 3, 3, 2, 1
	db 1, 1, 3, 2, 3, 1, 2, 1, 1, 1, 3, 2, 3, 1, 2, 1
	db 1, 1, 3, 1, 3, 1, 2, 1, 1, 1, 3, 1, 3, 1, 2, 1
	db 1, 1, 3, 1, 3, 1, 2, 1, 1, 1, 3, 1, 3, 1, 2, 1
_i80itck label byte
	db  4, 10,  7,  5,  5,  5,  7,  4,  4, 10,  7,  5,  5,  5,  7, 4
	db  4, 10,  7,  5,  5,  5,  7,  4,  4, 10,  7,  5,  5,  5,  7, 4
	db  4, 10, 16,  5,  5,  5,  7,  4,  4, 10, 16,  5,  5,  5,  7, 4
	db  4, 10, 13,  5, 10, 10, 10,  4,  4, 10, 13,  5,  5,  5,  7, 4
	db  5,  5,  5,  5,  5,  5,  7,  5,  5,  5,  5,  5,  5,  5,  7, 5
	db  5,  5,  5,  5,  5,  5,  7,  5,  5,  5,  5,  5,  5,  5,  7, 5
	db  5,  5,  5,  5,  5,  5,  7,  5,  5,  5,  5,  5,  5,  5,  7, 5
	db  7,  7,  7,  7,  7,  7,  7,  7,  5,  5,  5,  5,  5,  5,  7, 5
	db  4,  4,  4,  4,  4,  4,  7,  4,  4,  4,  4,  4,  4,  4,  7, 4
	db  4,  4,  4,  4,  4,  4,  7,  4,  4,  4,  4,  4,  4,  4,  7, 4
	db  4,  4,  4,  4,  4,  4,  7,  4,  4,  4,  4,  4,  4,  4,  7, 4
	db  4,  4,  4,  4,  4,  4,  7,  4,  4,  4,  4,  4,  4,  4,  7, 4
	db  5, 10, 10, 10, 11, 11,  7, 11,  5, 10, 10, 10, 11, 17,  7, 11
	db  5, 10, 10, 10, 11, 11,  7, 11,  5, 10, 10, 10, 11, 17,  7, 11
	db  5, 10, 10, 18, 11, 11,  7, 11,  5,  5, 10,  4, 11, 17,  7, 11
	db  5, 10, 10,  4, 11, 11,  7, 11,  5,  5, 10,  4, 11, 17,  7, 11
_i80idef	label near ptr dword
	dd	inop,	ilxi,	istax,	iinx,	iinr,	idcr,	imvi,	irlc
	dd	i?nop,	idad,	ildax,	idcx,	iinr,	idcr,	imvi,	irrc
	dd	i?nop,	ilxi,	istax,	iinx,	iinr,	idcr,	imvi,	iral
	dd	i?nop,	idad,	ildax,	idcx,	iinr,	idcr,	imvi,	irar
	dd	i?nop,	ilxi,	ishld,	iinx,	iinr,	idcr,	imvi,	idaa
	dd	i?nop,	idad,	ilhld,	idcx,	iinr,	idcr,	imvi,	icma
	dd	i?nop,	ilxi,	ista,	iinx,	iinrm,	idcrm,	imvim,	istc
	dd	i?nop,	idad,	ilda,	idcx,	iinra,	idcra,	imvia,	icmc
	dd	imov??,	imov,	imov,	imov,	imov,	imov,	imovrm,	imova
	dd	imov,	imov??,	imov,	imov,	imov,	imov,	imovrm,	imova
	dd	imov,	imov,	imov??,	imov,	imov,	imov,	imovrm,	imova
	dd	imov,	imov,	imov,	imov??,	imov,	imov,	imovrm,	imova
	dd	imov,	imov,	imov,	imov,	imov??,	imov,	imovrm,	imova
	dd	imov,	imov,	imov,	imov,	imov,	imov??,	imovrm,	imova
	dd	imovmr,	imovmr,	imovmr,	imovmr,	imovmr,	imovmr,	ihlt,	imovma
	dd	imov,	imov,	imov,	imov,	imov,	imov,	imovrm,	imov??
	dd	iadd,	iadd,	iadd,	iadd,	iadd,	iadd,	iaddm,	iadda
	dd	iadc,	iadc,	iadc,	iadc,	iadc,	iadc,	iadcm,	iadca
	dd	isub,	isub,	isub,	isub,	isub,	isub,	isubm,	isuba
	dd	isbb,	isbb,	isbb,	isbb,	isbb,	isbb,	isbbm,	isbba
	dd	iana,	iana,	iana,	iana,	iana,	iana,	ianam,	ianaa
	dd	ixra,	ixra,	ixra,	ixra,	ixra,	ixra,	ixram,	ixraa
	dd	iora,	iora,	iora,	iora,	iora,	iora,	ioram,	ioraa
	dd	icmp,	icmp,	icmp,	icmp,	icmp,	icmp,	icmpm,	icmpa
	dd	ircc,	ipop,	ijcc,	ijmp,	iccc,	ipush,	iadi,	irst
	dd	ircc,	iiret,	ijcc,	i?jmp,	iccc,	icall,	iaci,	irst
	dd	ircc,	ipop,	ijcc,	iout,	iccc,	ipush,	isui,	irst
	dd	ircc,	i?ret,	ijcc,	iin,	iccc,	i?call,	isbi,	irst
	dd	ircc,	ipop,	ijcc,	ixthl,	iccc,	ipush,	iani,	irst
	dd	ircc,	ipchl,	ijcc,	ixchg,	iccc,	i?call,	ixri,	irst
	dd	ircc,	ipop,	ijcc,	idi,	iccc,	ippsw,	iori,	irst
	dd	ircc,	isphl,	ijcc,	iei,	iccc,	i?call,	icpi,	irst
ENDIF
IFNDEF	NOI8085
_i85ilen label byte
	db 1, 3, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1
	db 1, 3, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1
	db 1, 3, 3, 1, 1, 1, 2, 1, 2, 1, 3, 1, 1, 1, 2, 1
	db 1, 3, 3, 1, 1, 1, 2, 1, 2, 1, 3, 1, 1, 1, 2, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	db 1, 1, 3, 3, 3, 1, 2, 1, 1, 1, 3, 1, 3, 3, 2, 1
	db 1, 1, 3, 2, 3, 1, 2, 1, 1, 1, 3, 2, 3, 1, 2, 1
	db 1, 1, 3, 1, 3, 1, 2, 1, 1, 1, 3, 1, 3, 1, 2, 1
	db 1, 1, 3, 1, 3, 1, 2, 1, 1, 1, 3, 1, 3, 1, 2, 1
_i85itck label byte
	db  4, 10,  7,  6,  4,  4,  7,  4, 10, 10,  7,  6,  4,  4,  7, 4
	db  7, 10,  7,  6,  4,  4,  7,  4, 10, 10,  7,  6,  4,  4,  7, 4
	db  4, 10, 16,  6,  4,  4,  7,  4, 10, 10, 16,  6,  4,  4,  7, 4
	db  4, 10, 13,  6, 10, 10, 10,  4, 10, 10, 13,  6,  4,  4,  7, 4
	db  4,  4,  4,  4,  4,  4,  7,  4,  4,  4,  4,  4,  4,  4,  7, 4
	db  4,  4,  4,  4,  4,  4,  7,  4,  4,  4,  4,  4,  4,  4,  7, 4
	db  4,  4,  4,  4,  4,  4,  7,  4,  4,  4,  4,  4,  4,  4,  7, 4
	db  7,  7,  7,  7,  7,  7,  5,  7,  4,  4,  4,  4,  4,  4,  7, 4
	db  4,  4,  4,  4,  4,  4,  7,  4,  4,  4,  4,  4,  4,  4,  7, 4
	db  4,  4,  4,  4,  4,  4,  7,  4,  4,  4,  4,  4,  4,  4,  7, 4
	db  4,  4,  4,  4,  4,  4,  7,  4,  4,  4,  4,  4,  4,  4,  7, 4
	db  4,  4,  4,  4,  4,  4,  7,  4,  4,  4,  4,  4,  4,  4,  7, 4
	db  6, 10,  7, 10,  9, 12,  7, 12,  6, 10,  7,  6,  9, 18,  7, 12
	db  6, 10,  7, 10,  9, 12,  7, 12,  6, 10,  7, 10,  9,  7,  7, 12
	db  6, 10,  7, 16,  9, 12,  7, 12,  6,  6,  7,  4,  9, 10,  7, 12
	db  6, 10,  7,  4,  9, 12,  7, 12,  6,  6,  7,  4,  9,  7,  7, 12
_i85idef	label near ptr dword
	dd	inop,	ilxi,	istax,	iinx85,	iinr,	idcr,	imvi,	irlc
	dd	idsub,	idad,	ildax,	idcx85,	iinr,	idcr,	imvi,	irrc
	dd	iarsh,	ilxi,	istax,	iinx85,	iinr,	idcr,	imvi,	iral
	dd	irlde,	idad,	ildax,	idcx85,	iinr,	idcr,	imvi,	irar
	dd	irim,	ilxi,	ishld,	iinx85,	iinr,	idcr,	imvi,	idaa
	dd	ildeh,	idad,	ilhld,	idcx85,	iinr,	idcr,	imvi,	icma
	dd	isim,	ilxi,	ista,	iinx85,	iinrm,	idcrm,	imvim,	istc
	dd	ildes,	idad,	ilda,	idcx85,	iinra,	idcra,	imvia,	icmc
	dd	imov??,	imov,	imov,	imov,	imov,	imov,	imovrm,	imova
	dd	imov,	imov??,	imov,	imov,	imov,	imov,	imovrm,	imova
	dd	imov,	imov,	imov??,	imov,	imov,	imov,	imovrm,	imova
	dd	imov,	imov,	imov,	imov??,	imov,	imov,	imovrm,	imova
	dd	imov,	imov,	imov,	imov,	imov??,	imov,	imovrm,	imova
	dd	imov,	imov,	imov,	imov,	imov,	imov??,	imovrm,	imova
	dd	imovmr,	imovmr,	imovmr,	imovmr,	imovmr,	imovmr,	ihlt,	imovma
	dd	imov,	imov,	imov,	imov,	imov,	imov,	imovrm,	imov??
	dd	iadd,	iadd,	iadd,	iadd,	iadd,	iadd,	iaddm,	iadda
	dd	iadc,	iadc,	iadc,	iadc,	iadc,	iadc,	iadcm,	iadca
	dd	isub,	isub,	isub,	isub,	isub,	isub,	isubm,	isuba
	dd	isbb,	isbb,	isbb,	isbb,	isbb,	isbb,	isbbm,	isbba
	dd	iana,	iana,	iana,	iana,	iana,	iana,	ianam,	ianaa
	dd	ixra,	ixra,	ixra,	ixra,	ixra,	ixra,	ixram,	ixraa
	dd	iora,	iora,	iora,	iora,	iora,	iora,	ioram,	ioraa
	dd	icmp,	icmp,	icmp,	icmp,	icmp,	icmp,	icmpm,	icmpa
	dd	ircc,	ipop,	ijcc,	ijmp,	iccc,	ipush,	iadi,	irst
	dd	ircc,	iiret,	ijcc,	irstv,	iccc,	icall,	iaci,	irst
	dd	ircc,	ipop,	ijcc,	iout,	iccc,	ipush,	isui,	irst
	dd	ircc,	ishlx,	ijcc,	iin,	iccc,	ijccx,	isbi,	irst
	dd	ircc,	ipop,	ijcc,	ixthl,	iccc,	ipush,	iani,	irst
	dd	ircc,	ipchl,	ijcc,	ixchg,	iccc,	ilhlx,	ixri,	irst
	dd	ircc,	ipop,	ijcc,	idi,	iccc,	ippsw,	iori,	irst
	dd	ircc,	isphl,	ijcc,	iei,	iccc,	ijccx,	icpi,	irst
ENDIF
IFDEF	NOI8080
IFDEF	NOI8085
.ERR	<NOI8080 and NOI8085 simultaneously>
ENDIF
ENDIF

.code

IFNDEF	NOI8080
IFNDEF	FASTEXECALL
_i80Execute@4	proc near
ELSE
@i80Execute@4	proc near
ENDIF
	push	ebx
IFNDEF	FASTEXECALL
	mov	ebx, dword ptr [esp+8]
ELSE
	mov	ebx, ecx
ENDIF
	movzx	edx, [ebx].I80.regPC
IFDEF	USEFETCHOP
	cmp	[ebx].I80.fetchop, 0
	jz	short nofetchop
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ENDIF
	call	[ecx].I80.fetchop
	test	eax, eax
	js	short rete
	movzx	eax, al
	movzx	edx, dx
	jmp	short peekok
nofetchop:
ENDIF
	cmp	dx, [ebx].I80.mrlow
	jb	short memrngf
	cmp	dx, [ebx].I80.mrhigh
	jnbe	short memrngf
	mov	ecx, [ebx].I80.mem
	movzx	eax, byte ptr [ecx][edx]
	movzx	edx, word ptr [ecx][edx+1]	; MRPROT
peekok:
IFDEF	COUNTERS
	movzx	ecx, byte ptr _i80ilen [eax]
	add	[ebx].I80.ibytes, ecx
	add	word ptr [ebx].I80.regPC, cx
	movzx	ecx, byte ptr _i80itck [eax]
	inc	[ebx].I80.icount
	add	[ebx].I80.itck, ecx
ENDIF
	push	eax
	mov	ecx, [ebx].I80.iexe
IFDEF	USEWRLOG
	mov	[ebx].I80.mpoke, 0
ENDIF
	call	dword ptr [ecx][eax * 4]
	add	esp, 4
IFDEF	COUNTERS
	test	eax, eax
	js	short ierr
ENDIF
rete:
	pop	ebx
IFNDEF	FASTEXECALL
	ret	4
ELSE
	ret
ENDIF
memrngf:
	push	edx
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	dword ptr [ebx].I80.peekb
	pop	edx
	test	eax, eax
	js	short rete
	movzx	eax, al
	inc	edx
	cmp	byte ptr _i80ilen[eax], 1
	push	eax
	ja	short peek2
	jb	short peekok
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	dword ptr [ebx].I80.peekb
	test	eax, eax
	mov	edx, eax
	js	short rete
	pop	eax
	jmp	short peekok
peek2:
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	dword ptr [ebx].I80.peekw
	test	eax, eax
	mov	edx, eax
	js	short rete
	pop	eax
	jmp	short peekok
IFDEF	COUNTERS
ierr:	mov	ecx, dword ptr [esp-4]
	movzx	edx, byte ptr _i80ilen [ecx]
	sub	[ebx].I80.ibytes, edx
	sub	word ptr [ebx].I80.regPC, dx
	movzx	edx, byte ptr _i80itck [ecx]
	dec	[ebx].I80.icount
	sub	[ebx].I80.itck, edx
	jmp	short rete
ENDIF
IFNDEF	FASTEXECALL
_i80Execute@4	endp
ELSE
@i80Execute@4	endp
ENDIF
ENDIF

IFNDEF	NOI8085
IFNDEF	FASTEXECALL
_i85Execute@4	proc near
ELSE
@i85Execute@4	proc near
ENDIF
	push	ebx
IFNDEF	FASTEXECALL
	mov	ebx, dword ptr [esp+8]
ELSE
	mov	ebx, ecx
ENDIF
	movzx	edx, [ebx].I80.regPC
IFDEF	USEFETCHOP
	cmp	[ebx].I80.fetchop, 0
	jz	short nofetchop
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ENDIF
	call	[ecx].I80.fetchop
	test	eax, eax
	js	short rete
	movzx	eax, al
	movzx	edx, dx
	jmp	short peekok
nofetchop:
ENDIF
	cmp	dx, [ebx].I80.mrlow
	jb	short memrngf
	cmp	dx, [ebx].I80.mrhigh
	jnbe	short memrngf
	mov	ecx, [ebx].I80.mem
	movzx	eax, byte ptr [ecx][edx]
	movzx	edx, word ptr [ecx][edx+1]	; MRPROT
peekok:
IFDEF	COUNTERS
	movzx	ecx, byte ptr _i85ilen [eax]
	add	[ebx].I80.ibytes, ecx
	add	word ptr [ebx].I80.regPC, cx
	movzx	ecx, byte ptr _i85itck [eax]
	inc	[ebx].I80.icount
	add	[ebx].I80.itck, ecx
ENDIF
	push	eax
	mov	ecx, [ebx].I80.iexe
IFDEF	USEWRLOG
	mov	[ebx].I80.mpoke, 0
ENDIF
	call	dword ptr [ecx][eax * 4]
	add	esp, 4
IFDEF	COUNTERS
	test	eax, eax
	js	short ierr
ENDIF
rete:
	pop	ebx
IFNDEF	FASTEXECALL
	ret	4
ELSE
	ret
ENDIF
memrngf:
	push	edx
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	dword ptr [ebx].I80.peekb
	pop	edx
	test	eax, eax
	js	short rete
	movzx	eax, al
	inc	edx
	cmp	byte ptr _i85ilen[eax], 1
	push	eax
	ja	short peek2
	jb	short peekok
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	dword ptr [ebx].I80.peekb
	test	eax, eax
	mov	edx, eax
	js	short rete
	pop	eax
	jmp	short peekok
peek2:
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	dword ptr [ebx].I80.peekw
	test	eax, eax
	mov	edx, eax
	js	short rete
	pop	eax
	jmp	short peekok
IFDEF	COUNTERS
ierr:	mov	ecx, dword ptr [esp-4]
	movzx	edx, byte ptr _i85ilen [ecx]
	sub	[ebx].I80.ibytes, edx
	sub	word ptr [ebx].I80.regPC, dx
	movzx	edx, byte ptr _i85itck [ecx]
	dec	[ebx].I80.icount
	sub	[ebx].I80.itck, edx
	jmp	short rete
ENDIF
IFNDEF	FASTEXECALL
_i85Execute@4	endp
ELSE
@i85Execute@4	endp
ENDIF
ENDIF

CF	equ 1 shl 0
PF	equ 1 shl 2
AF	equ 1 shl 4
ZF	equ 1 shl 6
SF	equ 1 shl 7
VF	equ 1 shl 1
X5F	equ 1 shl 5
X3F	equ 1 shl 3

CCCADDTCK	equ 6
RCCADDTCK	equ 6

JCC85ATCK	equ 3
CCC85ATCK	equ 9
RCC85ATCK	equ 6

IFNDEF	MEMSUB

peekbs	proc	near private
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	[ebx].I80.peekb
	test	eax, eax
	jns	short peekbsok
	add	esp, 4
peekbsok:
	ret
peekbs	endp

peekws	proc	near private
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	[ebx].I80.peekw
	test	eax, eax
	jns	short peekwsok
	add	esp, 4
peekwsok:
	ret
peekws	endp

pokebs	proc	near private
IFDEF	USEWRLOG
	mov	[ebx].I80.pokeaddr, dx
	mov	[ebx].I80.pokeval, ax
ENDIF
	push	eax
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	[ebx].I80.pokeb
	test	eax, eax
	jns	short pokebsok
	add	esp, 4
	ret
pokebsok:
IFDEF	USEWRLOG
	mov	[ebx].I80.mpoke, 1
ENDIF
	ret
pokebs	endp

pokews	proc	near private
IFDEF	USEWRLOG
	mov	[ebx].I80.pokeaddr, dx
	mov	[ebx].I80.pokeval, ax
ENDIF
	push	eax
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	[ebx].I80.pokew
	test	eax, eax
	jns	short pokewsok
	add	esp, 4
	ret
pokewsok:
IFDEF	USEWRLOG
	mov	[ebx].I80.mpoke, 2
ENDIF
	ret
pokews	endp

PEEKB	macro	reg
	local	meme, mrngok
IFNB	<reg>
	movzx	edx, [ebx].I80.reg
ENDIF
	cmp	dx, [ebx].I80.mrlow
	jb	short meme
	cmp	dx, [ebx].I80.mrhigh
	jbe	short mrngok
meme:	call	peekbs
	jmp	short @f
mrngok:	mov	eax, [ebx].I80.mem
	mov	al, byte ptr [eax][edx]
@@:
	endm

PEEKW	macro	reg
	local	meme, mrngok
IFNB	<reg>
	movzx	edx, [ebx].I80.reg
ENDIF
	movzx	eax, [ebx].I80.mrhigh
	cmp	dx, [ebx].I80.mrlow
	jb	short meme
	dec	eax
	cmp	dx, ax
	jbe	short mrngok
meme:	call	peekws
	jmp	short @f
mrngok:	mov	eax, [ebx].I80.mem
	mov	ax, word ptr [eax][edx]
@@:
	endm

POKEB	macro	reg, saveecx
	local	meme, mrngok
IFNB	<reg>
	movzx	edx, [ebx].I80.reg
ENDIF
	cmp	dx, [ebx].I80.mwlow
	jb	short meme
	cmp	dx, [ebx].I80.mwhigh
	jbe	short mrngok
meme:	call	pokebs
	jmp	short @f
mrngok:	mov	ecx, [ebx].I80.mem
	mov	byte ptr [ecx][edx], al
IFDEF	USEWRLOG
	mov	[ebx].I80.mpoke, 1
	movzx	eax, al
	mov	[ebx].I80.pokeaddr, dx
	mov	[ebx].I80.pokeval, ax
ENDIF
@@:
	endm

POKEW	macro	reg
	local	meme, mrngok
IFNB	<reg>
	movzx	edx, [ebx].I80.reg
ENDIF
	movzx	ecx, [ebx].I80.mwhigh
	cmp	dx, [ebx].I80.mwlow
	jb	short meme
	dec	ecx
	cmp	dx, cx
	jbe	short mrngok
meme:	call	peekws
	jmp	short @f
mrngok:	mov	ecx, [ebx].I80.mem
	mov	word ptr [ecx][edx], ax
IFDEF	USEWRLOG
	mov	[ebx].I80.mpoke, 2
	mov	[ebx].I80.pokeaddr, dx
	mov	[ebx].I80.pokeval, ax
ENDIF
@@:
	endm

ELSE

peekbs	proc	near private
	cmp	dx, [ebx].I80.mrlow
	jb	short meme
	cmp	dx, [ebx].I80.mrhigh
	jbe	short mrngok
meme:
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	[ebx].I80.peekb
	test	eax, eax
	jns	short peekbsok
	add	esp, 4
	ret
mrngok:	mov	eax, [ebx].I80.mem
	mov	al, byte ptr [eax][edx]
peekbsok:
	ret
peekbs	endp

peekws	proc	near private
	movzx	eax, [ebx].I80.mrhigh
	dec	eax
	cmp	dx, [ebx].I80.mrlow
	jb	short meme
	cmp	dx, ax
	jbe	short mrngok
meme:
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	[ebx].I80.peekw
	test	eax, eax
	jns	short peekwsok
	add	esp, 4
	ret
mrngok:	mov	eax, [ebx].I80.mem
	mov	ax, word ptr [eax][edx]
peekwsok:
	ret
peekws	endp

pokebs	proc	near private
IFDEF	USEWRLOG
	mov	[ebx].I80.pokeaddr, dx
	mov	[ebx].I80.pokeval, ax
ENDIF
	cmp	dx, [ebx].I80.mwlow
	jb	short meme
	cmp	dx, [ebx].I80.mwhigh
	jbe	short mrngok
meme:	push	eax
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	[ebx].I80.pokeb
	test	eax, eax
	jns	short pokebsok
	add	esp, 4
	ret
mrngok:	mov	ecx, [ebx].I80.mem
	mov	byte ptr [ecx][edx], al
pokebsok:
IFDEF	USEWRLOG
	mov	[ebx].I80.mpoke, 1
ENDIF
	ret
pokebs	endp

pokews	proc	near private
IFDEF	USEWRLOG
	mov	[ebx].I80.pokeaddr, dx
	mov	[ebx].I80.pokeval, ax
ENDIF
	movzx	ecx, [ebx].I80.mwhigh
	cmp	dx, [ebx].I80.mwlow
	jb	short meme
	dec	ecx
	cmp	dx, cx
	jbe	short mrngok
meme:	push	eax
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	[ebx].I80.pokew
	test	eax, eax
	jns	short pokewsok
	add	esp, 4
	ret
mrngok:	mov	ecx, [ebx].I80.mem
	mov	word ptr [ecx][edx], ax
pokewsok:
IFDEF	USEWRLOG
	mov	[ebx].I80.mpoke, 2
ENDIF
	ret
pokews	endp

PEEKB	macro	reg
IFNB	<reg>
	movzx	edx, [ebx].I80.reg
ENDIF
	call	peekbs
	endm

PEEKW	macro	reg
IFNB	<reg>
	movzx	edx, [ebx].I80.reg
ENDIF
	call	peekws
	endm

POKEB	macro	reg
IFNB	<reg>
	movzx	edx, [ebx].I80.reg
ENDIF
	call	pokebs
	endm

POKEW	macro	reg
IFNB	<reg>
	movzx	edx, [ebx].I80.reg
ENDIF
	call	pokews
	endm

ENDIF

IFNDEF	NOI8080
IFNDEF	NOI8085
I8XMIX	equ	-1
ENDIF
ENDIF

TSTZ85	macro
	test	[ebx].I80.regINTE, 2
	endm

ilxi:	shr	eax, 3
	and	eax, 110b
	mov	word ptr [ebx][eax], dx
	xor	eax, eax
	ret

istax:	shr	eax, 3
	movzx	edx, word ptr [ebx][eax]
	mov	al, byte ptr [ebx].I80r.regA
	POKEB
	xor	eax, eax
	ret

ildax:	shr	eax, 3
	and	eax, 110b
	movzx	edx, word ptr [ebx][eax]
	PEEKB
	mov	byte ptr [ebx].I80r.regA, al
	xor	eax, eax
	ret

iinx:	shr	eax, 3
	inc	word ptr [ebx][eax]
	xor	eax, eax
	ret

idcx:	shr	eax, 3
	and	eax, 110b
	dec	word ptr [ebx][eax]
	xor	eax, eax
	ret

iinr:	shr	eax, 3
	and	eax, 111b
	xor	eax, 1
	inc	byte ptr [ebx][eax]
iinr1:	mov	dh, [ebx].I80r.regF
	lahf
	and	dh, CF
IFDEF	I8XMIX
	and	ah, NOT CF
	TSTZ85
	jz	short @f
	and	ah, NOT VF
ELSE
IFDEF	NOI8085
	and	ah, NOT CF
ELSE
	and	ah, NOT (CF OR VF)
ENDIF
ENDIF
@@:	or	ah, dh
	mov	[ebx].I80r.regF, ah
	xor	eax, eax
	ret
iinra:	inc	byte ptr [ebx].I80r.regA
	jmp	short iinr1

iinrm:	PEEKB	regHL
	mov	dh, [ebx].I80r.regF
	inc	al
	lahf
	and	dh, CF
IFDEF	I8XMIX
	and	ah, NOT CF
	TSTZ85
	jz	short @f
	and	ah, NOT VF
ELSE
IFNDEF	NOI8080
	and	ah, NOT CF
ELSE
	and	ah, NOT (CF OR VF)
ENDIF
ENDIF
@@:	or	ah, dh
	mov	[ebx].I80r.regF, ah
	POKEB	regHL
	xor	eax, eax
	ret

idcr:	shr	eax, 3
	and	eax, 111b
	xor	eax, 1
	dec	byte ptr [ebx][eax]
@@:	mov	dh, [ebx].I80r.regF
	lahf
	and	ah, NOT CF
	and	dh, CF
	xor	ah, AF
	or	ah, dh
	mov	[ebx].I80r.regF, ah
	xor	eax, eax
	ret
idcra:	dec	byte ptr [ebx].I80r.regA
	jmp	short @b

idcrm:	PEEKB	regHL
	dec	al
	mov	dh, [ebx].I80r.regF
	lahf
	and	ah, NOT CF
	and	dh, CF
	xor	ah, AF
	or	ah, dh
	mov	[ebx].I80r.regF, ah
	POKEB	regHL
	xor	eax, eax
	ret

imvi:	shr	eax, 3
	and	eax, 111b
	xor	eax, 1
	mov	byte ptr [ebx][eax], dl
	xor	eax, eax
	ret

imvia:	mov	byte ptr [ebx].I80r.regA, dl
	xor	eax, eax
	ret

imvim:	mov	al, dl
	POKEB	regHL
	xor	eax, eax
	ret

idad:	shr	eax, 3
	and	eax, 110b
	mov	cx, [ebx][eax]
	mov	ah, [ebx].I80r.regF
	and	ah, NOT CF
	add	[ebx].I80.regHL, cx
	jnc	short @f
	or	ah, CF
@@:	mov	[ebx].I80r.regF, ah
	xor	eax, eax
	ret

IFNDEF	NOI8080
i?nop:	mov	word ptr [ebx].I80.flag, 1
ENDIF
inop:	xor	eax, eax
	ret

irlc:	mov	ah, [ebx].I80r.regF
	and	ah, NOT CF
	rol	[ebx].I80r.regA, 1
	jnc	short @f
	or	ah, CF
@@:	mov	[ebx].I80r.regF, ah
	xor	eax, eax
	ret

irrc:	mov	ah, [ebx].I80r.regF
	and	ah, NOT CF
	ror	[ebx].I80r.regA, 1
	jnc	short @f
	or	ah, CF
@@:	mov	[ebx].I80r.regF, ah
	xor	eax, eax
	ret

IFDEF	I386ONLY
iral:	mov	ah, [ebx].I80r.regF
	mov	ch, ah
	and	ah, NOT CF
	shr	ch, 1
ELSE
iral:	mov	eax, dword ptr [ebx].I80.regPSW
	btr	eax, 8
ENDIF
	rcl	[ebx].I80r.regA, 1
	jnc	short @f
	or	ah, CF
@@:	mov	[ebx].I80r.regF, ah
	xor	eax, eax
	ret

IFDEF	I386ONLY
irar:	mov	ah, [ebx].I80r.regF
	mov	ch, ah
	and	ah, NOT CF
	shr	ch, 1
ELSE
irar:	mov	eax, dword ptr [ebx].I80.regPSW
	btr	eax, 8
ENDIF
	rcr	[ebx].I80r.regA, 1
	jnc	short @f
	or	ah, CF
@@:	mov	[ebx].I80r.regF, ah
	xor	eax, eax
	ret

ishld:	mov	ax, [ebx].I80.regHL
	POKEW
	xor	eax, eax
	ret

ilhld:	PEEKW
	mov	[ebx].I80.regHL, ax
	xor	eax, eax
	ret

ista:	mov	al, [ebx].I80r.regA
	POKEB
	xor	eax, eax
	ret

ilda:	PEEKB
	mov	[ebx].I80r.regA, al
	xor	eax, eax
	ret

idaa:	mov	ax, [ebx].I80.regPSW
IFDEF	I8XMIX
	TSTZ85
	jz	short idaa1
ENDIF
IFNDEF	NOI8085
	test	eax, VF
	jz	short idaa1
IFDEF	EXACTF
	mov	cl, al
ENDIF
	xor	ah, AF
	sahf
	das
	jmp	short idaa2
ENDIF
IFDEF	EXACTF
idaa1:	mov	cl, al
	sahf
	daa
idaa2:	lahf
	mov	edx, eax
	sub	dl, cl
	add	cl, dl
	lahf
	and	dh, CF OR PF
	and	ah, NOT (CF OR PF)
	or	ah, dh
ELSE
idaa1:	sahf
	daa
idaa2:	lahf
ENDIF
	mov	[ebx].I80.regPSW, ax
	xor	eax, eax
	ret

icma:	not	[ebx].I80r.regA
IFDEF	I8XMIX
	TSTZ85
	jz	short @f
ENDIF
IFNDEF	NOI8085
	or	[ebx].I80r.regF, AF OR VF
ENDIF
@@:	xor	eax, eax
	ret

istc:	or	[ebx].I80r.regF, CF
	xor	eax, eax
	ret

icmc:	xor	[ebx].I80r.regF, CF
	xor	eax, eax
	ret

imov:	mov	ecx, eax
	and	eax, 111b
	xor	eax, 1
imov1:	shr	ecx, 3
	and	ecx, 111b
	xor	ecx, 1
	cmp	ecx, 6
	jne	short @f
	add	ecx, 2
@@:	mov	al, [ebx][eax]
	mov	[ebx][ecx], al
imov??:	xor	eax, eax
	ret
imova:	mov	ecx, eax
	mov	eax, I80r.regA
	jmp	short imov1

imovrm:	PEEKB	regHL
	mov	ecx, [esp][4]
	shr	ecx, 3
	and	ecx, 111b
	xor	ecx, 1
	cmp	ecx, 6
	jne	short @f
	add	ecx, 2
@@:	mov	[ebx][ecx], al
	xor	eax, eax
	ret

imovmr:	and	eax, 111b
	xor	eax, 1
imovmr1:
	mov	al, [ebx][eax]
	POKEB	regHL
	xor	eax, eax
	ret
imovma:	mov	eax, I80r.regA
	jmp	short imovmr1

ihlt:	mov	[ebx].I80.flag, -1
	xor	eax, eax
	ret

PEEKOPM	macro
IFDEF	FOLDOPM
IFNDEF	MEMSUB
	call	iopm
ELSE
.ERR	<FOLDOPM when MEMSUB>
ENDIF
ELSE
	PEEKB	regHL
	mov	dl, al
ENDIF
	endm

IFDEF	FOLDOPM
IFNDEF	MEMSUB
iopm:	push	iopmr
	PEEKB	regHL
	mov	dl, al
	ret
iopmr:	add	esp, 4
	ret
ENDIF
ENDIF

iadd:	mov	ecx, eax
	and	ecx, 111b
	xor	ecx, 1
	mov	dl, [ebx][ecx]
iadi:	mov	ax, [ebx].I80.regPSW
	add	al, dl
	lahf
IFDEF	I8XMIX
	TSTZ85
	jz	short @f
ENDIF
IFNDEF	NOI8085
	and	ah, NOT VF
ENDIF
@@:	mov	[ebx].I80.regPSW, ax
	xor	eax, eax
	ret
iadda:	mov	dl, [ebx].I80r.regA
	jmp	short iadi

iaddm:	PEEKOPM
	jmp	short iadi

iadc:	mov	ecx, eax
	and	ecx, 111b
	xor	ecx, 1
	mov	dl, [ebx][ecx]
iaci:	mov	ax, [ebx].I80.regPSW
	sahf
	adc	al, dl
	lahf
IFDEF	I8XMIX
	TSTZ85
	jz	short @f
ENDIF
IFNDEF	NOI8085
	and	ah, NOT VF
ENDIF
@@:	mov	[ebx].I80.regPSW, ax
	xor	eax, eax
	ret
iadca:	mov	dl, [ebx].I80r.regA
	jmp	short iaci

iadcm:	PEEKOPM
	jmp	short iaci

isub:	mov	ecx, eax
	and	ecx, 111b
	xor	ecx, 1
	mov	dl, [ebx][ecx]
isui:	mov	ax, [ebx].I80.regPSW
	sub	al, dl
	lahf
IFDEF	EXACTF
	xor	ah, AF
ENDIF
	mov	[ebx].I80.regPSW, ax
	xor	eax, eax
	ret
isuba:	mov	dl, [ebx].I80r.regA
	jmp	short isui

isubm:	PEEKOPM
	jmp	short isui

isbb:	mov	ecx, eax
	and	ecx, 111b
	xor	ecx, 1
	mov	dl, [ebx][ecx]
isbi:	mov	ax, [ebx].I80.regPSW
	sahf
	sbb	al, dl
	lahf
IFDEF	EXACTF
	xor	ah, AF
ENDIF
	mov	[ebx].I80.regPSW, ax
	xor	eax, eax
	ret
isbba:	mov	dl, [ebx].I80r.regA
	jmp	short isbi

isbbm:	PEEKOPM
	jmp	short isbi

iana:	mov	ecx, eax
	and	ecx, 111b
	xor	ecx, 1
	mov	dl, [ebx][ecx]
iani:	mov	ax, [ebx].I80.regPSW
IFNDEF	NOI8080
IFDEF	EXACTF
	mov	cl, al
ENDIF
ENDIF
	and	al, dl
	lahf
IFDEF	EXACTF
IFDEF	I8XMIX
	TSTZ85
	jnz	short @f
ENDIF
IFNDEF	NOI8080
	or	cl, dl
	shl	cl, 1
	and	ah, NOT AF
	and	cl, AF
	or	ah, cl
ENDIF
IFDEF	I8XMIX
	jmp	short iana1
ENDIF
IFNDEF	I8085
@@:	or	ah, AF
iana1:
ENDIF
ENDIF
	mov	[ebx].I80.regPSW, ax
	xor	eax, eax
	ret
ianaa:	mov	dl, [ebx].I80r.regA
	jmp	short iani

ianam:	PEEKOPM
	jmp	short iani

ixra:	mov	ecx, eax
	and	ecx, 111b
	xor	ecx, 1
	mov	dl, [ebx][ecx]
ixri:	mov	ax, [ebx].I80.regPSW
	xor	al, dl
	lahf
IFDEF	I8XMIX
	TSTZ85
	jz	short @f
ENDIF
IFNDEF	NOI8085
	and	ah, NOT VF
ENDIF
@@:	mov	[ebx].I80.regPSW, ax
	xor	eax, eax
	ret
ixraa:	mov	dl, [ebx].I80r.regA
	jmp	short ixri

ixram:	PEEKOPM
	jmp	short ixri

iora:	mov	ecx, eax
	and	ecx, 111b
	xor	ecx, 1
	mov	dl, [ebx][ecx]
iori:	mov	ax, [ebx].I80.regPSW
	or	al, dl
	lahf
IFDEF	I8XMIX
	TSTZ85
	jz	short @f
ENDIF
IFNDEF	NOI8085
	and	ah, NOT VF
ENDIF
@@:	mov	[ebx].I80.regPSW, ax
	xor	eax, eax
	ret
ioraa:	mov	dl, [ebx].I80r.regA
	jmp	short iori

ioram:	PEEKOPM
	jmp	short iori

icmp:	mov	ecx, eax
	and	ecx, 111b
	xor	ecx, 1
	mov	dl, [ebx][ecx]
icpi:	mov	ax, [ebx].I80.regPSW
	cmp	al, dl
	lahf
IFDEF	EXACTF
	xor	ah, AF
ENDIF
	mov	[ebx].I80.regPSW, ax
	xor	eax, eax
	ret
icmpa:	mov	dl, [ebx].I80r.regA
	jmp	short icpi

icmpm:	PEEKOPM
	jmp	short icpi

IFNDEF	NOI8080
i?jmp:	mov	[ebx].I80.flag, 1
ENDIF
ijmp:	mov	[ebx].I80.regPC, dx
	xor	eax, eax
	ret

.const

jccm	label	byte
	db	ZF, ZF, CF, CF, PF, PF, SF, SF
IFNDEF	NOI8085
	db	X5F, X5F
ENDIF
jccf	label	byte
	db	ZF, 0, CF, 0, PF, 0, SF, 0
IFNDEF	NOI8085
	db	X5F, 0
ENDIF

.code

ijcc:	shr	eax, 3
	and	eax, 111b
ijcc1:	mov	cl, [ebx].I80r.regF
	and	cl, jccm [eax]
	xor	cl, jccf [eax]
	jz	short @f
	mov	[ebx].I80.regPC, dx
IFDEF	COUNTERS
IFNDEF	NOI8085
IFDEF	I8XMIX
	TSTZ85
	jz	short @f
ENDIF
	add	[ebx].I80.itck, JCC85ATCK
ENDIF
ENDIF
@@:	xor	eax, eax
	ret
IFNDEF	NOI8085
ijccx:	shr	eax, 1
	and	eax, 1
	add	eax, 8
	jmp	short ijcc1
ENDIF

IFNDEF	NOI8080
i?call:	mov	[ebx].I80.flag, 1
ENDIF
icall:	movzx	eax, [ebx].I80.regPC
	mov	[ebx].I80.regPC, dx
	movzx	edx, [ebx].I80.regSP
	sub	edx, 2
	mov	[ebx].I80.regSP, dx
	POKEW
	xor	eax, eax
	ret

IFNDEF	NOI8080
i?ret:	mov	[ebx].I80.flag, 1
ENDIF
iiret:	PEEKW	regSP
	add	[ebx].I80.regSP, 2
	mov	[ebx].I80.regPC, ax
	xor	eax, eax
	ret

ircc:	shr	eax, 3
	and	eax, 111b
	mov	cl, [ebx].I80r.regF
	and	cl, jccm [eax]
	xor	cl, jccf [eax]
	jz	short noret
	PEEKW	regSP
	mov	[ebx].I80.regPC, ax
	add	[ebx].I80.regSP, 2
IFDEF	COUNTERS
IFDEF	I8XMIX
	TSTZ85
	jnz	short ircc1
ENDIF
IFNDEF	NOI8080
	add	[ebx].I80.itck, RCCADDTCK
ENDIF
IFDEF	I8XMIX
	jmp	short noret
ENDIF
IFNDEF	NOI8085
ircc1:	add	[ebx].I80.itck, RCC85ATCK
ENDIF
ENDIF
noret:	xor	eax, eax
	ret

irst:	mov	ecx, eax
	movzx	edx, [ebx].I80.regSP
	movzx	eax, [ebx].I80.regPC
	and	ecx, 111000b
irst1:	sub	edx, 2
	mov	[ebx].I80.regPC, cx
	mov	[ebx].I80.regSP, dx
	POKEW
@@:	xor	eax, eax
	ret
IFNDEF	NOI8085
irstv:	test	[ebx].I80r.regF, VF
	jz	short @b
	mov	ecx, 8 * 8
	movzx	edx, [ebx].I80.regSP
IFDEF	COUNTERS
	add	[ebx].I80.itck, RCC85ATCK
ENDIF
	jmp	short irst1
ENDIF

ipush:	shr	eax, 3
	and	eax, 110b
	mov	ax, word ptr [ebx][eax]
ipush1:	movzx	edx, [ebx].I80.regSP
	sub	edx, 2
	mov	[ebx].I80.regSP, dx
	POKEW
	xor	eax, eax
	ret
ippsw:	mov	ax, [ebx].I80.regPSW
	xchg	ah, al
IFDEF	I8XMIX
	TSTZ85
	jnz	short ipush1
ENDIF
IFNDEF	NOI8080
	and	al, NOT (X5F OR X3F)
	or	al, VF
ENDIF
	jmp	short ipush1

ipop:	PEEKW	regSP
	mov	ecx, [esp][4]
	shr	ecx, 3
	and	ecx, 110b
	cmp	ecx, 6
	jne	short ipop1
	xchg	ah, al
IFDEF	I8XMIX
	TSTZ85
	jnz	short @f
ENDIF
IFNDEF	NOI8080
	and	ah, NOT (X5F OR X3F)
	or	ah, VF
ENDIF
@@:	add	ecx, 2
ipop1:	add	[ebx].I80.regSP, 2
	mov	[ebx][ecx], ax
	xor	eax, eax
	ret

iccc:	shr	eax, 3
	and	eax, 111b
	mov	cl, [ebx].I80r.regF
	and	cl, jccm [eax]
	xor	cl, jccf [eax]
	jz	short nocall
	mov	ecx, edx
	movzx	eax, [ebx].I80.regPC
	movzx	edx, [ebx].I80.regSP
	sub	edx, 2
	mov	[ebx].I80.regPC, cx
	mov	[ebx].I80.regSP, dx
	POKEW
IFDEF	COUNTERS
IFDEF	I8XMIX
	TSTZ85
	jnz	short iccc1
ENDIF
IFNDEF	NOI8080
	add	[ebx].I80.itck, CCCADDTCK
ENDIF
IFDEF	I8XMIX
	jmp	short nocall
ENDIF
IFNDEF	NOI8085
iccc1:	add	[ebx].I80.itck, CCC85ATCK
ENDIF
ENDIF
nocall:	xor	eax, eax
	ret

ixchg:	mov	ax, [ebx].I80.regDE
	xchg	ax, [ebx].I80.regHL
	mov	[ebx].I80.regDE, ax
	xor	eax, eax
	ret

ixthl:	PEEKW	regSP
	xchg	ax, [ebx].I80.regHL
	POKEW	regSP
	xor	eax, eax
	ret

iei:	or	[ebx].I80.regINTE, 1
	xor	eax, eax
	ret

idi:	and	[ebx].I80.regINTE, NOT 1
	xor	eax, eax
	ret

iin:	cmp	[ebx].I80.inb, 0
	jz	short noinb
	movzx	edx, dl
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	dword ptr [ebx].I80.inb
	test	eax, eax
	js	short errinb
	mov	[ebx].I80r.regA, al
noinb:
	xor	eax, eax
errinb:
	ret

iout:	cmp	[ebx].I80.outb, 0
	jz	short nooutb
	movzx	edx, dl
	movzx	eax, [ebx].I80r.regA
	push	eax
IFNDEF	FASTCALLBACK
	push	edx
	push	ebx
ELSE
	mov	ecx, ebx
ENDIF
	call	dword ptr [ebx].I80.outb
	test	eax, eax
	js	short erroutb
nooutb:
	xor	eax, eax
erroutb:
	ret

ipchl:	mov	ax, [ebx].I80.regHL
	mov	[ebx].I80.regPC, ax
	xor	eax, eax
	ret

isphl:	mov	ax, [ebx].I80.regHL
	mov	[ebx].I80.regSP, ax
	xor	eax, eax
	ret

IFNDEF	NOI8085
iinx85:	shr	eax, 3
	mov	cl, [ebx].I80r.regF
	and	eax, 110b
	and	cl, NOT X5F
	inc	word ptr [ebx][eax]
	jnz	short @f
	or	cl, X5F
@@:	mov	[ebx].I80r.regF, cl
	xor	eax, eax
	ret

idcx85:	shr	eax, 3
	and	eax, 110b
	mov	cl, [ebx].I80r.regF
	mov	dx, word ptr [ebx][eax]
	and	cl, NOT X5F
	dec	dx
	cmp	dx, -1
	jne	short @f
	or	cl, X5F
@@:	mov	word ptr [ebx][eax], dx
	mov	[ebx].I80r.regF, cl
	xor	eax, eax
	ret

idsub:	mov	ax, [ebx].I80.regBC
	sub	[ebx].I80.regHL, ax
	lahf
IFDEF	EXACTF
	xor	ah, AF
	and	ah, NOT PF
ENDIF
	mov	[ebx].I80r.regF, ah
	ret

iarsh:	mov	ah, [ebx].I80r.regF
	and	ah, NOT CF
	sar	[ebx].I80.regHL, 1
	jnc	short @f
	or	ah, CF
@@:	mov	[ebx].I80r.regF, ah
	ret

irlde:	mov	ch, [ebx].I80r.regF
	mov	dx, [ebx].I80.regDE
	mov	cl, ch
	and	ch, NOT (CF OR VF)
	rol	dx, 1
	lahf
	and	ah, 1
	xor	cl, dl
	and	cl, 1
	shl	cl, 1
	or	ch, cl
	mov	[ebx].I80.regDE, dx
	mov	[ebx].I80r.regF, ch
	ret

irim:	mov	al, [ebx].I80.imode		; not implemented
	mov	[ebx].I80r.regA, al
	ret

isim:	mov	al, [ebx].I80r.regA		; not implemented
	mov	[ebx].I80.imode, al
	ret

ildeh:	movzx	ecx, [ebx].I80.regHL
	movzx	edx, dl
	add	edx, ecx
	PEEKW
	mov	[ebx].I80.regDE, ax
	xor	eax, eax
	ret

ildes:	movzx	ecx, [ebx].I80.regSP
	movzx	edx, dl
	add	edx, ecx
	PEEKW
	mov	[ebx].I80.regDE, ax
	xor	eax, eax
	ret

ishlx:	mov	ax, [ebx].I80.regHL
	POKEW	regDE
	ret

ilhlx:	PEEKW	regDE
	mov	[ebx].I80.regHL, ax
	ret
ENDIF

IFNDEF	NOI8080
IFNDEF	FASTEXECALL
public _i80Execute@4
ELSE
public @i80Execute@4
ENDIF
public _i80ilen
public _i80itck
public _i80idef
ENDIF

IFNDEF	NOI8085
IFNDEF	FASTEXECALL
public _i85Execute@4
ELSE
public @i85Execute@4
ENDIF
public _i85ilen
public _i85itck
public _i85idef
ENDIF

end
