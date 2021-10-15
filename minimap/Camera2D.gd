extends Camera2D

# camera movement lerp
var rate   = 4
var cutoff = 4

onready var player = get_node("../Player")


func _process(delta):
	var dest = player.position
	var x    = lerp(position.x, dest.x, rate * delta)
	var y    = lerp(position.y, dest.y, rate * delta)
	var pos  = Vector2(x,y)
	if(pos.distance_to(dest) > cutoff):
		position = pos
