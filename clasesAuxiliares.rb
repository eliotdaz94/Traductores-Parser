# Clase Token con la cual se crearan los tokens reconocidos por el lexer
# esta tiene 4 atributos los cuales representan el token leido, el tipo 
# o nombre del token, la fila y la columna en la cual se encuentran
class Token 
	def initialize(tok, nomb, fl, colum)     
	    @token = tok
	    @nombre = nomb
	    @fila = fl
	    @columna = colum
	end

	def get_token()
		@token
	end

	def get_nombre()
		@nombre
	end 

	def get_fila()
		@fila
	end 

	def get_columna()
		@columna
	end
end

# Clase tupla utilizada al momento de tokenizar el archivo leido, esta
# almacena una frase del archivo y la columna en la cual empieza la frase
class Tupla 
	def initialize(str, n)     
	    @frase = str
	    @columna = n   
	end
	
	def get_frase()
		@frase
	end

	def get_columna()
		@columna
	end
end