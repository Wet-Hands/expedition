extends StaticBody3D

var tree_state : int = 0
var tree_texts = ["TORCH TREE [LMB]", "TORCH TREE [LMB]", "DEAD TREE", "BURNING TREE"]

var nearby_trees = []

func _ready() -> void:
	refresh()

func refresh():
	if tree_state == 0:
		$tree_5/tree_5_leaves.material_override.albedo_color = Color(.5, 1, 0)
	if tree_state == 1:
		$tree_5/tree_5_leaves.material_override.albedo_color = Color(3, 2, 0)

func interact():
	pass

func get_text():
	return tree_texts[tree_state]

func set_fire():
	$GPUParticles3D.emitting = true
	tree_state = 3
	$AudioStreamPlayer3D.play()
	$FireTimer.start()
	for i in range(0, nearby_trees.size()):
		if nearby_trees[i].tree_state < 2:
			await get_tree().create_timer(1).timeout
			nearby_trees[i].set_fire()

func _on_fire_timer_timeout() -> void:
	$GPUParticles3D.emitting = false
	$tree_5/tree_5_leaves.hide()
	$FireTimer.stop()
	tree_state = 2

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("tree"):
		nearby_trees.append(body)
