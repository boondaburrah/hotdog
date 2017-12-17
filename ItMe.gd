extends KinematicBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var view_sensitivity = 0.3
var yaw = 0
var pitch = 0

func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		yaw = fmod(yaw - event.relative_x * view_sensitivity, 360)
		pitch = max(min(pitch - event.relative_y * view_sensitivity, 90), -90)
		
		get_node("yaw").set_rotation(Vector3(0, deg2rad(yaw), 0))
		get_node("yaw/Camera").set_rotation(Vector3(deg2rad(pitch), 0, 0))
		
		print("yaw: ", yaw)
		print("pitch: ", pitch)

func _fixed_process(delta):
	pass

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	set_process_input(true)

func _enter_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)