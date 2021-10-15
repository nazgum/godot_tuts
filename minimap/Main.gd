extends Navigation2D


func _ready():
	var rect      = $Caves.get_used_rect()
	var tile_size = $Caves.tile_size

	# set the camera limits to be the size of the caves
	$Camera2D.limit_left   = rect.position.x * tile_size
	$Camera2D.limit_right  = rect.end.x * tile_size
	$Camera2D.limit_top    = rect.position.y * tile_size
	$Camera2D.limit_bottom = rect.end.y * tile_size

	# start the camera at the center of the caves
	$Camera2D.position.x = rect.position.x + (rect.size.x/2 * tile_size)
	$Camera2D.position.y = rect.position.y + (rect.size.y/2 * tile_size)
