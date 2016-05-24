class Parser
# Estos tokens hay que cambiarlos por los que reconozcan las reglas que se 
# hacen despues del lexer.
token ident num caracter

rule
    INICIAL
        : 'with' {@handler.start_inicio} LISTA_DECLARACION 'begin' {@handler.start_begin} INSTRUCCION 'end' {@handler.end}
        | 'begin' {@handler.start_begin} INSTRUCCION 'end' {@handler.end}
        ;
    LISTA_DECLARACION
        : LISTA_DECLARACION {@handler.start_lista_declaracion} 'var' LISTA_IDENT ':' TIPO
        | 'var' {@handler.start_lista_declaracion} LISTA_IDENT ':' TIPO
        ;
    LISTA_IDENT
        : LISTA_IDENT {@handler.start_lista_ident} ',' VARIABLE
        | VARIABLE
        | ASIGNACION {@handler.asignacion}
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
    INSTRUCCION
        : ASIGNACION '.' {@handler.empilar("ASIGNACION")}
        | {@handler.io} I_O '.'
        | CONDICIONAL {@handler.empilar("CONDICIONAL")}
        | REPETICION_DET
        | REPETICION_INDET
        | INICIAL
        | SECUENCIACION
        ;
    ASIGNACION
        : VARIABLE {@handler.empilar("VARIABLE")} '<-' EXPRESION
        | EXPRESION INDEX '<-' EXPRESION
        ;
    SECUENCIACION
        : INSTRUCCION INSTRUCCION
        ;
    CONDICIONAL
        : 'if' EXPRESION '->' INSTRUCCION CONDICIONAL_CONT
        ;
    CONDICIONAL_CONT
        : 'end'
        | 'otherwise' '->' INSTRUCCION {@handler.empilar("OTHERWISE")} 'end' {@handler.end}
        ;
    REPETICION_DET
        : 'for' {@handler.cicloDet} VARIABLE 'from' {@handler.desde} EXPRESION 'to' {@handler.hasta} EXPRESION REPETICION_DET_CONT
        ;
    REPETICION_DET_CONT
        :  '->' {@handler.repetir} INSTRUCCION 'end' {@handler.end}
        | 'step' {@handler.paso} EXPRESION '->' {@handler.repetir} INSTRUCCION 'end' {@handler.end}
        ;
    REPETICION_INDET
        : 'while' {@handler.cicloIndet} EXPRESION {@handler.guardia_bool} '->' {@handler.repetir} INSTRUCCION
        ;
    I_O
        : 'read' {@handler.lectura} VARIABLE
        | 'print' {@handler.impresion} EXPRESION
        ;
    EXPRESION
        : LITERAL 
        | VARIABLE {@handler.empilar("VARIABLE")}
        | EXPR_ARIT 
        | EXPR_BOOL 
        | EXPR_MATRIX
        | EXPR_RELACION
        ;
    LITERAL
        : LIT_INT {@handler.empilar("LITERAL ENTERO")}
        | LIT_BOOL
        | caracter {@handler.caracter(val[0])}
        | LIT_MATRIX
        ;
    LIT_INT
        : num {@handler.empilar(val[0])}
        | '-' NEG #Sigue sin agarrar negativos
        ;
    NEG
        : num {@handler.numeroNeg(val[0])}
        ;
    LIT_BOOL
        : 'True' {@handler.booleano("True")}
        | 'False' {@handler.booleano("False")}
        ;
    LIT_MATRIX #ACA no se me ocurre que hacer
        : '{' LIT_MATRIX '}' 
        | LIT_MATRIX ',' LIT_MATRIX
        | num {@handler.numero(val[0])}
        ;
    VARIABLE
        : ident {@handler.empilar(val[0])}
        ;
    EXPR_ARIT #EN TODAS LAS OPERACIONES SALE OPERADOR: OPERACION OPERADOR: ASI DIFERENCIAS ENTRE EL IZQ Y EL DER
        : '(' EXPRESION ')'
        | EXPRESION '+' {@handler.empilar("\'Suma\'")} EXPRESION {@handler.empilar("BIN_ARIT")}
        | EXPRESION '-' {@handler.resta} EXPRESION
        | EXPRESION '*' {@handler.mult} EXPRESION
        | EXPRESION '/' {@handler.div} EXPRESION
        | EXPRESION '%' {@handler.mod} EXPRESION
        | '-' EXPRESION 
        ;
    EXPR_BOOL
        : '(' EXPRESION ')'
        | EXPRESION '/\\' {@handler.and} EXPRESION
        | EXPRESION '\\/' {@handler.or} EXPRESION
        | {@handler.negacion} 'not' EXPRESION
        ;
    EXPR_CARACTER
        : EXPRESION {@handler.caracter(val[0])} {@handler.incremento} '++'
        | EXPRESION {@handler.caracter(val[0])} {@handler.decremento} '--'
        | '#' {@handler.ascii} EXPRESION {@handler.caracter(val[0])}
        ;
    EXPR_MATRIX
        : EXPRESION '::' {@handler.concat} EXPRESION
        | {@handler.rotacion} '$' EXPRESION
        | EXPRESION {@handler.trasp} '?'
        | EXPRESION INDEX
        ;
    INDEX  #NO SE SI HAY QUE COLOCAR ALGO
        : INDEX INDEX
        | '[' EXPRESION ']'
        | '[' DIMENSION ']'
        ;
    EXPR_RELACION
        : EXPRESION '<' {@handler.menor} EXPRESION
        | EXPRESION '<=' {@handler.menorIgual} EXPRESION
        | EXPRESION '>' {@handler.mayor} EXPRESION
        | EXPRESION '>=' {@handler.mayorIgual} EXPRESION
        | EXPRESION '=' {@handler.igual} EXPRESION
        | EXPRESION '/=' {@handler.desigual} EXPRESION
        ;
end
 
---- inner
  attr_reader :handler
  require './handler'
  
  def initialize (tokenizer, handler)
    @tokenizer = tokenizer
    @handler = handler
    super()
  end

  def next_token
    @tokenizer.next_token
  end

  def parse
    do_parse
    handler
  end