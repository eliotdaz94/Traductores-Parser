class Parser
# Estos tokens hay que cambiarlos por los que reconozcan las reglas que se 
# hacen despues del lexer.
token ident num caracter

    prechigh
        right UMINUS
        left '*' '/' '%'
        left '+' '-'

        right 'not'
        left '/\\' 
        left '\\/'

        left '++' '--'
        right '#'

        left '['
        left ']'
        left '::'
        right '$'
        left '?'
        nonassoc '<' '<=' '>' '>=' '=' '/='
    preclow

rule
    INICIAL
        : 'with' LISTA_DECLARACION 'begin' INSTRUCCION_GENERAL 'end'
        | 'begin' INSTRUCCION_GENERAL 'end' {return val[1]}
        ;
    LISTA_DECLARACION
        : LISTA_DECLARACION 'var' LISTA_IDENT ':' TIPO
        | 'var' LISTA_IDENT ':' TIPO
        ;
    LISTA_IDENT
        : LISTA_IDENT ',' VARIABLE
        | VARIABLE
        | ASIGNACION
        ;
    TIPO
        : 'int'
        | 'bool'
        | 'char'
        | 'matrix' '[' DIMENSION ']' 'of' TIPO
        ;
    DIMENSION
        : DIMENSION ',' EXPRESION
        | EXPRESION
        ;
    INSTRUCCION_GENERAL
        : SECUENCIACION
        | INSTRUCCION
    SECUENCIACION
        : INSTRUCCION_GENERAL INSTRUCCION
        ;
    INSTRUCCION
        : ASIGNACION '.' {result = val[0]}
        | I_O '.'
        | CONDICIONAL
        | REPETICION_DET
        | REPETICION_INDET
        | INICIAL
        ;
    ASIGNACION
        : EXPRESION '<-' EXPRESION {result = Asignacion.new(val[0],val[2])}
        ;
    CONDICIONAL
        : 'if' EXPRESION '->' INSTRUCCION_GENERAL CONDICIONAL_CONT
        ;
    CONDICIONAL_CONT
        : 'end'
        | 'otherwise' '->' INSTRUCCION_GENERAL 'end'
        ;
    REPETICION_DET
        : 'for' VARIABLE 'from' EXPRESION 'to' EXPRESION REPETICION_DET_CONT
        ;
    REPETICION_DET_CONT
        :  '->' INSTRUCCION_GENERAL 'end'
        | 'step' EXPRESION '->' INSTRUCCION_GENERAL 'end'
        ;
    REPETICION_INDET
        : 'while' EXPRESION '->' INSTRUCCION_GENERAL 'end'
        ;
    I_O
        : 'read' VARIABLE
        | 'print' EXPRESION
        ;
    EXPRESION
        : LITERAL 
        | VARIABLE
        | '(' EXPRESION ')'
        | EXPRESION '+' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"SUMA","BIN ARITMETICA")}
        | EXPRESION '-' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"RESTA","BIN ARITMETICA")}
        | EXPRESION '*' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"MULTIPLICACION","BIN ARITMETICA")}
        | EXPRESION '/' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"DIVISION","BIN ARITMETICA")}
        | EXPRESION '%' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"MODULO","BIN ARITMETICA")}
        | '-' EXPRESION =UMINUS {result = ExpresionUnaria.new(val[1],"RESTA","UN ARITMETICA")}
        | EXPRESION '/\\' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"CONJUNCION","BIN BOOLEANA")}
        | EXPRESION '\\/' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"DISYUNCION","BIN BOOLEANA")}
        | 'not' EXPRESION {result = ExpresionUnaria.new(val[1],"RESTA","UN BOOLEANA")}
        | EXPRESION '++'  {result = ExpresionUnaria.new(val[0],"INCREMENTO","UN CARACTER")}
        | EXPRESION '--' {result = ExpresionUnaria.new(val[0],"DECREMENTO","UN CARACTER")}
        | '#' EXPRESION {result = ExpresionUnaria.new("ASCII",val[0],"UN CARACTER")}
        | EXPRESION '::' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"CONCATENACION","BIN MATRIZ")}
        | '$' EXPRESION {result = ExpresionUnaria.new(val[1],"ROTACION","UN MATRICIAL")}
        | EXPRESION '?' {result = ExpresionUnaria.new(val[1],"TRASPOSICION","UN MATRICIAL")}
        | EXPRESION INDEX {result = ExpresionUnaria.new(val[1],"INDEXACION","UN MATRICIAL")}
        | EXPRESION '<' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"MENOR","BIN RELACIONAL")}
        | EXPRESION '<=' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"MENOR IGUAL","BIN RELACIONAL")}
        | EXPRESION '>' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"MAYOR","BIN RELACIONAL")}
        | EXPRESION '>=' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"MAYOR IGUAL","BIN RELACIONAL")}
        | EXPRESION '=' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"IGUAL","BIN RELACIONAL")}
        | EXPRESION '/=' EXPRESION {result = ExpresionBinaria.new(val[0],val[2],"DESIGUAL","BIN RELACIONAL")}
        ;
    LITERAL
        : LIT_INT
        | LIT_BOOL
        | caracter {result = LiteralCaracter.new(val[0])}
        | LIT_MATRIX
        ;
    LIT_INT
        : num {result = LiteralEntero.new(val[0])}
        ;
    LIT_BOOL
        : 'True' {result = LiteralBooleano.new(val[0])}
        | 'False' {result = LiteralBooleano.new(val[0])}
        ;
    LIT_MATRIX #ACA no se me ocurre que hacer
        : '{' DIMENSION '}' {result = LiteralMatriz.new(val[0])}
        ;
    VARIABLE
        : ident {result = Variable.new(val[0])}
        ;
    INDEX  #NO SE SI HAY QUE COLOCAR ALGO
        : '[' DIMENSION ']'
        ;
end
 
---- inner
  attr_reader :handler
  require './handler'
  require './construirArbol.rb'
  
  def initialize (tokenizer)
    @tokenizer = tokenizer
    super()
  end

  def next_token
    @tokenizer.next_token
  end

  def parse
    do_parse
  end