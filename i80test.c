
#include <stdio.h>
#include <conio.h>
#include <io.h>
#include "i8x.h"

#define TEXT_BIN "8080exer.com"

#ifndef _CRTAPI1
#define _CRTAPI1 __cdecl
#endif

I8X	i80;
unsigned char mem [65536];

int _CRTAPI1 main ()
{
	FILE *f;
	long fl;
	int i;

	f = fopen (TEXT_BIN, "rb");
	if (f == NULL) {
		puts ("BIN file '" TEXT_BIN "' open error");
		return 1;
	}
	fl = filelength (fileno (f));
	if (fl <= 0 || fl > 49152) {
		puts ("File length error");
		fclose (f);
		return 1;
	}
	if (fread (mem + 0x100, filelength (fileno (f)), 1, f) != 1) {
		puts ("BIN file read error");
		fclose (f);
		return 1;
	}
	fclose (f);

	i80Init (&i80);
	i80.mrlow = i80.mwlow = 0;
	i80.mrhigh = i80.mwhigh = 0xffff;
	i80.mem = mem;
	i80.sp = 0x7ffe;
	*(unsigned short*)&mem [0x06] = 0x7ffe;
	mem [0x05] = 0xC9;
	i80.pc = 0x100;

	while (1) {
		if (i80.pc == 0) break;
		if (i80.pc == 5) switch (i80.bc & 0xff) {
		case 2: putch (i80.de & 0xff); break;
		case 9: for (i = i80.de; mem [i] != '$' && i <= 0xffff; i++)
				putch (mem [i]); break;
		default: puts ("Unsupported BDOS call"); return 0;
		}
		i80Execute (&i80);
	}
	return 0;
}
