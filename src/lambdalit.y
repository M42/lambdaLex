%{
#include <stdio.h>
#include <string.h>
#include <iostream>
#include <string>
#define YYSTYPE std::string

extern "C"
{
        int yyparse(void);
        int yylex();  
        int yywrap()
        {
                return 1;
        }

}


void yyerror(const char* str) {
    fprintf(stderr,"Error: %s\n",str);
}

int main() {
    yyparse();
}
%}

%token OPAR CPAR LAMBDA VAR DOT

%%
// Yacc syntax
root: expression
{
    using namespace std;
    const string IMPORT = "import Lambdalit";
    const string YACEXP = "yaccexp :: Expression";
    const string MAINEX = "main = putStrLn $ show yaccexp";

    cout << IMPORT << endl;
    cout << YACEXP << endl;
    cout << "yaccexp = " << $1 << endl;
    cout << MAINEX << endl;
    exit(0);
}
;

expression
       : lambda {$$ = $1;}
       | pair {$$ = $1;} 
       | variable {$$ = $1;} 
       | OPAR expression CPAR {$$ = $2;}
;


lambda: LAMBDA VAR DOT expression
{ 
    $$ = "Lambda (\'" + $2 + "\')(" + $4 + ")";
}
;

pair: expression expression
{ 
    $$ = "Pair (" + $1 + ")(" + $2 + ")";
}
;

variable: VAR
{
    $$ = "Variable \'" + $1 + "\'";
}
;

