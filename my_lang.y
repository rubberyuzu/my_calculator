%{
	#include <math.h>
	#include <stdio.h>
	#include <stdlib.h>
	#define YYDEBUG 1	
	#define EPSYLON 1/pow(10, 20)
	#define _USE_MATH_DEFINES
%}


%union{
	int int_value;
	double double_value;
}

%token <double_value>      DOUBLE_LITERAL 
%token ADD SUB MUL DIV FACT LFLOOR RFLOOR ABS  POW ROOT MOD LOG PI CR LP RP


 %type <double_value> expression term primary_expression 


%% 

line_list  // one or multiple lines
    : line 
    | line_list line 
    ; 

line  // expression and the new line
    : expression CR 
    { 
        printf(">>%lf\n", $1); 
    } // print ">>expression"
    ;

expression 
    : term 
    |	SUB term
    {
    		$$ = -$2;
    } // $2 being term
    | expression ADD term 
    { 
        $$ = $1 + $3; 
    } 
    | expression SUB term 
    { 
        $$ = $1 - $3; 
    }
    ; 
// exp consists of term or exp+term or exp-term

term 
    : primary_expression 
    | term MUL primary_expression 
    { 
        $$ = $1 * $3; 
    } 
    | term DIV primary_expression 
    { 
        $$ = $1 / $3; 
    }
    | term POW primary_expression
    {
    		if (($1>0)|| ($1==0 && $3<0) || (($1<0)&& (fabs($3-floor($3))<EPSYLON))){
    			$$ = pow($1, $3);
    		}else{
    			yyerror("power cannot be calculated! \n");
    			YYERROR;
    		}
    }
    | ROOT primary_expression
    {
    	if ($2>0){
    		$$ = sqrt($2);
    	}else{
    		yyerror("square root to negative number! \n");
    		YYERROR;
    	}
    }
    | term MOD primary_expression
    {
    		if ((fabs($1-floor($1))<EPSYLON)&&(fabs($3-floor($3))<EPSYLON) && $3>0){ // make sure both sides are integers
    				$$ = my_modulo($1, $3);
    		}else{
    			yyerror("modulo to non-int! \n");
    			YYERROR;
    		}
    }
    ; 

primary_expression // the parts to be calculated first
		: DOUBLE_LITERAL
		|	PI
		{
			$$ = M_PI; // use M_PI defined in <math.h>
		}
    | LP expression RP 
    { 
        $$ = $2; 
    }
    | primary_expression FACT
    {
    		if ($1 >= 0){
					$$ = factorial($1);
    		}
    		else{
    			yyerror("factorial to negative number! \n");
    			YYERROR;
    		}
    } 
    | LFLOOR expression RFLOOR
    {
    		$$ = floor($2);
    }
    | ABS expression ABS
    {
    		$$ = abs($2);
    }
    | LOG LP expression RP
    {
    		if ($3 > 0){
  	  			$$ = log($3);
    		}else{
	    			yyerror("log to 0 or smaller number! \n");
	    			YYERROR;
    		}
    }
    ; 


%% 

int factorial(double x)
{
		int i;
		int result = 1;
		for(i = floor(x); i>0; i--)
		{
				result *= i;
		}
		return result;

}

int my_modulo(double x, double y) // function to calculate my_modulo. 
{
		int mod = (int)x % (int)y; // casting doubles to int
		if (mod<0)
		{
			mod += y; // if mod is negative, make is positive by adding y
		}
		return mod;
}


int yyerror(char const *str) 
{ 
    extern char *yytext; 
    fprintf(stderr, "parser error near %s\n", yytext); 
    return 0; 
} 


int main(void) 
{ 
    extern int yyparse(void); 
    extern FILE *yyin; 


    yyin = stdin; 
    if (yyparse()) { 
        fprintf(stderr, "Error occured! \n"); 
        exit(1); 
    } 
} 