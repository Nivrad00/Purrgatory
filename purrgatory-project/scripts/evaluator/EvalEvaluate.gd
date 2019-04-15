class_name EvalEvaluate

var tree

func _init(_tree):
	tree = _tree
	
# Shorthand :X
const Op = EvalNode.OpType
	
func eval_expr(node, env):
	if node == null:
		return 0
	
	var lhs = eval_expr(node.left, env)
	var rhs = eval_expr(node.right, env)
	match node.op:
		Op.ADD: return lhs + rhs
		Op.SUB: return lhs - rhs
		Op.MUL: return lhs * rhs
		Op.DIV: return lhs / rhs
		Op.LEQ: return lhs <= rhs
		Op.LT: return lhs < rhs
		Op.GEQ: return lhs >= rhs
		Op.GT: return lhs > rhs
		Op.EQ: return lhs == rhs
		Op.NEQ: return lhs != rhs
		Op.AND: return lhs and rhs
		Op.OR: return lhs or rhs
		Op.SYMBOL: return env[node.value]
		Op.NUM: return node.value
		Op.NOT: return not rhs
	
# Takes a dict<string, real>
# outputs the result of the evaluation
func evaluate(env):
	return eval_expr(tree, env)