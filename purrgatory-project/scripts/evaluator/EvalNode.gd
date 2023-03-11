class_name EvalNode

enum OpType {
	NUM = -1000,
	SYMBOL, # -999
	# least precedence (UNARY)
	NOT, # -998
	# +1 
	AND, #-997
	OR, #-996
	# +1 
	LEQ, #-995
	LT, #-994
	GEQ, #-993
	GT, #-992
	EQ, #-991
	NEQ #-990
	# +1 
	ADD, #-989
	SUB, #-988
	# + 1
	MUL, #-987
	DIV	 #-986
	# Parenthesis disappear... But still used as tokens
	LPAREN, #-985
	RPAREN #-984
}

var op = "?"
var left = null
var right = null
var value = null

func _init(_op, _l, _r, _val):
	op = _op
	left = _l
	right = _r
	value = _val
