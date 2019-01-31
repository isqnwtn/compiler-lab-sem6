(*#line 54.10 "expr.lex"*)functor ExprLexFun(structure Tokens : Expr_TOKENS)(*#line 1.1 "expr.lex.sml"*)
=
   struct
    structure UserDeclarations =
      struct
(*#line 1.1 "expr.lex"*)(* Internal datatypes and functions required by the lexer *)
(* Keeping track of position in source                    *)

type lineNo            = int
type pos               = lineNo  (* The type of Should match with expr.yacc *)
val  lineRef : pos ref = ref 0   (* reference variable to keep track of position.
				    Typing not necessary just for clarity *)

fun updateLine n      = lineRef := !(lineRef) + n

(* Stuff done to make use of the Tokens module generated by expr.grm *)

type svalue        = Tokens.svalue
type ('a,'b) token = ('a,'b) Tokens.token
type lexresult     = (svalue,pos) token


fun lineRange l r = "line " ^ l
				  (*else ("line " ^ Int.toString l ^ "-" ^ Int.toString r)*)
fun error (e,l,r) = TextIO.output(TextIO.stdErr, lineRange l r ^ ":" ^ e ^ "\n")

(*
   What to return at the end of the file. Note the extra (!pos,!pos). If you have
   the clause

   %term FOO of int  | BAR

   The token module will have two functions which are

   Token.FOO : int * pos * pos
   Token.BAR : pos * pos

   Here we give the eof function for the lexer which should return the
   EOF terminal to the parser.

*)
fun eof   ()      = Tokens.EOF (!lineRef,!lineRef)

(* Some helper functions during lexing *)

fun charsToInt m (x :: xs) = charsToInt (10 * m + ord x - ord #"0") xs
  | charsToInt m []        = m

fun toSigned (#"-" :: xs) = ~ (charsToInt 0 xs)
  | toSigned (#"~" :: xs) = ~ (charsToInt 0 xs)
  | toSigned (#"+" :: xs) =   charsToInt 0 xs
  | toSigned xs           =   charsToInt 0 xs

val toInt        = toSigned o String.explode

val newlineCount = List.length o List.filter (fn x => x = #"\n") o String.explode

(*#line 58.1 "expr.lex.sml"*)
end (* end of user routines *)
exception LexError (* raised if illegal leaf action tried *)
structure Internal =
	struct

datatype yyfinstate = N of int
type statedata = {fin : yyfinstate list, trans: string}
(* transition & final state table *)
val tab = let
val s = [ 
 (0, 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (1, 
"\000\000\000\000\000\000\000\000\000\040\041\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\040\000\000\038\000\000\036\000\035\034\033\032\000\031\000\027\
\\025\025\025\025\025\025\025\025\025\025\024\023\022\020\019\000\
\\000\007\007\007\007\007\007\007\007\007\007\007\007\007\007\007\
\\007\007\007\007\007\007\007\007\007\007\007\018\000\017\000\007\
\\000\007\007\007\007\013\010\007\007\008\007\007\007\007\007\007\
\\007\007\007\007\007\007\007\007\007\007\007\006\004\003\000\000\
\\000"
),
 (4, 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\005\000\000\000\
\\000"
),
 (7, 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\007\007\007\007\007\007\007\007\007\007\000\000\000\000\000\000\
\\000\007\007\007\007\007\007\007\007\007\007\007\007\007\007\007\
\\007\007\007\007\007\007\007\007\007\007\007\000\000\000\000\007\
\\000\007\007\007\007\007\007\007\007\007\007\007\007\007\007\007\
\\007\007\007\007\007\007\007\007\007\007\007\000\000\000\000\000\
\\000"
),
 (8, 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\007\007\007\007\007\007\007\007\007\007\000\000\000\000\000\000\
\\000\007\007\007\007\007\007\007\007\007\007\007\007\007\007\007\
\\007\007\007\007\007\007\007\007\007\007\007\000\000\000\000\007\
\\000\007\007\007\007\007\009\007\007\007\007\007\007\007\007\007\
\\007\007\007\007\007\007\007\007\007\007\007\000\000\000\000\000\
\\000"
),
 (10, 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\007\007\007\007\007\007\007\007\007\007\000\000\000\000\000\000\
\\000\007\007\007\007\007\007\007\007\007\007\007\007\007\007\007\
\\007\007\007\007\007\007\007\007\007\007\007\000\000\000\000\007\
\\000\007\007\007\007\007\007\007\007\007\007\007\007\007\007\007\
\\007\007\007\007\007\011\007\007\007\007\007\000\000\000\000\000\
\\000"
),
 (11, 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\007\007\007\007\007\007\007\007\007\007\000\000\000\000\000\000\
\\000\007\007\007\007\007\007\007\007\007\007\007\007\007\007\007\
\\007\007\007\007\007\007\007\007\007\007\007\000\000\000\000\007\
\\000\007\007\007\007\007\007\007\007\007\007\007\007\007\012\007\
\\007\007\007\007\007\007\007\007\007\007\007\000\000\000\000\000\
\\000"
),
 (13, 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\007\007\007\007\007\007\007\007\007\007\000\000\000\000\000\000\
\\000\007\007\007\007\007\007\007\007\007\007\007\007\007\007\007\
\\007\007\007\007\007\007\007\007\007\007\007\000\000\000\000\007\
\\000\007\007\007\007\007\007\007\007\007\007\007\014\007\007\007\
\\007\007\007\007\007\007\007\007\007\007\007\000\000\000\000\000\
\\000"
),
 (14, 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\007\007\007\007\007\007\007\007\007\007\000\000\000\000\000\000\
\\000\007\007\007\007\007\007\007\007\007\007\007\007\007\007\007\
\\007\007\007\007\007\007\007\007\007\007\007\000\000\000\000\007\
\\000\007\007\007\007\007\007\007\007\007\007\007\007\007\007\007\
\\007\007\007\015\007\007\007\007\007\007\007\000\000\000\000\000\
\\000"
),
 (15, 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\007\007\007\007\007\007\007\007\007\007\000\000\000\000\000\000\
\\000\007\007\007\007\007\007\007\007\007\007\007\007\007\007\007\
\\007\007\007\007\007\007\007\007\007\007\007\000\000\000\000\007\
\\000\007\007\007\007\016\007\007\007\007\007\007\007\007\007\007\
\\007\007\007\007\007\007\007\007\007\007\007\000\000\000\000\000\
\\000"
),
 (20, 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\021\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (25, 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\026\026\026\026\026\026\026\026\026\026\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (27, 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\028\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (28, 
"\028\028\028\028\028\028\028\028\028\028\000\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\029\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028"
),
 (29, 
"\028\028\028\028\028\028\028\028\028\028\000\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\029\028\028\028\028\030\
\\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028"
),
 (36, 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\037\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (38, 
"\038\038\038\038\038\038\038\038\038\038\039\038\038\038\038\038\
\\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\
\\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\
\\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\
\\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\
\\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\
\\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\
\\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\038\
\\038"
),
 (40, 
"\000\000\000\000\000\000\000\000\000\040\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\040\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (41, 
"\000\000\000\000\000\000\000\000\000\042\041\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\042\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
(0, "")]
fun f x = x 
val s = map f (rev (tl (rev s))) 
exception LexHackingError 
fun look ((j,x)::r, i: int) = if i = j then x else look(r, i) 
  | look ([], i) = raise LexHackingError
fun g {fin=x, trans=i} = {fin=x, trans=look(s,i)} 
in Vector.fromList(map g 
[{fin = [], trans = 0},
{fin = [], trans = 1},
{fin = [], trans = 1},
{fin = [(N 37)], trans = 0},
{fin = [], trans = 4},
{fin = [(N 70)], trans = 0},
{fin = [(N 35)], trans = 0},
{fin = [(N 73)], trans = 7},
{fin = [(N 73)], trans = 8},
{fin = [(N 52),(N 73)], trans = 7},
{fin = [(N 73)], trans = 10},
{fin = [(N 73)], trans = 11},
{fin = [(N 49),(N 73)], trans = 7},
{fin = [(N 73)], trans = 13},
{fin = [(N 73)], trans = 14},
{fin = [(N 73)], trans = 15},
{fin = [(N 57),(N 73)], trans = 7},
{fin = [(N 41)], trans = 0},
{fin = [(N 39)], trans = 0},
{fin = [(N 62)], trans = 0},
{fin = [(N 29)], trans = 20},
{fin = [(N 60)], trans = 0},
{fin = [(N 64)], trans = 0},
{fin = [(N 43)], trans = 0},
{fin = [(N 45)], trans = 0},
{fin = [(N 21)], trans = 25},
{fin = [(N 21)], trans = 25},
{fin = [], trans = 27},
{fin = [], trans = 28},
{fin = [], trans = 29},
{fin = [(N 16)], trans = 28},
{fin = [(N 25)], trans = 0},
{fin = [(N 23)], trans = 0},
{fin = [(N 27)], trans = 0},
{fin = [(N 33)], trans = 0},
{fin = [(N 31)], trans = 0},
{fin = [], trans = 36},
{fin = [(N 67)], trans = 0},
{fin = [], trans = 38},
{fin = [(N 3)], trans = 0},
{fin = [(N 6)], trans = 40},
{fin = [(N 10)], trans = 41},
{fin = [], trans = 41}])
end
structure StartStates =
	struct
	datatype yystartstate = STARTSTATE of int

(* start state definitions *)

val INITIAL = STARTSTATE 1;

end
type result = UserDeclarations.lexresult
	exception LexerError (* raised if illegal leaf action tried *)
end

structure YYPosInt : INTEGER = Int
fun makeLexer yyinput =
let	val yygone0= YYPosInt.fromInt ~1
	val yyb = ref "\n" 		(* buffer *)
	val yybl = ref 1		(*buffer length *)
	val yybufpos = ref 1		(* location of next character to use *)
	val yygone = ref yygone0	(* position in file of beginning of buffer *)
	val yydone = ref false		(* eof found yet? *)
	val yybegin = ref 1		(*Current 'start state' for lexer *)

	val YYBEGIN = fn (Internal.StartStates.STARTSTATE x) =>
		 yybegin := x

fun lex () : Internal.result =
let fun continue() = lex() in
  let fun scan (s,AcceptingLeaves : Internal.yyfinstate list list,l,i0) =
	let fun action (i,nil) = raise LexError
	| action (i,nil::l) = action (i-1,l)
	| action (i,(node::acts)::l) =
		case node of
		    Internal.N yyk => 
			(let fun yymktext() = substring(!yyb,i0,i-i0)
			     val yypos = YYPosInt.+(YYPosInt.fromInt i0, !yygone)
			open UserDeclarations Internal.StartStates
 in (yybufpos := i; case yyk of 

			(* Application actions *)

  10 => let val yytext=yymktext() in (*#line 60.19 "expr.lex"*) let val old = !lineRef
		   in updateLine (newlineCount yytext); lex()
		   end
		 (*#line 374.1 "expr.lex.sml"*)
 end
| 16 => ((*#line 64.29 "expr.lex"*)lex()(*#line 376.1 "expr.lex.sml"*)
)
| 21 => let val yytext=yymktext() in (*#line 65.29 "expr.lex"*) Tokens.CONST (toInt yytext, !lineRef, !lineRef) (*#line 378.1 "expr.lex.sml"*)
 end
| 23 => ((*#line 66.29 "expr.lex"*) Tokens.PLUS  (!lineRef,!lineRef) (*#line 380.1 "expr.lex.sml"*)
)
| 25 => ((*#line 67.29 "expr.lex"*) Tokens.MINUS  (!lineRef,!lineRef) (*#line 382.1 "expr.lex.sml"*)
)
| 27 => ((*#line 68.29 "expr.lex"*) Tokens.MUL (!lineRef,!lineRef) (*#line 384.1 "expr.lex.sml"*)
)
| 29 => ((*#line 69.29 "expr.lex"*) Tokens.EQUALSIGN (!lineRef,!lineRef) (*#line 386.1 "expr.lex.sml"*)
)
| 3 => ((*#line 58.19 "expr.lex"*) updateLine 1; lex ()(*#line 388.1 "expr.lex.sml"*)
)
| 31 => ((*#line 70.29 "expr.lex"*) Tokens.LPAREN (!lineRef,!lineRef) (*#line 390.1 "expr.lex.sml"*)
)
| 33 => ((*#line 71.29 "expr.lex"*) Tokens.RPAREN (!lineRef,!lineRef) (*#line 392.1 "expr.lex.sml"*)
)
| 35 => ((*#line 72.29 "expr.lex"*) Tokens.LCURL (!lineRef,!lineRef) (*#line 394.1 "expr.lex.sml"*)
)
| 37 => ((*#line 73.29 "expr.lex"*) Tokens.RCURL (!lineRef,!lineRef) (*#line 396.1 "expr.lex.sml"*)
)
| 39 => ((*#line 74.29 "expr.lex"*) Tokens.LSQUARE (!lineRef,!lineRef) (*#line 398.1 "expr.lex.sml"*)
)
| 41 => ((*#line 75.29 "expr.lex"*) Tokens.RSQUARE (!lineRef,!lineRef) (*#line 400.1 "expr.lex.sml"*)
)
| 43 => ((*#line 76.29 "expr.lex"*) Tokens.SEMICOLON (!lineRef,!lineRef) (*#line 402.1 "expr.lex.sml"*)
)
| 45 => ((*#line 77.29 "expr.lex"*) Tokens.COLON (!lineRef,!lineRef) (*#line 404.1 "expr.lex.sml"*)
)
| 49 => ((*#line 79.29 "expr.lex"*) Tokens.FUN (!lineRef,!lineRef)(*#line 406.1 "expr.lex.sml"*)
)
| 52 => ((*#line 81.29 "expr.lex"*) Tokens.IF (!lineRef,!lineRef)(*#line 408.1 "expr.lex.sml"*)
)
| 57 => ((*#line 82.29 "expr.lex"*) Tokens.ELSE (!lineRef,!lineRef)(*#line 410.1 "expr.lex.sml"*)
)
| 6 => ((*#line 59.19 "expr.lex"*) lex() (*#line 412.1 "expr.lex.sml"*)
)
| 60 => ((*#line 83.29 "expr.lex"*) Tokens.EQ (!lineRef,!lineRef) (*#line 414.1 "expr.lex.sml"*)
)
| 62 => ((*#line 84.29 "expr.lex"*) Tokens.GT (!lineRef,!lineRef) (*#line 416.1 "expr.lex.sml"*)
)
| 64 => ((*#line 85.29 "expr.lex"*) Tokens.LT (!lineRef,!lineRef) (*#line 418.1 "expr.lex.sml"*)
)
| 67 => ((*#line 86.29 "expr.lex"*) Tokens.AND (!lineRef,!lineRef) (*#line 420.1 "expr.lex.sml"*)
)
| 70 => ((*#line 87.29 "expr.lex"*) Tokens.OR (!lineRef,!lineRef) (*#line 422.1 "expr.lex.sml"*)
)
| 73 => let val yytext=yymktext() in (*#line 89.29 "expr.lex"*) Tokens.IDENTIFIER(yytext ,!lineRef, !lineRef)(*#line 424.1 "expr.lex.sml"*)
 end
| _ => raise Internal.LexerError

		) end )

	val {fin,trans} = Vector.sub(Internal.tab, s)
	val NewAcceptingLeaves = fin::AcceptingLeaves
	in if l = !yybl then
	     if trans = #trans(Vector.sub(Internal.tab,0))
	       then action(l,NewAcceptingLeaves
) else	    let val newchars= if !yydone then "" else yyinput 1024
	    in if (size newchars)=0
		  then (yydone := true;
		        if (l=i0) then UserDeclarations.eof ()
		                  else action(l,NewAcceptingLeaves))
		  else (if i0=l then yyb := newchars
		     else yyb := substring(!yyb,i0,l-i0)^newchars;
		     yygone := YYPosInt.+(!yygone, YYPosInt.fromInt i0);
		     yybl := size (!yyb);
		     scan (s,AcceptingLeaves,l-i0,0))
	    end
	  else let val NewChar = Char.ord(CharVector.sub(!yyb,l))
		val NewChar = if NewChar<128 then NewChar else 128
		val NewState = Char.ord(CharVector.sub(trans,NewChar))
		in if NewState=0 then action(l,NewAcceptingLeaves)
		else scan(NewState,NewAcceptingLeaves,l+1,i0)
	end
	end
(*
	val start= if substring(!yyb,!yybufpos-1,1)="\n"
then !yybegin+1 else !yybegin
*)
	in scan(!yybegin (* start *),nil,!yybufpos,!yybufpos)
    end
end
  in lex
  end
end
