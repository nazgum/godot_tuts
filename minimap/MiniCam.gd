extends Camera2D

# camera movement lerp
var rate   = 8
var cutoff = 4

onready var dot = get_node("../Dot")


func _process(delta):
	var dest = dot.global_position
	var x   = lerp(position.x, dest.x, rate * delta)
	var y   = lerp(position.y, dest.y, rate * delta)
	var pos = Vector2(x,y)
	if pos.distance_to(dest) > cutoff:
		position = pos
