extends Node

@export var ray : RayCast3D

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("action1"):
		if ray.is_colliding():
			if ray.get_collider().has_method("interact"):
				print("INTERACTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT")

func _on_timer_timeout() -> void:
	if ray.is_colliding():
		if ray.get_collider().has_method("get_text"):
			%cLabel.text = ray.get_collider().get_text()
	else:
		%cLabel.text = ""
	$Timer.start()
