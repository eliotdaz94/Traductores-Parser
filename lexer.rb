require './funcionStringATokens'
require './reformarString'
# lexer, esta funcion se encarga de abrir el archivo a revisar, luego quita los
# comentarios de cada linea usando la funcion reformarString. Seguido de esto para
# cada una de las lineas reformadas, obtiene sus tokens correspondientes y los 
# coloca en la cola de tokens o en la de errores dependiendo del tipo de token. 
# Parametros: archivo: Es el nombre del archivo a leer.
#             colaTk: Cola en la cual se almacenaran los tokens que no sean errores.
#             colaEr: Cola para almacenar los tokens de tipo error.
def lexer(archivo, colaTk, colaEr)
	expresionNum = /\d+/
	expresionId = /[a-zA-Z]\w*/
	expresionBool = /True|False/
	expresionCaracter = /'[^']*'/
	expresionSepYOper = /\,|\.|\(|\)|\[|\]|\{|\}|->|<-|\+\+|\-\-|<=|>=|::|\:|\/\\|\\\/|\*|\%|not|<|>|\=|\+|-|\#|\$|\?|\/=|\//
	expresionEspacio = /\s+/
	listaExpresiones = [expresionCaracter, expresionId, expresionNum, expresionSepYOper, expresionEspacio]
	hashTokens = { "with" => "TkWith", "begin" => "TkBegin", "while" => "TkWhile", "bool" => "TkBool", 
				  "if" => "TkIf","int" => "TkInt", "char" => "TkChar", "matrix" => "TkMatrix", 
				  "for" => "TkFor", "end" => "TkEnd", "of" => "TkOf", "from" => "TkFrom", "to" => "TkTo", 
				  "True" => "TkTrue", "False" => "TkFalse", "read" => "TkRead", "," => "TkComa", 
				  "." => "TkPunto", ":" => "TkDosPuntos", "(" => "TkParAbre", ")" => "TkParCierra", 
				  "[" => "TkCorcheteAbre", "]" => "TkCorcheteCierra", "{" => "TkLlaveAbre", 
				  "}" => "TkLlaveCierra", "->" => "TkHacer", "<-" => "TkAsignacion", "+" => "TkSuma", 
				  "-" => "TkResta", "*" => "TkMult", "/" => "TkDiv", "%" => "TkMod", "/\\" => "TkConjuncion", 
				  "\\/" => "TkDisyuncion", "not" => "TkNegacion", "<" => "TkMenor", "<=" => "TkMenorIgual", 
				  ">" => "TkMayor", ">=" => "TkMayorIgual", "=" => "TkIgual", "++" => "TkSiguienteCar", 
				  "--" => "TkAnteriorCar", "#" => "TkValorAscii", "::" => "TkConcatenacion", 
				  "$" => "TkRotacion", "?" => "TkTrasposicion", "'\\n'" => "TkCaracter", "'\\t'" => "TkCaracter",
			  	  "'\''" => "TkCaracter", "'\\\\'" => "TkCaracter" , "otherwise" => "TkOtherwise", 
			  	  "step" => "TkStep", "/=" => "TkDesigual", "var" => "TkVar", "print" => "TkPrint"}

	programa = ""
	File.open(archivo, "r") do |f|
	  	f.each_line do |line|
	  		programa = programa + line
	  	end
	end
	programa = programa.split("\n")

	programa = reformarString(programa,colaEr)

	for i in 0..Integer(programa.size)-1
		arr_aux = stringATokens(programa[i],i+1,listaExpresiones,hashTokens)
		arr_aux.sort! { |a,b| a.get_columna <=> b.get_columna }
		for j in 0..Integer(arr_aux.size)-1
			if(arr_aux[j].get_nombre != "Error")
				colaTk.push(arr_aux[j])
			else
				colaEr.push(arr_aux[j])
			end
		end
		arr_aux.clear
	end
end

