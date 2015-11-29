
debug ?= 0
ifeq ($(debug), 1)
	CFLAGS=-g -DDEBUGFLAG -Wwrite-strings
	BFLAGS=-v -g
endif

bison: scanner.o
	@g++ $(CFLAGS) -std=c++11 -o bin/calc objs/* main.cpp -ly -lfl
	@bin/calc

parser.o:
	@bison -d $(BFLAGS) yacc/parser.y
	@g++ $(CFLAGS) -std=c++11 -c parser.tab.c -o objs/parser.o

scanner.o: parser.o
	@flex -o scanner.c lex/scanner.l
	@gcc $(CFLAGS) -std=gnu99 -c scanner.c -o objs/scanner.o

view:
	dot -Tps parser.dot -o graph.ps; evince graph.ps

parser: scanner.o
	@g++ $(CFLAGS) -std=c++11 objs/* -o bin/$@ -ly -lfl

parser-tests: parser-test1 parser-test2 parser-test3

parser-test1: parser
	bin/parser tests/test1.c

parser-test2: parser
	bin/parser tests/test2.c

parser-test3: parser
	bin/parser tests/test3.c

parser-test4: parser
	bin/parser tests/test4.c

clean:
	rm -f objs/* bin/* *.tab.c *.tab.h scanner.c
