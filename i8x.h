
#ifndef __I8X_H
#define __I8X_H

//#define I8XFASTCB
//#define I8XSTDCB
//#define I8XFASTEXC
//#define I8XSTDEXC
//#define I8XFETCHOP
//#define NOI8080
//#define NOI8085
//#define I8XWRLOG
//#define I8XCOUNTERS

#ifdef __cplusplus
extern "C" {
#endif

#if defined(I8XFASTEXC) && defined(I8XSTDEXC)
#error I8XFASTEXC and I8XSTDEXC simultaneously
#endif

#ifdef I8XFASTEXC
#define I8XEXECALL __fastcall
#else
#ifdef I8XSTDEXC
#define I8XEXECALL __stdcall
#else
#define I8XEXECALL __cdecl
#endif
#endif

#if defined(I8XFASTCB) && defined(I8XSTDCB)
#error I8XFASTCB and I8XSTDCB simultaneously
#endif

#ifdef I8XFASTCB
#define I8XCALLBACK __fastcall
#else
#ifdef I8XSTDCB
#define I8XCALLBACK __stdcall
#else
#define I8XCALLBACK __cdecl
#endif
#endif

typedef struct _I8X I8X;

typedef int (__fastcall *i8xiexe) (I8X* i8x, int oper);

#ifndef NOI8080
extern i8xiexe i80idef [256];
extern unsigned char i80ilen [256];
extern unsigned char i80itck [256];
#endif

#ifndef NOI8085
extern i8xiexe i85idef [256];
extern unsigned char i85ilen [256];
extern unsigned char i85itck [256];
#endif

typedef struct _I8Xr {
	unsigned char c, b, e, d, l, h;
	unsigned short sp;
	unsigned char a, f;
} I8Xr;

typedef struct _I8X
{
	union {
		I8Xr	r;
		struct {
			unsigned short bc;
			unsigned short de;
			unsigned short hl;
			unsigned short sp;
			unsigned short psw;
			unsigned short pc;
		};
	};
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
#ifdef	I8XFETCHOP
	int (I8XCALLBACK *fetchop) (I8X *i8x, int addr);
#endif
#ifdef	I8XWRLOG
	unsigned short pokeaddr;
	unsigned short pokeval;
#endif
#ifdef	I8XCOUNTERS
	unsigned int itck;
	unsigned int icount;
	unsigned int ibytes;
#endif
	void *data;
} I8X;

#ifndef NOI8080
void i80Init (I8X *i80);
int I8XEXECALL i80Execute (I8X *i80);
#define i80Dasm(instr, op, f) i8xDasm (instr, op, f)
#endif

#ifndef NOI8085
void i85Init (I8X *i85);
int I8XEXECALL i85Execute (I8X *i85);
#endif

#if !defined(NOI8080) && !defined(NOI8085)
void i8xSet85 (I8X *i8x, int f);
#define i8xIs85(p8x) ((p8x)->inte & 2)
#endif

int i8xDasm (char *instr, const unsigned char op[3], int f);

#define I8XDASM_ASPC	0x200

#ifndef NOI8085
#define I8XDASM_85	0x100
#define i85Dasm(instr, op, f) i8xDasm (instr, op, (f) | I8XDASM_85)
#endif

#if defined(NOI8080) && defined(NOI8085)
#error NOI8080 and NOI8085 simultaneously
#endif

#ifdef __cplusplus
}
#endif

#endif
