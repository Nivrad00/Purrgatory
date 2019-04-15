extends Node

func test_tokenizer():
	var tok = EvalTokenizer.new()
	var tokens = tok.tokenize("2 + 4 * 5 and 26 >= 5 and 5 < 4 or 25 / 4 * (2 - 4 * 5) symbolize 2.35 not symbol2 2+435-3*4")
	for it_tok in tokens:
		print(it_tok.get_string())

func test_expr():
	var expr = "2 - 3 * 5 + 4"
	var tokenizer = EvalTokenizer.new()
	var tokens = tokenizer.tokenize(expr)
	var tree = EvalTree.new(tokens)
	# print(tree)
	var evaluator = EvalEvaluate.new(tree.get_tree())
	print(evaluator.evaluate(null))

func test_expr2():
	var expr = "oliver.var1 > var2 and checks == 0"
	var tokenizer = EvalTokenizer.new()
	var tokens = tokenizer.tokenize(expr)
	var tree = EvalTree.new(tokens)
	print(tree)
	var evaluator = EvalEvaluate.new(tree.get_tree())
	print(evaluator.evaluate({
			"oliver.var1": 3,
			"checks": 1,
			"var2": 2
		}))

func test_expr3():
	var expr = "3 + -5 and not oliver.happy"
	var tokenizer = EvalTokenizer.new()
	var tokens = tokenizer.tokenize(expr)
	var tree = EvalTree.new(tokens)
	print(tree)

func test_expr4():
	var expr = "3 * (2 + 5) and not a or b"
	var tokenizer = EvalTokenizer.new()
	var tokens = tokenizer.tokenize(expr)
	var tree = EvalTree.new(tokens)
	print(tree)

func test_expr5():
	var expr = "1 and 2"
	var tokenizer = EvalTokenizer.new()
	var tokens = tokenizer.tokenize(expr)
	var tree = EvalTree.new(tokens)
	print(tree)
	var evaluator = EvalEvaluate.new(tree.get_tree())
	print(evaluator.evaluate(null))
	
func _ready():
	# test_tokenizer()
	test_expr5()
	
