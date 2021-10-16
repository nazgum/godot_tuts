extends Camera2D

# camera movement lerp
var rate   = 4
var cutoff = 4

onready var player = get_node("../Player")
onready var caves  = get_node("../Caves")


func _ready():
	var rect      = caves.get_used_rect()
	var tile_size = caves.tile_size

	# set the camera limits to be the size of the caves
	limit_left   = rect.position.x * tile_size
	limit_right  = rect.end.x * tile_size
	limit_top    = rect.position.y * tile_size
	limit_bottom = rect.end.y * tile_size

	# start the camera at the center of the caves
	position.x = rect.position.x + (rect.size.x/2 * tile_size)
	position.y = rect.position.y + (rect.size.y/2 * tile_size)



func _process(delta):
	var dest = player.position
	var x    = lerp(position.x, dest.x, rate * delta)
	var y    = lerp(position.y, dest.y, rate * delta)
	var pos  = Vector2(x,y)
	if(pos.distance_to(dest) > cutoff):
		position = pos
