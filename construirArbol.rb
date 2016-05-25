class Instruccion
	def initialize(elemt1, elemt2)
    	@elemt1 = elemt1
    	@elemt2 = elemt2
  	end
  	def get_elemt1
    	return @elemt1
  	end
  	def get_elemt2
    	return @elemt2
  	end
end 

class Condicional < Instruccion
	def initialize(elemt1, elemt2, elemt3)
		super(elemt1, elemt2)
    	@elemt3 = elemt3
  	end
  	def get_elemt3
    	return @elemt3
  	end
  	def toString(tab)
		s = "CONDICIONAL"
		s = s + "\n"
		s = s + ("\t" * tab)
		aux = get_elemt1()
		s = s + "- guardia: " + aux.toString(tab + 1)
		aux = get_elemt2()
		s = s + ("\t" * tab)
		s = s + "- exito: " + aux.toString(tab + 1)
		if (get_elemt3() != nil)
			aux = get_elemt3()
			s = s + ("\t" * tab)
			s = s + "- fallo: " + aux.toString(tab + 1)
		end
		return s
	end
end 

class Asignacion < Instruccion
	def toString(tab)
		s = "ASIGNACION"
		s = s + "\n"
		s = s + ("\t" * tab)
		aux = get_elemt1()
		s = s + "- contenedor: " + aux.toString(tab + 1)
		aux = get_elemt2()
		s = s + ("\t" * tab)
		s = s + "- expresion: " + aux.toString(tab + 1)
		return s
	end
end

class RepeticionIndet < Instruccion
	def toString(tab)
		s = "REPETICION INDETERMINADA"
		s = s + "\n"
		s = s + ("\t" * tab)
		aux = get_elemt1()
		s = s + "- guardia: " + aux.toString(tab + 1)
		aux = get_elemt2()
		s = s + ("\t" * tab)
		s = s + "- exito: " + aux.toString(tab + 1)
		return s
	end
end

class RepeticionDet < Instruccion
	def initialize(elemt1, elemt2, elemt3, elemt4, elemt5)
		super(elemt1, elemt2)
    	@elemt3 = elemt3
    	@elemt4 = elemt4
    	@elemt5 = elemt5
  	end
  	def get_elemt3
    	return @elemt3
  	end
  	def get_elemt4
    	return @elemt4
  	end
  	def get_elemt5
    	return @elemt5
  	end
  	def toString(tab)
		s = "REPETICION DETERMINADA"
		s = s + "\n"
		s = s + ("\t" * tab)
		aux = get_elemt1()
		s = s + "- iterador: " + aux.toString(tab + 1)
		aux = get_elemt2()
		s = s + ("\t" * tab)
		s = s + "- limite inferior: " + aux.toString(tab + 1)
		aux = get_elemt3()
		s = s + ("\t" * tab)
		s = s + "- limite superior: " + aux.toString(tab + 1)
		if (get_elemt4() != nil)
			aux = get_elemt4()
			s = s + ("\t" * tab)
			s = s + "- paso: " + aux.toString(tab + 1)
		end
		aux = get_elemt5()
		s = s + ("\t" * tab)
		s = s + "- cuerpo: " + aux.toString(tab + 1)
		return s
	end
end 

class Variable
	def initialize(ident)
    	@ident = ident
  	end
  	def get_ident
    	return @ident
  	end
  	def toString(tab)
  		s = "VARIABLE"
  		s = s + "\n"
		s = s + ("\t" * tab)
  		s = s + "- identificador: " + get_ident()
  		s = s + "\n"
  		return s
  	end 
end

class LiteralEntero
	def initialize(num)
    	@num = num
  	end
  	def get_num
    	return @num
  	end
  	def toString(tab)
  		s = "LITERAL ENTERO"
  		s = s + "\n"
  		s = s + ("\t" * tab)
  		s = s + "- valor: " + get_num()
  		s = s + "\n"
  		return s
  	end 
end

class ExpresionBinaria
	def initialize (izq, der, op, tipo)
    	@opIzq = nil
    	@opDer = nil
    	@operador = nil
    	@tipoExpr = tipo
  	end
  	def get_opIzq
    	return @opIzq
  	end
  	def get_opDer
    	return @opDer
  	end
  	def get_operador
    	return @operador
  	end
  	def get_tipo
  		return @tipoExpr
  	end
  	def set_opIzq(e)
    	@opIzq = e
  	end
  	def set_opDer(e)
    	@opDer = e
  	end
  	def set_operador(e)
    	@operador = e
  	end
  	def toString(tab)
  		s = get_tipo()
  		s = s + "\n"
  		s = s + ("\t" * tab)
  		s = s + "- operacion: " + get_operador()
  		aux = get_opIzq()
  		s = s + "- operador izquierdo: " + aux.toString()
  		aux = get_opDer()
		s = s + "- operador derecho: " + aux.toString()
		return s
  	end 
end 

def construirArbol(pila)
	elemt = pila.pop()
	if (elemt == "CONDICIONAL")
		c = Condicional.new()
		if (pila.last() == "OTHERWISE")
			pila.pop()
			c.set_elemt3(construirArbol(pila))
		end
		c.set_elemt2(construirArbol(pila))
		c.set_elemt1(construirArbol(pila))
		return c
	elsif (elemt == "ASIGNACION")
		a = Asignacion.new()
		a.set_elemt2(construirArbol(pila))
		a.set_elemt1(construirArbol(pila))
		return a
	elsif (elemt == "LITERAL ENTERO")
		l = LiteralEntero.new()
		l.set_num(pila.pop)
		return l 
	elsif (elemt == "VARIABLE")
		v = Variable.new()
		v.set_ident(pila.pop)
		return v 
	elsif (elemt == "")
		v = Variable.new()
		v.set_ident(pila.pop)
		return v 
	end
end

c = Condicional.new("hola", "chao", "hasta luego")
