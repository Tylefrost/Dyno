extends Node

var current_checkpoint : Checkpoint

var player : Player

var player_won = false
var player_alive = true

func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
