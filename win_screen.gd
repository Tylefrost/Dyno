extends Control

@onready var player = $"../../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.player_won == true:
		visible = true
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_returnbutton_pressed():
	get_tree().paused = false
	GameManager.player_won = false
	get_tree().reload_current_scene()


func _on_quitbutton_pressed():
	get_tree().quit()
