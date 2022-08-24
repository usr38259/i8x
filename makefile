
AFLAGS = /coff /DI8XEXACTF

i80test.exe: cpu8x.obj
	cl /Ox i80test.c i8x.c cpu8x.obj

test: i80test.exe
	i80test.exe
