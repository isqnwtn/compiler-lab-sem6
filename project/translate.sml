structure Translate =
struct



fun addtabs n = if n <= 0 then
     ("")
    else
     ("   "^( addtabs (n-1)) )


(**************************************************************************************************************************************)
(**************************************************************************************************************************************)
(**************************************************translate  EXPRESSION*****************************************************************)
(**************************************************************************************************************************************)
(**************************************************************************************************************************************)


fun translateExpr (Ast.Const x )         = (" "^(Int.toString x)^" ")

  | translateExpr (Ast.EVar  x )     = x 

  | translateExpr (Ast.ARVar  (x,e) )     = (x^"["^(translateExpr e)^"]")
  
  | translateExpr (Ast.Op (x, oper, y))  = ((translateExpr x) ^ (Ast.binOpToString oper) ^ (translateExpr y ))





(**************************************************************************************************************************************)
(**************************************************************************************************************************************)
(***************************************************translate  CONDITION*****************************************************************)
(**************************************************************************************************************************************)
(**************************************************************************************************************************************)



fun translateCondition (Ast.CConst x)   = (" "^(Int.toString x)^" ")

  | translateCondition (Ast.CVar  x)    = (" "^x^" ")

  | translateCondition (Ast.CondOp (x,oper,y)) = ((translateCondition x) ^ (Ast.condOpToString oper) ^ (translateCondition y))




(**************************************************************************************************************************************)
(**************************************************************************************************************************************)
(*****************************************translate STATEMENT AND STATEMENTS*************************************************************)
(**************************************************************************************************************************************)
(**************************************************************************************************************************************)


fun translateStatement (Ast.As (x,exp,tp,isdef)) t    =
        let
          val tp_string = case tp of Ast.VOID => "void" | Ast.INT => "int"
        in
          if isdef then
          (addtabs t) ^ (x^" = ") ^ (translateExpr exp) ^ (";\n") 
          else
          (addtabs t) ^ (tp_string^" "^x^" = ") ^ (translateExpr exp) ^ (";\n")  
        end
 



 | translateStatement (Ast.Ret exp)         t  = ( (addtabs t) ^ "return " ^(translateExpr exp)^ ";\n" )



 | translateStatement (Ast.FnCl x)  t    =  ( (addtabs t) ^  (x^"();\n")  )
 | translateStatement (Ast.If (c,sl))    t = (
              (addtabs t) ^ ("if(") ^ (translateCondition c) ^  ("){\n") ^
              (translateStatements (t+1,sl) ) ^
              (addtabs t) ^ ("}\n")
             ) 
 | translateStatement (Ast.IfEl (c,sl1,sl2)) t = (
              (addtabs t) ^  ("if(") ^ (translateCondition c) ^  ("){\n") ^

              (translateStatements (t+1,sl1)) ^

              (addtabs t) ^ ("}\n") ^

              (addtabs t) ^  ("else{\n") ^

              (translateStatements (t+1,sl2) )^

              (addtabs t )^ ("}\n")
             )
 | translateStatement (Ast.DirectC x)      t= 
     let
      fun not_dollar x = if Char.compare(x,#"$") = EQUAL then false else true 
       val remove_dollar = implode(List.filter not_dollar (explode x))
     in
       (remove_dollar^"\n")
     end

 | translateStatement (Ast.StList ls) t     = (translateStatements (t,ls))

 | translateStatement (Ast.While (c,sl)) t  = (
              (addtabs t) ^ ("while(") ^ (translateCondition c) ^  ("){\n") ^
              (translateStatements (t+1,sl) ) ^
              (addtabs t) ^ ("}\n")
                                              )
 | translateStatement (Ast.EmptyStatement) t= ("")



and  translateStatements  (t,(x :: xs))   = ((translateStatement x t)^(translateStatements (t,xs)))
 |translateStatements  (t,[])        = ("")




(**************************************************************************************************************************************)
(**************************************************************************************************************************************)
(************************************************translate FUNCTION**********************************************************************)
(**************************************************************************************************************************************)
(**************************************************************************************************************************************)

fun translateFun(Ast.Fun (x,g,tp))  t  =  let
           val Ast.Fun(x,g,tp) = Compiler.compileFunction (Ast.Fun(x,g,tp))
           val ret_type = case tp of Ast.VOID => "void" | Ast.INT => "int"
           in
            (
           (ret_type^" "^x^"(){\n")^
           (translateStatements  (t+1,g) )^
            ("}\n")
            
            )
           end





(**************************************************************************************************************************************)
(**************************************************************************************************************************************)
(***************************************************translate PROGRAM ELEMENT************************************************************)
(**************************************************************************************************************************************)
(**************************************************************************************************************************************)

fun   translateElem (Ast.St statement)   = translateStatement statement 0 
 | translateElem (Ast.Fn function)       = (translateFun  function 0) 





(**************************************************************************************************************************************)
(**************************************************************************************************************************************)
(**************************************************translate*****************************************************************************)
(**************************************************************************************************************************************)
(**************************************************************************************************************************************)

fun translate []        = ("")
  | translate (x :: xs) = ((translateElem x)^(translate xs))

end
