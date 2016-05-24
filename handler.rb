class Handler

  def initialize
    @stack = Array.new()
  end

  def empilar(elemt)
    @stack.push(elemt)
  end

  def get_stack()
    return @stack
  end

  def start_inicio
    puts("With: ")
    #@stack.push [:simbolo_inicial]
  end

  def start_begin
    puts("Begin: ")
    #@stack.push [:inicio_instruccion]
  end

  def start_lista_declaracion
  end

  def start_lista_ident
  end

  def ident(s)
    puts("Identificador: "+s)
  end

  def ident_as(s)
    puts("Contenedor: VARIABLE")
    puts("Identificador: "+s)
  end

  def asignacion
    puts("Asignacion")
  end

  def numero(n)
    puts("Literal Numerico: "+n.to_s)
  end

  def numeroNeg(n)
    puts("Literal Numerico: -"+n.to_s)
  end

  def condicional
    puts("Condicional: ")
  end

  def guardia_bool
    puts("Guardia: ExpBooleana")
  end

  def lectura
    puts("Lectura: ")
  end

  def impresion
    puts("Impresion: ")
  end
  
  def exito
    puts("Exito: ")
  end

  def contrario
    puts("Contrario: ")
  end

  def repetir
    puts("Repetir: ")
  end

  def cicloDet
    puts("Repeticion Determinada: ")
  end

  def cicloIndet
    puts("Repeticion Indeterminada: ")
  end

  def desde
    puts("Desde: ")
  end

  def hasta
    puts("Hasta: ")
  end

  def paso
    puts("Paso: ")
  end

  def io
    puts("Operacion IO: ")
  end

  def booleano(b)
    puts("Literal Booleano: " + b)
  end

  def caracter(c)
    puts("Caracter: "+c)
  end

  def negacion
    puts("Operacion: negacion")
  end

  def opIzq
    puts("Operador izquierdo: ")
  end

  def opDer
    puts("Operador derecho: ")
  end

  def operadorV
    puts("Operador: VARIABLE")
  end

  def operadorB
    puts("Operador: LITERAL BOOLEANO")
  end

  def operadorI
    puts("Operador: LITERAL ENTERO")
  end

  def operadorM
    puts("Operador: LITERAL MATRIZ")
  end

  def and
    puts("Operacion: Conjuncion")
  end

  def or
    puts("Operacion: Disyuncion")
  end

  def ascii
    puts("Operacion:  Ascii")
  end

  def incremento
    puts("Operacion: Incremento")
  end

  def decremento
    puts("Operacion: Decremento")
  end

  def suma
    puts("Operacion: Suma")
  end

  def resta
    puts("Operacion: Resta")
  end

  def mult
    puts("Operacion: Multiplicacion")
  end

  def div
    puts("Operacion: Division")
  end

  def mod
    puts("Operacion: Modulo")
  end

  def menor
    puts("Operacion: Menor")
  end

  def menorIgual
    puts("Operacion: Menor o Igual")
  end

  def mayor
    puts("Operacion: Mayor")
  end

  def mayorIgual
    puts("Operacion: Mayor o Igual")
  end

  def igual
    puts("Operacion: Igual")
  end

  def desigual
    puts("Operacion: Desigual")
  end

  def concat
    puts("Operacion: Concatenacion")
  end

  def trasp
    puts("Operacion: Trasposicion")
  end

  def rotacion
    puts("Operacion: Rotacion")
  end

  def end
    puts("END")
  end

  def get_stack()
    return @stack
  end
end