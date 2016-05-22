class Tokenizer
  def initialize(cola)
    @lexer = cola
  end

  def next_token
    for i in 0..Integer(@lexer.size)-1
      token = @lexer.pop()
      if(token.get_nombre() == "TkNum")
        #puts ([:num,token.get_token()])
          return [:num,token.get_token()]
      elsif(token.get_nombre() == "TkCaracter")
          #puts ([:caracter,token.get_token()])
          return [:caracter,token.get_token()]
      elsif(token.get_nombre() == "TkId")
        #puts([:ident,token.get_token()])
          return [:ident,token.get_token()]
      else
          aux = token.get_token()
          #puts([aux,aux])
          return [aux,aux]
      end
    end
    return [false,false] 
  end 
end