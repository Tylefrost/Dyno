extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for cell_position in get_used_cells():
		var row = rng.randi_range(0,2)
		var column = rng.randi_range(0,2)
		set_cell(cell_position, 0, Vector2i(row, column))
		print(cell_position, row, column)
