extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_input
var cam_sens = 0.25

@export_group("Nodes")
@export var head : Node3D
@export var cam : Camera3D
@export var ray : RayCast3D

var energy : float = 100.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Engine.max_fps = 29.97

func _input(event: InputEvent) -> void:
		if event is InputEventMouseMotion: #If mouse is moving
			mouse_input = event.relative
			head.rotate_y(-event.relative.x * cam_sens * get_process_delta_time()) #Look left and right
			cam.rotate_x(-event.relative.y * cam_sens * get_process_delta_time()) #Look up and down
			cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-80), deg_to_rad(80)) #Stop turning so player's neck doesn't break
		if Input.is_action_just_pressed("exit"): #When backspace is pressed
			get_tree().quit() #quits game
		if Input.is_action_just_pressed("fullscreen"): #If Fullscreen (F Key) is Pressed
			if Global.fullscreen == false: #If not Fullscreen
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) #Make Fullscreen
				Global.fullscreen = true #Fullscreen is Active
			else: #If Fullscreen Already
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) #Make Windowed
				Global.fullscreen = false #Fullscreen is NOT Active

func _process(delta: float) -> void:
	#$HudLayer/VBoxContainer/PositionContainer/Label.text = "LOCATION: " + str(Vector3i(self.position))
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.

	if not is_on_floor():
		velocity += get_gravity()/1.5 * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBackward")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		energy -= .1 * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	headbob_time += delta * (velocity.length()) * float(is_on_floor())
	cam.transform.origin = headbob(headbob_time)
	%EnergyLabel.text = "ENERGY: " + str(int(energy)) + "/100"

var headbob_time = 0.0
var headbob_freq = 2
var headbob_amp = 0.05
var lowest_y = 0

func headbob(_headbob_time):
	var bob_position = Vector3.ZERO
	bob_position.y = sin(_headbob_time * headbob_freq) * headbob_amp
	#if bob_position.y < lowest_y:
		#lowest_y = bob_position.y
	#print(lowest_y)
	if bob_position.y <= (-0.099)/2:
		$Footstep.play()
		#print("footstep")
	bob_position.x = sin(_headbob_time * headbob_freq / 3) * headbob_amp
	return bob_position

var weapon_rotation_amount = 0
func weapon_tilt(input_dir, delta):
	cam.rotation.z = lerp(cam.rotation.z, -input_dir.x * weapon_rotation_amount * 15, 10 * delta)
	cam.rotation.x = lerp(cam.rotation.x, input_dir.y * weapon_rotation_amount * 20, 10 * delta)

func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()
