extends KinematicBody

const FLY_SPEED = 100
const FLY_ACCEL = 4
const WALK_MAX_SPEED = 15
const ACCEL = 2
const DECEL = 4

var view_sensitivity = 0.3
var yaw = 0
var pitch = 0
var vel = Vector3()
var isMoving = false

func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		self.yaw = fmod(yaw - event.relative_x * view_sensitivity, 360)
		self.pitch = max(min(pitch - event.relative_y * view_sensitivity, 90), -90)
		
		self.get_node("yaw").set_rotation(Vector3(0, deg2rad(yaw), 0))
		self.get_node("yaw/Camera").set_rotation(Vector3(deg2rad(pitch), 0, 0))
		
		print("yaw: ", yaw)
		print("pitch: ", pitch)

func _fly(delta):
	var where = get_node("yaw/Camera").get_global_transform().basis
	var to = Vector3()
	if Input.is_action_pressed("move_fore"):
		to -= where[2]
	elif Input.is_action_pressed("move_aft"):
		to += where[2]
	if Input.is_action_pressed("move_port"):
		to -= where[0]
	elif Input.is_action_pressed("move_starboard"):
		to += where[0]
	to = to.normalized()
	
	var target = to * self.FLY_SPEED
	self.vel = Vector3().linear_interpolate(target, self.FLY_ACCEL * delta)
	var motion = self.vel * delta
	motion = move(motion)
	
	var prevVel = vel
	var attempts = 4
	while(attempts and is_colliding()):
		var n = self.get_collision_normal()
		motion = n.slide(motion)
		self.vel = n.slide(vel)
		if(prevVel.dot(vel) > 0):
			motion = move(motion)
			if(motion.length() < 0.001):
				break
		attempts -= 1

func _walk(delta):
	var where = get_node("yaw/Camera").get_global_transform().basis
	var to = Vector3()
	if Input.is_action_pressed("move_fore"):
		to -= where[2]
	elif Input.is_action_pressed("move_aft"):
		to += where[2]
	if Input.is_action_pressed("move_port"):
		to -= where[0]
	elif Input.is_action_pressed("move_starboard"):
		to += where[0]
	self.isMoving = (to.length() > 0)
	to = to.normalized()
	
	var target = to * self.WALK_MAX_SPEED
	var accel = self.ACCEL if self.isMoving else self.DECEL
	var hvel = self.vel
	hvel.y = 0
	hvel = hvel.linear_interpolate(target, accel * delta)
	self.vel.x = hvel.x
	self.vel.z = hvel.z

	var motion = self.vel * delta
	motion = move(motion)
	
	var prevVel = vel
	var attempts = 4
	while(attempts and is_colliding()):
		var n = self.get_collision_normal()
		motion = n.slide(motion)
		self.vel = n.slide(vel)
		if(prevVel.dot(vel) > 0):
			motion = move(motion)
			if(motion.length() < 0.001):
				break
		attempts -= 1

func _fixed_process(delta):
	self._walk(delta)

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