class_name EvalTree

var toklist
var cur_tok = -1
var tree

func lookahead(tok_types, n = 1):
	if cur_tok + n >= toklist.size():
		return null
	
	# next token
	var nt = toklist[cur_tok + n]
	
	if nt in tok_types:
		return nt
	
	var ntt = 	typeof(nt)
	var is_str = ntt == TYPE_STRING
	if is_str and EvalNode.OpType.SYMBOL in tok_types:
		return nt
	
	var is_num = ntt == TYPE_INT or ntt == TYPE_REAL
	if is_num and (EvalNode.OpType.NUM in tok_types):
		return nt
		
	# print (typeof(nt))
		
	return null
	
func consume(tok_types):
	var tt = lookahead(tok_types)
	if tt:
		cur_tok += 1
	return tt
	
# top
func expr_top():
	return expr_bool()
	
func expr_precedence(next, tokens):
	var l = next.call_func()
	
	while lookahead(tokens):
		var tok = consume(tokens)
		var r = next.call_func()
		l = EvalNode.new(tok, l, r, null)
	return l
	
const e4o = [
	EvalNode.OpType.AND,
	EvalNode.OpType.OR
]
func expr_bool():
	return expr_precedence(funcref(self, "expr_comp"), e4o)

const e3o = [
	EvalNode.OpType.LEQ,
	EvalNode.OpType.LT,
	EvalNode.OpType.GEQ,
	EvalNode.OpType.GT,
	EvalNode.OpType.EQ,
	EvalNode.OpType.NEQ
]
func expr_comp():
	return expr_precedence(funcref(self, "expr_addsub"), e3o)

const e2o = [EvalNode.OpType.ADD, EvalNode.OpType.SUB]
func expr_addsub():
	return expr_precedence(funcref(self, "expr_muldiv"), e2o)

const e1o  = [EvalNode.OpType.MUL, EvalNode.OpType.DIV]
func expr_muldiv():
	return expr_precedence(funcref(self, "expr_unary"), e1o)

# Bottom rules
const e5o = [
	EvalNode.OpType.NOT,
	EvalNode.OpType.SUB,
]
func expr_unary():
	if lookahead(e5o):
		var tok = consume(e5o)
		var r = expr_term()
		return EvalNode.new(tok, null, r, null)
	else:
		return expr_term()

func expr_paren():
	consume([EvalNode.OpType.LPAREN])
	var r = expr_top()
	consume([EvalNode.OpType.RPAREN])
	return r
		
const e6o = [
	EvalNode.OpType.NUM,
	EvalNode.OpType.SYMBOL,
]
func expr_term():
	if lookahead([EvalNode.OpType.LPAREN]):
		return expr_paren()
	
	var tok = consume(e6o)
	var tt
	
	if typeof(tok) == TYPE_STRING:
		tt = EvalNode.OpType.SYMBOL
	
	if typeof(tok) in [TYPE_INT, TYPE_REAL]:
		tt = EvalNode.OpType.NUM
	
	if tt != null:
		return EvalNode.new(tt, null, null, tok)
	else:
		return null

func _init(tokens):
	toklist = tokens
	tree = expr_top()
	
func get_tree():
	return tree
	