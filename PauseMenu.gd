extends Control
var _is_paused:bool = false:
	set(value):
		_is_paused = value
		get_tree().paused = _is_paused
		if $"../MainMenu".visible == false and _is_paused == true:
			visible = true
		else:
			visible = false
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused
		if _is_paused == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			

func _on_resume_pressed() -> void:
	_is_paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_returntomenu_pressed():
	_is_paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().reload_current_scene()
	
	
