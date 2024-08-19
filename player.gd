extends CharacterBody2D

var speed = 300
var gravity_strength = 50

var hook_pos = Vector2()
var hooked = false
var rope_length = 10
var current_rope_length

func _ready():
	current_rope_length = rope_length
	
func gravity(multiplier):
	velocity.y += multiplier * gravity_strength
		
func move(delta):
	if Input.is_action_pressed("right"):
		velocity.x = speed
	elif Input.is_action_pressed("left"):
		velocity.x = -speed
	else:
		velocity.x = 0

func _physics_process(delta):
	print(position)
	gravity(1)
	hook()
	queue_redraw()
	if hooked:
		gravity(5)
		swing(delta)
		move_and_slide()
		
	move(delta)
	move_and_slide()
	
func _draw():
	var pos = global_position
	
	if hooked:
		draw_line(Vector2(0, -16), to_local(hook_pos), Color(0.35, 0.7, 0.9), 3, true)
	else:
		return
		
		
	
func hook():
	$Raycast.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("left_click"):
		hook_pos = get_hook_pos()
		if hook_pos:
			hooked = true
			current_rope_length = global_position.distance_to(hook_pos)
	if Input.is_action_just_released("left_click") and hooked:
		velocity.y -= 15 * gravity_strength
		hooked = false
func get_hook_pos():
	for raycast in $Raycast.get_children():
		if raycast.is_colliding():
			return raycast.get_collision_point()
			
func swing(delta):
	var radius = global_position - hook_pos
	if velocity.length() < 0.01 or radius.length() < 10: return
	var angle = acos(radius.dot(velocity) / (radius.length() * velocity.length()))
	var rad_vel = cos(angle) * velocity.length()
	velocity += radius.normalized() * -rad_vel
	
	if global_position.distance_to(hook_pos) > current_rope_length:
		global_position = hook_pos + radius.normalized() * current_rope_length
		
	velocity += (hook_pos - global_position).normalized() * gravity_strength * delta
