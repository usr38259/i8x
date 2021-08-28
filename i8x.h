
#ifndef __I8X_H
#define __I8X_H

//#define USEFETCHOP
#define USEWRLOG

#ifdef __cplusplus
extern "C" {
#endif

#ifdef FASTCALLBACK
#define I8XCALLBACK __fastcall
#else
#define I8XCALLBACK __stdcall
#endif

#ifdef FASTEXECALL
#define I8XEXECALL __fastcall
#else
#define I8XEXECALL __stdcall
#endif

typedef struct _I8X I8X;

typedef int (__fastcall *i8xiexe) (I8X *, int oper);

extern i8xiexe i80idef [256];
extern unsigned char i80ilen [256];
extern unsigned char i80itck [256];

#ifndef NOI8085
extern i8xiexe i85idef [256];
extern unsigned char i85ilen [256];
extern unsigned char i85itck [256];
#endif

typedef struct _I8X
{
	unsigned short bc;
	unsigned short de;
	unsigned short hl;
	unsigned short sp;
	unsigned short psw;
	unsigned short pc;
	signed char inte;
	signed char resvd;
	signed char flag;
	signed char mpoke;
	unsigned char *mem;
	i8xiexe *iexe;
	unsigned short mrlow;
	unsigned short mrhigh;
	unsigned short mwlow;
	unsigned short mwhigh;
	int (I8XCALLBACK *peekb) (I8X *i8x, int addr);
	int (I8XCALLBACK *peekw) (I8X *i8x, int addr);
	int (I8XCALLBACK *pokeb) (I8X *i8x, int addr, int val);
	int (I8XCALLBACK *pokew) (I8X *i8x, int addr, int val);
	int (I8XCALLBACK *inb) (I8X *i8x, int port);
	int (I8XCALLBACK *outb) (I8X *i8x, int port, int val);
#ifdef	USEFETCHOP
	int (I8XCALLBACK *fetchop) (I8X *i8x, int addr);
#endif
#ifdef	USEWRLOG
	unsigned short pokeaddr;
	unsigned short pokeval;
#endif
	unsigned int itck;
	unsigned int icount;
	unsigned int ibytes;
	void *data;
} I8X;

void i80Init (I8X *i80);
#ifndef NOI8085
int I8XEXECALL i80Execute (I8X *i80);
#endif
int i8xDasm (char *instr, const unsigned char op[3], int f);

#ifndef NOI8085
void i85Init (I8X *i85);
int I8XEXECALL i85Execute (I8X *i85);
#endif

#if !defined(NOI8080) && !defined(NOI8085)
void i8xSet85 (I8X *i8x, int f);
#define i8xIs85(p8x) ((p8x)->inte & 2)
#endif

#define i80Dasm(instr, op, f) i8xDasm (instr, op, f)

#ifndef NOI8085
#define I8XDASM_85	0x100
#define I8XDASM_ASPC	0x200
#define i85Dasm(instr, op, f) i8xDasm (instr, op, (f) | I8XDASM_85)
#endif

#ifdef __cplusplus
}
#endif

#endif
