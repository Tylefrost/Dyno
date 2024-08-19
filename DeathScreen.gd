extends Control

@onready var player = $"../../Player"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player.player_alive == false:
		visible = true


func _on_restartbutton_pressed():

	get_tree().reload_current_scene()
	
func _on_respawnbutton_pressed():
	pass # Replace with function body.


func _on_quitbutton_pressed():
	get_tree().quit()
