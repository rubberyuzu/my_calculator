%{
	#include <stdio.h>
	#include "y.tab.h" //y.tab.h is going to be created automatically when compiled in yacc
										 //in y.tab.h are defined "ADD", "SUB", "MUL" etc...
	int yywrap(void){
		return 1;
	} ; // making compiling easier without linking to lex files
%}
%start COMMENT
 // define COMMENT state here

%% // define symbols here
<INITIAL>"+"			return ADD;
<INITIAL>"-"			return SUB;
<INITIAL>"*"			return MUL;
<INITIAL>"/"			return DIV;
<INITIAL>"!"			return FACT;
<INITIAL>"["			return LFLOOR;
<INITIAL>"]"			return RFLOOR;
<INITIAL>"|"			return ABS;
<INITIAL>"^"			return POW;
<INITIAL>"√"			return ROOT;
<INITIAL>"%"			return MOD;
<INITIAL>"log"		return LOG;
<INITIAL>"pi"			return PI;
<INITIAL>"oct"		
<INITIAL>"("			return LP; //left parenthesis
<INITIAL>")"			return RP; //right parenthesis
<INITIAL>"\n"			return CR;


<INITIAL>([1-9][0-9]*)|0|([0-9][1-9]*+\.[0-9][0-9]*) { 
    double temp; 
    sscanf(yytext, "%lf", &temp); 
    yylval.double_value = temp; 
    return DOUBLE_LITERAL; // return as double
} //this accepts positive integers, 0, and positive real numbers.

<INITIAL>[ \t] ; //ignore tabs

<INITIAL>"#" BEGIN COMMENT; // you can start comment by typing "#"
<INITIAL>"h\n" printf("THESE COMMANDS ARE AVAILABLE,addition +,reduction -, multiply *,division /, factorial !, gause [], absolute value ||, power ^, square root √, modulo  ,log, pi pi\n");

<COMMENT>"\n" BEGIN INITIAL;
<COMMENT>.; // ignore every other character in this state

%% 