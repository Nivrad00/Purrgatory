class_name EvalTokenizer

var regex = RegEx.new()
var digre = RegEx.new()

func _init():
	# Number 
	# Symbol
	# and/or
	# compound comparison operators
	# +-*/ or parenthesis or lt and gt
	# compound token eq, neq
	# unary not
	regex.compile("((\\d+(\\.\\d*)?)|([\\w.][\\w.0-9]*)|and|or|<=|>=|[+\\-*\\/()<>]|==|!=|not)")
	digre.compile("^(\\d+(\\.\\d*)?)$")

func to_token(res):
	var s = res.get_string()
	if digre.search(s) != null: # is number
		return float(s)
	match s:
		"and": return EvalNode.OpType.AND
		"or": return EvalNode.OpType.OR
		"<=": return EvalNode.OpType.LEQ
		">=": return EvalNode.OpType.GEQ
		"<": return EvalNode.OpType.LT
		">": return EvalNode.OpType.GT
		"+": return EvalNode.OpType.ADD
		"-": return EvalNode.OpType.SUB
		"*": return EvalNode.OpType.MUL
		"/": return EvalNode.OpType.DIV
		"not": return EvalNode.OpType.NOT
		"(": return EvalNode.OpType.LPAREN
		")": return EvalNode.OpType.RPAREN
		"==": return EvalNode.OpType.EQ
		"!=": return EvalNode.OpType.NEQ
	
	return s

func tokenize(s):
	if s is Array:
		print(s)
	var ret = []
	for tok in regex.search_all(s):
		ret.append(to_token(tok))
	return ret
