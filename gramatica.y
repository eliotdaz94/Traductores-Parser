class parser
# Estos tokens hay que cambiarlos por los que reconozcan las reglas que se 
# hacen despues del lexer.
token ident num caracter

rule
    INICIAL
        : 'with' LISTA_DECLARACION 'begin' INSTRUCCION 'end' 
        | 'begin' INSTRUCCION 'end'
        ;
    LISTA_DECLARACION
        : LISTA_DECLARACION 'var' LISTA_IDENT ':' TIPO
        | 'var' LISTA_IDENT ':' TIPO
        ;
    LISTA_IDENT
        : LISTA_IDENT ',' ident
        | ident
        | ASIGNACION
        ;
    TIPO
        : 'int'
        | 'bool'
        | 'char'
        | 'matrix' '[' DIMENSION ']' 'of' TIPO
        ;
    DIMENSION
        : DIMENSION ',' num
        | num
        ;
    INSTRUCCION
        : ASIGNACION '.'
        | I_O '.'
        | CONDICIONAL
        | REPETICION_DET
        | REPETICION_INDET
        | INICIAL
        ;
    ASIGNACION
        : ident '<-' EXPRESION
        | EXPR_MATRIX INDEX '<-' EXPRESION
        ;
    SECUENCIACION
        : INSTRUCCION INSTRUCCION
        ;
    CONDICIONAL
        : 'if' EXPR_BOOL '->' INSTRUCCION 'otherwise' '->' INSTRUCCION 'end'
        ;
    REPETICION_DET
        : 'for' ident 'from' EXPR_ARIT 'to' EXPR_ARIT 'step' EXPR_ARIT '->' INSTRUCCION 'end'
        | 'for' ident 'from' EXPR_ARIT 'to' EXPR_ARIT '->' INSTRUCCION 'end'
        ;
    REPETICION_INDET
        : 'while' EXPR_BOOL '->' INSTRUCCION
        ;
    I_O
        : 'read' ident
        | 'print' EXPRESION
        ;
    EXPRESION
        : LITERAL
        | VARIABLE
        | EXPR_ARIT
        | EXPR_BOOL
        | EXPR_CARACTER
        | EXPR_MATRIX
        | EXPR_RELACION
        | EXPR_RELACION_BOOL
        | EXPR_RELACION_MATRIX
        ;
    LITERAL
        : LIT_INT
        | LIT_BOOL
        | LIT_CARACTER
        | LIT_MATRIX
        ;
    LIT_INT
        :  num
        | '-' num
        ;
    LIT_BOOL
        : 'True'
        | 'False'
        ;
    LIT_CARACTER
        : caracter
        ;
    LIT_MATRIX
        : '{' LIT_MATRIX '}'
        | LIT_MATRIX ',' LIT_MATRIX
        | num
        ;
    VARIABLE
        : ident
        ;
    EXPR_ARIT
        : '(' EXPR_ARIT ')'
        | EXPR_ARIT '+' EXPR_ARIT
        | EXPR_ARIT '-' EXPR_ARIT
        | EXPR_ARIT '*' EXPR_ARIT
        | EXPR_ARIT '/' EXPR_ARIT
        | EXPR_ARIT '%' EXPR_ARIT
        | '-' EXPR_ARIT 
        | ident
        | LIT_INT
        ;
    EXPR_BOOL
        : '(' EXPR_BOOL ')'
        | EXPR_BOOL '/\\' EXPR_BOOL
        | EXPR_BOOL '\\/' EXPR_BOOL
        | 'not' EXPR_BOOL
        | ident
        | LIT_BOOL
        ;
    EXPR_CARACTER
        : LIT_CARACTER '++'
        | LIT_CARACTER '--'
        | '#' LIT_CARACTER
        | ident '++'
        | ident '--'
        | '#' ident
        ;
    EXPR_MATRIX
        : EXPR_MATRIX '::' EXPR_MATRIX
        | '$' EXPR_MATRIX
        | EXPR_MATRIX '?'
        | EXPR_MATRIX INDEX
        | ident
        | LIT_MATRIX
        ;
    INDEX  
        : INDEX INDEX
        | '[' num ']'
        | '[' ident ']'
        ;
    EXPR_RELACION
        : EXPR_RELACION '<' EXPR_RELACION
        | EXPR_RELACION '<=' EXPR_RELACION
        | EXPR_RELACION '>' EXPR_RELACION
        | EXPR_RELACION '>=' EXPR_RELACION
        | EXPR_RELACION '=' EXPR_RELACION
        | EXPR_RELACION '/=' EXPR_RELACION
        | EXPR_ARIT
        | EXPR_CARACTER
        ;
    EXPR_RELACION_BOOL
        : EXPR_RELACION '=' EXPR_RELACION
        | EXPR_RELACION '/=' EXPR_RELACION
        ;
    EXPR_RELACION_MATRIX
        : EXPR_MATRIX '=' EXPR_MATRIX
        | EXPR_RELACION_MATRIX '/=' EXPR_RELACION_MATRIX
        ;
end
 
---- inner
def parse(tokenizer)
  @result = Catalog.new
  @lexer = tokenizer
  do_parse
end

def next_token
  @lexer.next_token
end