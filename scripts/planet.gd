extends Node3D

var colors = [Color(.5, 0, 0), Color(0, .5, 0)]
var tree_count = 300
var tree_scene = preload("res://scenes/tree.tscn")

func _ready() -> void: #Called when the node enters the scene tree for the first time.
	$Player.position = %Raycast.get_collision_point()
	$Player.position.y += 3
	$AudioStreamPlayer.play()
	stasis()
	#$Terrainy.terrain_material.albedo_color = colors.pick_random()

func generate_trees():
	for i in range(0, tree_count):
		var rand_pos = Vector2(randf_range(-100, 100), randf_range(-100, 100))
		%Raycast.position = Vector3(rand_pos.x, 30, rand_pos.y)
		if %Raycast.is_colliding():
			var ray_point = %Raycast.get_collision_point() #- %Raycast.get_collision_normal()
			$Mesh.position = ray_point
			var inst = tree_scene.instantiate()
			inst.position = ray_point
			inst.rotation.y = randf_range(0, 360)
			%Trees.add_child(inst)
			print("tree planted")
		print(%Trees.get_child_count())
		await get_tree().create_timer(.0001).timeout
				
				
func _on_terrainy_terrain_generation_finished() -> void:
	print("terrain done")
	await get_tree().create_timer(1).timeout
	generate_trees()

func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()

var grass = ["res://assets/texture/grass/grass_ground.png", "res://assets/texture/rock/Rock2.png", "res://assets/texture/rock/Rock1.png"]
func stasis():
	$Terrainy.terrain_material.set_shader_parameter("albedo", load(grass[Global.phase]))
