extends StaticBody3D

var tree_state : int = 0
var tree_texts = ["TORCH TREE [LMB]", "TORCH TREE [LMB]", "DEAD TREE"]

func interact():
	pass

func get_text():
	return tree_texts[tree_state]
