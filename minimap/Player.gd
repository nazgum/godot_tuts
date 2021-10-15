extends Sprite

var path  = PoolVector2Array()
var speed = 400

onready var main = get_parent()

func _ready():
	pass


func _process(delta):
	if path.size() == 0: return

	var distance  = speed * delta
	var start_pos = self.position

	for i in range(path.size()):
		var dist_next = start_pos.distance_to(path[0])
		if distance < dist_next and distance > 0.0:
			self.position = start_pos.linear_interpolate(path[0], distance/dist_next)
			break

		elif path.size() == 1:
			self.position = path[0]
			break

		distance -= dist_next
		start_pos = path[0]
		path.remove(0)


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if(event.button_index == 1):
			var mouse_pos = get_global_mouse_position()
			path = main.get_simple_path(self.position, mouse_pos)
