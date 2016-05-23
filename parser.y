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
        : LISTA_IDENT {@handler.start_lista_ident} ',' ID
        | ID
        | ASIGNACION {@handler.asignacion}
        ;
    TIPO
        : 'int'
        | 'bool'
        | 'char'
        | 'matrix' '[' DIMENSION ']' 'of' TIPO
        ;
    DIMENSION
        : DIMENSION ',' num {@handler.numero(val[0])}
        | num {@handler.numero(val[0])}
        ;
    INSTRUCCION
        : {@handler.asignacion} ASIGNACION '.'
        | {@handler.io} I_O '.'
        | {@handler.condicional} CONDICIONAL
        | REPETICION_DET
        | REPETICION_INDET
        | INICIAL
        | SECUENCIACION
        ;
    ASIGNACION
        : ID_AS '<-' EXPRESION
        | EXPR_MATRIX INDEX '<-' EXPRESION
        ;
    SECUENCIACION
        : INSTRUCCION INSTRUCCION
        ;
    CONDICIONAL
        : 'if' {@handler.guardia_bool} EXPR_BOOL '->' {@handler.exito} INSTRUCCION 'otherwise' {@handler.contrario} '->' INSTRUCCION 'end' {@handler.end}
        | 'if' {@handler.guardia_bool} EXPR_RELACION '->' {@handler.exito} INSTRUCCION 'otherwise' {@handler.contrario} '->' INSTRUCCION 'end' {@handler.end}
        | 'if' {@handler.guardia_bool} EXPR_RELACION_BOOL '->' {@handler.exito} INSTRUCCION 'otherwise' {@handler.contrario} '->' INSTRUCCION 'end' {@handler.end}
        | 'if' {@handler.guardia_bool} EXPR_RELACION_MATRIX '->' {@handler.exito} INSTRUCCION 'otherwise' {@handler.contrario} '->' INSTRUCCION 'end' {@handler.end}
        | 'if' {@handler.guardia_bool} EXPR_BOOL '->' {@handler.exito} INSTRUCCION 'end' {@handler.end}
        | 'if' {@handler.guardia_bool} EXPR_RELACION '->' {@handler.exito} INSTRUCCION 'end' {@handler.end}
        | 'if' {@handler.guardia_bool} EXPR_RELACION_BOOL '->' {@handler.exito} INSTRUCCION 'end' {@handler.end}
        | 'if' {@handler.guardia_bool} EXPR_RELACION_MATRIX '->' {@handler.exito} INSTRUCCION 'end' {@handler.end}
        ;
    REPETICION_DET
        : 'for' {@handler.cicloDet} ID 'from' {@handler.desde} EXPR_ARIT 'to' {@handler.hasta} EXPR_ARIT H
        | 'for' {@handler.cicloDet} ID 'from' {@handler.desde} EXPR_ARIT 'to' {@handler.hasta} EXPR_ARIT H
        ;
    H   #SIN ESTA COSA RARA QUE HICE ACA SOLO ENTRABA EN EL PRIMER CASO DE REPETICION_DET, LO PUSE PARA PROBAR PERO ASI SE ARREGLA
        :  '->' {@handler.repetir} INSTRUCCION 'end' {@handler.end}
        | 'step' {@handler.paso} EXPR_ARIT '->' {@handler.repetir} INSTRUCCION 'end' {@handler.end}
        ;
    REPETICION_INDET
        : 'while' {@handler.cicloIndet} EXPR_BOOL {@handler.guardia_bool} '->' {@handler.repetir} INSTRUCCION
        ;
    I_O
        : 'read' {@handler.lectura} ID
        | 'print' {@handler.impresion} EXPRESION
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
        : num {@handler.numero(val[0])}
        | '-' NEG #Sigue sin agarrar negativos
        ;
    NEG
        : num {@handler.numeroNeg(val[0])}
        ;
    LIT_BOOL
        : 'True' {@handler.booleano("True")}
        | 'False' {@handler.booleano("False")}
        ;
    LIT_CARACTER
        : caracter {@handler.caracter(val[0])}
        ;
    LIT_MATRIX #ACA no se me ocurre que hacer
        : '{' LIT_MATRIX '}' 
        | LIT_MATRIX ',' LIT_MATRIX
        | num {@handler.numero(val[0])}
        ;
    VARIABLE
        : ID
        ;
    EXPR_ARIT #EN TODAS LAS OPERACIONES SALE OPERADOR: OPERACION OPERADOR: ASI DIFERENCIAS ENTRE EL IZQ Y EL DER
        : '(' EXPR_ARIT ')'
        | EXPR_ARIT '+' {@handler.suma} EXPR_ARIT
        | EXPR_ARIT '-' {@handler.resta} EXPR_ARIT
        | EXPR_ARIT '*' {@handler.mult} EXPR_ARIT
        | EXPR_ARIT '/' {@handler.div} EXPR_ARIT
        | EXPR_ARIT '%' {@handler.mod} EXPR_ARIT
        | '-' EXPR_ARIT 
        | {@handler.operadorV} ID
        | {@handler.operadorI} LIT_INT
        ;
    EXPR_BOOL
        : '(' EXPR_BOOL ')'
        | EXPR_BOOL '/\\' {@handler.and} EXPR_BOOL
        | EXPR_BOOL '\\/' {@handler.or} EXPR_BOOL
        | {@handler.negacion} 'not' EXPR_BOOL
        | {@handler.operadorV} ID
        | {@handler.operadorB} LIT_BOOL
        ;
    EXPR_CARACTER
        : LIT_CARACTER {@handler.incremento} '++'
        | LIT_CARACTER {@handler.decremento} '--'
        | '#' {@handler.ascii} LIT_CARACTER
        | ID {@handler.incremento} '++'
        | ID {@handler.decremento} '--'
        | '#' {@handler.ascii} ID
        ;
    EXPR_MATRIX
        : EXPR_MATRIX '::' {@handler.concat} EXPR_MATRIX
        | {@handler.rotacion} '$' EXPR_MATRIX
        | EXPR_MATRIX {@handler.trasp} '?'
        | EXPR_MATRIX INDEX
        | {@handler.operadorV} ID
        | {@handler.operadorM} LIT_MATRIX
        ;
    INDEX  #NO SE SI HAY QUE COLOCAR ALGO
        : INDEX INDEX
        | '[' num ']'
        | '[' ID ']'
        ;
    EXPR_RELACION
        : EXPR_RELACION '<' {@handler.menor} EXPR_RELACION
        | EXPR_RELACION '<=' {@handler.menorIgual} EXPR_RELACION
        | EXPR_RELACION '>' {@handler.mayor} EXPR_RELACION
        | EXPR_RELACION '>=' {@handler.mayorIgual} EXPR_RELACION
        | EXPR_RELACION '=' {@handler.igual} EXPR_RELACION
        | EXPR_RELACION '/=' {@handler.desigual} EXPR_RELACION
        | EXPR_ARIT
        | EXPR_CARACTER
        ;
    EXPR_RELACION_BOOL
        : EXPR_RELACION {@handler.igual} '=' EXPR_RELACION
        | EXPR_RELACION {@handler.desigual} '/=' EXPR_RELACION
        ;
    EXPR_RELACION_MATRIX
        : EXPR_MATRIX {@handler.igual} '=' EXPR_MATRIX
        | EXPR_RELACION_MATRIX {@handler.desigual} '/=' EXPR_RELACION_MATRIX
        ;
    ID_AS
        :ident {@handler.ident_as(val[0])}
        ;
    ID
        :ident {@handler.ident(val[0])}
        ;
end
 
---- inner
  attr_reader :handler
  require './handler'
  
  def initialize tokenizer, handler = Handler.new
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