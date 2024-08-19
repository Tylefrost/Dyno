extends CharacterBody2D
class_name Player

#affects swing and jump
@export var gravity_strength = 8
var player_alive = true

#jumping
@export var max_jump_force = 200
@export var min_jump_force = 100
@export var jump_charge_time = 1
var is_charging_jump = false
var charge_start_time = 0
var num_jumps = 0

#swinging
var hook_pos = Vector2()
var hooked = false
var rope_length = 10
var current_rope_length

var speed = 75

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
	hook()
	queue_redraw()
	if hooked:
		gravity(0)
		swing(delta)
		move_and_slide()
	else:
		gravity(1)
	
	if !is_on_floor() or !hooked:
		num_jumps = 1
	if is_on_floor() or hooked:
		num_jumps = 0
	move(delta)
	move_and_slide()
	
	if Input.is_action_just_pressed("jump"):
		if num_jumps == 0:
			print("jump")
			num_jumps += 1
			is_charging_jump = true
			charge_start_time = Time.get_ticks_msec() / 1000.0
		
	elif Input.is_action_just_released("jump") and is_charging_jump:
		print("jump2")
		is_charging_jump = false
		velocity.y = -get_jump_force()
		
	move_and_slide()
	
func get_jump_force() -> float:
	var charge_duration = clamp(Time.get_ticks_msec() / 1000.0 - charge_start_time, 0, jump_charge_time)
	var jump_force = min_jump_force + (max_jump_force - min_jump_force) * (charge_duration / jump_charge_time)
	return jump_force
	
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
		print(hook_pos)
		if hook_pos:
			print("sex")
			hooked = true
			current_rope_length = global_position.distance_to(hook_pos)
	if Input.is_action_just_released("left_click") and hooked:
		velocity.y -= 22 * gravity_strength
		hooked = false
		
func get_hook_pos():
	for raycast in $Raycast.get_children():
		for individual_raycast in raycast.get_children():
			if individual_raycast.is_colliding():
				individual_raycast.force_raycast_update()
				return individual_raycast.get_collision_point()
			
func swing(delta):
	var radius = global_position - hook_pos
	if velocity.length() < 0.01 or radius.length() < 1: return
	var angle = acos(radius.dot(velocity) / (radius.length() * velocity.length()))
	var rad_vel = cos(angle) * velocity.length()
	velocity += radius.normalized() * -rad_vel
	
	if global_position.distance_to(hook_pos) > current_rope_length:
		global_position = hook_pos + radius.normalized() * current_rope_length
		
	#velocity += (hook_pos - global_position).normalized() * gravity_strength * delta
	
	# brings the grappling back
	if global_position.distance_to(hook_pos) > 10:
		velocity += (hook_pos - global_position).normalized() * (gravity_strength) * delta
	
	if global_position.distance_to(hook_pos) <= 10:
		velocity = Vector2.ZERO
	
func die():
	GameManager.respawn_player()
