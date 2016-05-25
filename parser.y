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
        : 'if' EXPRESION '->' INSTRUCCION_GENERAL CONDICIONAL_CONT {result = Condicional.new(val[1], val[3], val[4])}
        ;
    CONDICIONAL_CONT
        : 'end' {result = nil}
        | 'otherwise' '->' INSTRUCCION_GENERAL 'end' {result = val[2]}
        ;
    REPETICION_DET
        : 'for' VARIABLE 'from' EXPRESION 'to' EXPRESION REPETICION_DET_CONT 
          {result = RepeticionDet.new(val[1], val[3], val[5], val[6][0], val[6][1])}
        ;
    REPETICION_DET_CONT
        :  '->' INSTRUCCION_GENERAL 'end' {result = [nil, val[1]]}
        | 'step' EXPRESION '->' INSTRUCCION_GENERAL 'end' {result = [val[1], val[3]]}
        ;
    REPETICION_INDET
        : 'while' EXPRESION '->' INSTRUCCION_GENERAL 'end' {result = RepeticionIndet.new(val[1], val[3])}
        ;
    I_O
        : 'read' VARIABLE
        | 'print' EXPRESION
        ;
    EXPRESION
        : LITERAL 
        | VARIABLE
        | '(' EXPRESION ')'
        | EXPRESION '+' EXPRESION
        | EXPRESION '-' EXPRESION
        | EXPRESION '*' EXPRESION
        | EXPRESION '/' EXPRESION
        | EXPRESION '%' EXPRESION
        | '-' EXPRESION =UMINUS
        | EXPRESION '/\\' EXPRESION
        | EXPRESION '\\/' EXPRESION
        | 'not' EXPRESION
        | EXPRESION '++'
        | EXPRESION '--'
        | '#' EXPRESION
        | EXPRESION '::' EXPRESION
        | '$' EXPRESION
        | EXPRESION '?'
        | EXPRESION INDEX
        | EXPRESION '<' EXPRESION
        | EXPRESION '<=' EXPRESION
        | EXPRESION '>' EXPRESION
        | EXPRESION '>=' EXPRESION
        | EXPRESION '=' EXPRESION
        | EXPRESION '/=' EXPRESION
        ;
    LITERAL
        : LIT_INT
        | LIT_BOOL
        | caracter
        | LIT_MATRIX
        ;
    LIT_INT
        : num {result = LiteralEntero.new(val[0])}
        ;
    LIT_BOOL
        : 'True'
        | 'False'
        ;
    LIT_MATRIX
        : '{' DIMENSION '}' 
        ;
    VARIABLE
        : ident {result = Variable.new(val[0])}
        ;
    INDEX
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