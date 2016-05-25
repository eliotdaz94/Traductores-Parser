# Funcion reformarString, esta se encarga de recibir un string y convertir
# todos aquellos caracteres pertenecientes a comentarios en espacios en blanco
# para no detectar tokens que esten comentados.
# Parametros: archivo: es el string del cual se eliminaran los comentarios
#             cola: es una cola de errores la cual se utiliza en caso de 
#             conseguir algun error de apertura o cerradura de comentarios.

def reformarString(archivo,cola)
	line2 = false
	com = true
	errorApertura = false
	errorCerradura = false
	colError = 0
	filaError = 0
	for i in 0..Integer(archivo.size)-1
	  	pos1 = 0
	  	pos2 = 0
	  	pos3 = 0
	  	pos4 = 0
	  	com = true
	  	if(archivo[i].length == 0)
	  		archivo[i] = " "
	  	end
	  	for j in 0..Integer(archivo[i].size)-1
	  		if(archivo[i][j] == "\t")
		  		archivo[i][j] = "    "
		  	end
		end
		if((/%%/).match(archivo[i]))
			pos3 =  (/%%/) =~ archivo[i]
			if((/%{/).match(archivo[i]))
			  	pos4 =  (/%{/) =~ archivo[i]
				if(pos3 < pos4)
					for j in pos3..Integer(archivo[i].size)-1
						archivo[i][j] = " "
					end
				end
			else
				for j in pos3..Integer(archivo[i].size)-1
					archivo[i][j] = " "
				end
			end
		end
	  	if(line2)
			if((/\}%/).match(archivo[i]))
		  		pos2 = (/\}%/) =~ archivo[i]
		  		for j in 0..pos2+1
		  			if(archivo[i][j] != "\t")
		  				archivo[i][j] = " "
		  			end
		  		end
		  		line2 = false
		  		errorApertura = false
		  		colError = 0
		  		filaError = 0
		  	else
			  	for j in 0..Integer(archivo[i].size)-1
		  			if(archivo[i][j] != "\t")
		  				archivo[i][j] = " "
		  			end
			  	end
			  	errorApertura = true
			end
		end
	  	while(com)
	  		pos1 = 0
	  		pos2 = 0
		  	if((/%{/).match(archivo[i]))
		  		pos1 =  (/%{/) =~ archivo[i]
		  		colError = pos1
		  		filaError = i+1
		  		if((/\}%/).match(archivo[i]))
		  			pos2 = (/\}%/) =~ archivo[i]
		  		end
		  		if(pos2 == 0)
		  			line2 = true
		  			com = false
		  			errorApertura = true
		  			for j in pos1..Integer(archivo[i].size)-1
		  				if(archivo[i][j] != "\t")
		  					archivo[i][j] = " "
		  				end
		  			end
		  		else
		  			for j in pos1..pos2+1
		  				if(archivo[i][j] != "\t")
		  					archivo[i][j] = " "
		  				end
		  			end
		  		end
		  	else
		  		com = false
		  	end
		end
	end
	if(errorApertura)
		tokenAux = Token.new("%{", "Error", filaError, colError)
		cola.push(tokenAux)
	end
	return archivo
end