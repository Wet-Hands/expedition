extends StaticBody3D

var tree_state : int = 0
var tree_texts = ["TORCH TREE [LMB]", "TORCH TREE [LMB]", "DEAD TREE", "BURNING TREE"]

func interact():
	pass

func get_text():
	return tree_texts[tree_state]

func set_fire():
	$GPUParticles3D.emitting = true
	tree_state = 3
	$FireTimer.start()

func _on_fire_timer_timeout() -> void:
	$GPUParticles3D.emitting = false
	$tree_5/tree_5_leaves.hide()
	$FireTimer.stop()
	tree_state = 2
