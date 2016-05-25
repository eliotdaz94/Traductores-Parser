require './clasesAuxiliares'

# Funcion stringATokens, esta es la funcion encargada de convertir todas las
# expresiones leidas desde el archivo de entrada en los tokens correspondientes
# a cada tipo, al momento de reconocer un token, crea uno del tipo respectivo
# y luego lo coloca en un arreglo de tokens que sera retornado por la funcion.
# Parametros: stringLinea: es una linea del string a revisar
#             fila: es la fila del string que se esta revisando
#             ListaExpRegulares: son las listas correspondientes a todos los tipos
#             de expresiones regulares que puede reconocer el lexer.
#             hashTokens: es un hashMap el cual se utiliza para reconocer el nombre
#             de los tokens clave, de operadores, de separadores y algunos caracteres.

def stringATokens(stringLinea, fila, listaExpRegulares, hashTokens)
	listaTokens = []
	colaTuplas = Queue.new()
	tuplaInicial = Tupla.new(stringLinea, 1)
	colaTuplas.push(tuplaInicial)
	while (not colaTuplas.empty?())
		tuplaAux = colaTuplas.pop()
		if (listaExpRegulares[0].match(tuplaAux.get_frase()) != nil)
			matchToken = listaExpRegulares[0].match(tuplaAux.get_frase())
			posMatchToken = (listaExpRegulares[0] =~ tuplaAux.get_frase()) + tuplaAux.get_columna()
			if ((matchToken[0].length == 3) or (hashTokens.has_key?(matchToken[0])))
				if (matchToken.pre_match != "")
					tuplaPreMatch = Tupla.new(matchToken.pre_match, tuplaAux.get_columna())
					colaTuplas.push(tuplaPreMatch)
				end
				if (matchToken.post_match != "") 
					tuplaPostMatch = Tupla.new(matchToken.post_match, posMatchToken + matchToken[0].length())
					colaTuplas.push(tuplaPostMatch)
				end
				tokenAux = Token.new(matchToken[0], "TkCaracter", fila, posMatchToken)
				listaTokens.insert(-1, tokenAux)
			elsif(matchToken[0].length == 2)
				if (matchToken.pre_match != "")
					tuplaPreMatch = Tupla.new(matchToken.pre_match, tuplaAux.get_columna())
					colaTuplas.push(tuplaPreMatch)
				end
				if (matchToken.post_match != "") 
					tuplaPostMatch = Tupla.new(matchToken.post_match, posMatchToken + matchToken[0].length)
					colaTuplas.push(tuplaPostMatch)
				end
				tokenAux = Token.new(matchToken[0][1], "Error", fila, posMatchToken + 1)
				listaTokens.insert(-1, tokenAux)
			else
				if (matchToken.pre_match != "")
					tuplaPreMatch = Tupla.new(matchToken.pre_match, tuplaAux.get_columna())
					colaTuplas.push(tuplaPreMatch)
				end
				matchError = matchToken[0]
				matchError.slice!(0..2)
				if (matchToken.post_match != "" or matchError.length > 0) 
					tuplaPostMatch = Tupla.new(matchError + matchToken.post_match, posMatchToken + 3)
					colaTuplas.push(tuplaPostMatch)
				end
				tokenAux = Token.new(matchToken[0][2], "Error", fila, tuplaAux.get_columna() + 2)
				listaTokens.insert(-1, tokenAux)	
			end
		elsif (listaExpRegulares[1].match(tuplaAux.get_frase()) != nil)
			matchToken = listaExpRegulares[1].match(tuplaAux.get_frase())
			posMatchToken = (listaExpRegulares[1] =~ tuplaAux.get_frase()) + tuplaAux.get_columna()
			if (matchToken.pre_match != "")
				tuplaPreMatch = Tupla.new(matchToken.pre_match, tuplaAux.get_columna())
				colaTuplas.push(tuplaPreMatch)
			end
			if (matchToken.post_match != "") 
				tuplaPostMatch = Tupla.new(matchToken.post_match, posMatchToken + matchToken[0].length())
				colaTuplas.push(tuplaPostMatch)
			end
			if (hashTokens.has_key?(matchToken[0]))
				tokenAux = Token.new(matchToken[0], hashTokens[matchToken[0]], fila, posMatchToken)
			else
				tokenAux = Token.new(matchToken[0], "TkId", fila, posMatchToken)
			end
			listaTokens.insert(-1, tokenAux)
		elsif (listaExpRegulares[2].match(tuplaAux.get_frase()) != nil)
			matchToken = listaExpRegulares[2].match(tuplaAux.get_frase())
			posMatchToken = (listaExpRegulares[2] =~ tuplaAux.get_frase()) + tuplaAux.get_columna()
			if (matchToken.pre_match != "")
				tuplaPreMatch = Tupla.new(matchToken.pre_match, tuplaAux.get_columna())
				colaTuplas.push(tuplaPreMatch)
			end
			if (matchToken.post_match != "") 
				tuplaPostMatch = Tupla.new(matchToken.post_match, posMatchToken + matchToken[0].length())
				colaTuplas.push(tuplaPostMatch)
			end
			tokenAux = Token.new(matchToken[0], "TkNum", fila, posMatchToken)
			listaTokens.insert(-1, tokenAux)
		elsif (listaExpRegulares[3].match(tuplaAux.get_frase()) != nil)
			matchToken = listaExpRegulares[3].match(tuplaAux.get_frase())
			posMatchToken = (listaExpRegulares[3] =~ tuplaAux.get_frase()) + tuplaAux.get_columna()
			if (matchToken.pre_match != "")
				tuplaPreMatch = Tupla.new(matchToken.pre_match, tuplaAux.get_columna())
				colaTuplas.push(tuplaPreMatch)
			end
			if (matchToken.post_match != "") 
				tuplaPostMatch = Tupla.new(matchToken.post_match, posMatchToken + matchToken[0].length())
				colaTuplas.push(tuplaPostMatch)
			end
			tokenAux = Token.new(matchToken[0], hashTokens[matchToken[0]], fila, posMatchToken)
			listaTokens.insert(-1, tokenAux)
		elsif (listaExpRegulares[4].match(tuplaAux.get_frase()) != nil)
			matchToken = listaExpRegulares[4].match(tuplaAux.get_frase())
			posMatchToken = (listaExpRegulares[4] =~ tuplaAux.get_frase()) + tuplaAux.get_columna()
			if (matchToken.pre_match != "")
				tuplaPreMatch = Tupla.new(matchToken.pre_match, tuplaAux.get_columna())
				colaTuplas.push(tuplaPreMatch)
			end
			if (matchToken.post_match != "") 
				tuplaPostMatch = Tupla.new(matchToken.post_match, posMatchToken + matchToken[0].length())
				colaTuplas.push(tuplaPostMatch)
			end
		else
			matchError = tuplaAux.get_frase()
			tokenAux = Token.new(matchError.slice!(0), "Error", fila, tuplaAux.get_columna())
			listaTokens.insert(-1, tokenAux)
			if (matchError.length() > 0)
				tuplaError = Tupla.new(matchError, tuplaAux.get_columna() + 1)
				colaTuplas.push(tuplaError)
			end
		end
	end
	return listaTokens
end
