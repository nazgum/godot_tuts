extends Node2D

var player
var caves

onready var main   = get_node("/root/Main")
onready var dot    = $Dot

enum Tiles { GROUND, ROOF, FOG }

func _ready():
	$FogTimer.connect("timeout", self, "clear_fog")
	generate()


func generate():
	caves = get_node("/root/Main/Caves")
	player = get_node("/root/Main/Player")

	# add starting tiles to minimap
	for cell in caves.get_used_cells():
		var tile = caves.get_cellv(cell)
		$Map.set_cellv(cell, tile)

	# fill outer borders
	var rect = $Map.get_used_rect()
	var buffer = 15  # how far tiles extends beyond edge of map

	for x in range(rect.position.x - buffer, rect.end.x + buffer):
		for y in range(rect.position.y - buffer, rect.end.y + buffer):
			var cell = Vector2(x,y)
			if $Map.get_cellv(cell) == -1:
				$Map.set_cellv(cell, Tiles.ROOF)

	dot.position = player.position/8
	$FogTimer.start()


# move the player in the minimap
func _process(delta):
	dot.position = player.position/8  # minimap is 8x smaller, 32/8 = 4


# update the fog of war
func clear_fog():
	var player_pos = caves.world_to_map(player.position)

	# how far players can see in fog
	var seex = 8
	var seey = 6

	for x in range(-seex, seex):
		for y in range(-seey, seey):
			var cell = player_pos + Vector2(x,y)
			var tile = $Map.get_cellv(cell)
			$Fog.set_cellv(cell, tile)
