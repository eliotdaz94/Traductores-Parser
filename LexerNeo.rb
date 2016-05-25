#!/usr/bin/env ruby

require './lexer'
require './parser'
require './Tokenizer'
require 'thread'
#attr_reader :handler
require './handler'
require './construirArbol'

# Funcion principal encargada de recibir el nombre del archivo mediante argumento
# para luego llamar al lexer e imprimir los respectivos tokens o mensajes de error.

tks = Queue.new
errs = Queue.new
lexer(ARGV[0],tks,errs)
/
if(errs.size == 0)
	for i in 0..Integer(tks.size)-1
		token = tks.pop
		if(token.get_nombre == "TkNum")
			puts(token.get_nombre+"("+token.get_token+") "+token.get_fila.to_s+" "+token.get_columna.to_s)
		elsif(token.get_nombre == "TkId")
			puts(token.get_nombre+"("+'"'+token.get_token+'"'+") "+token.get_fila.to_s+" "+token.get_columna.to_s)
		elsif(token.get_nombre == "TkCaracter")
			puts(token.get_nombre+"("+token.get_token+") "+token.get_fila.to_s+" "+token.get_columna.to_s)
		else
			puts(token.get_nombre+" "+token.get_fila.to_s+" "+token.get_columna.to_s)
		end
	end
else
	for i in 0..Integer(errs.size)-1
		token = errs.pop
		puts("Error: Caracter inesperado "+'"'+token.get_token+'"'+"en la fila "+token.get_fila.to_s+", columna "+token.get_columna.to_s)
	end
end
/
tknz = Tokenizer.new(tks)
handler = Handler.new()
prs = Parser.new(tknz)
algo = prs.parse
puts(algo.toString(1))
#pila = handler.get_stack()
#puts(pila)
#salida = construirArbol(pila)
#puts(salida.toString(1))
