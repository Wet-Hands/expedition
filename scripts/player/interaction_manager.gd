extends Node

@export var ray : RayCast3D
@onready var player : CharacterBody3D = $".."

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("action1"):
		if ray.is_colliding():
			var tree = ray.get_collider()
			if tree.has_method("interact"):
				if tree.get_text().contains("TORCH"):
					#player.energy -= 3
					#%EnergyLabel.text = "ENERGY: " + str(int(player.energy)) + "/100"
					$AnimationPlayer.play("fire")
					await get_tree().create_timer(2.5).timeout
					tree.set_fire()

func _on_timer_timeout() -> void:
	if ray.is_colliding():
		if ray.get_collider().has_method("get_text"):
			%cLabel.text = ray.get_collider().get_text()
	else:
		%cLabel.text = ""
	$Timer.start()


func _on_fire_timer_timeout() -> void:
	pass # Replace with function body.
