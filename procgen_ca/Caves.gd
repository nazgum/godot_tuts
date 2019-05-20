tool
extends TileMap


export(int)   var map_w         = 80
export(int)   var map_h         = 50
export(int)   var iterations    = 20000
export(int)   var neighbors     = 4
export(int)   var ground_chance = 48
export(int)   var min_cave_size = 80

export(bool)  var redraw  setget redraw

enum Tiles { GROUND, TREE, WATER, ROOF }

var caves = []


func _ready():
	pass



func redraw(value = null):

	# only do this if we are working in the editor
	if !Engine.is_editor_hint(): return

	generate()


func generate():
	clear()
	fill_roof()
	random_ground()
	dig_caves()
	get_caves()
	connect_caves()


# start by filling the map with roof tiles
func fill_roof():
	for x in range(0, map_w):
		for y in range(0, map_h):
			set_cell(x, y, Tiles.ROOF)


# then randomly place ground tiles
func random_ground():
	for x in range(1, map_w-1):
		for y in range(1, map_h-1):
			if Util.chance(ground_chance):
				set_cell(x, y, Tiles.GROUND)


func dig_caves():
	randomize()

	for i in range(iterations):
		# Pick a random point with a 1-tile buffer within the map
		var x = floor(rand_range(1, map_w-1))
		var y = floor(rand_range(1, map_h-1))

		# if nearby cells > neighbors, make it a roof tile
		if check_nearby(x,y) > neighbors:
			set_cell(x, y, Tiles.ROOF)

		# or make it the ground tile
		elif check_nearby(x,y) < neighbors:
			set_cell(x, y, Tiles.GROUND)


func get_caves():
	caves = []

	# locate all the caves and store them
	for x in range (0, map_w):
		for y in range (0, map_h):
			if get_cell(x, y) == Tiles.GROUND:
				flood_fill(x,y)

	for cave in caves:
		for tile in cave:
			set_cellv(tile, Tiles.GROUND)


func flood_fill(tilex, tiley):
	# flood fill the separate regions of the level, discard
	# the regions that are smaller than a minimum size, and
	# create a reference for the rest.

	var cave = []
	var to_fill = [Vector2(tilex, tiley)]
	while to_fill:
		var tile = to_fill.pop_back()

		if !cave.has(tile):
			cave.append(tile)
			set_cellv(tile, Tiles.ROOF)

			#check adjacent cells
			var north = Vector2(tile.x, tile.y-1)
			var south = Vector2(tile.x, tile.y+1)
			var east  = Vector2(tile.x+1, tile.y)
			var west  = Vector2(tile.x-1, tile.y)

			for dir in [north,south,east,west]:
				if get_cellv(dir) == Tiles.GROUND:
					if !to_fill.has(dir) and !cave.has(dir):
						to_fill.append(dir)

	if cave.size() >= min_cave_size:
		caves.append(cave)


func connect_caves():
	var prev_cave = null
	var tunnel_caves = caves.duplicate()

	for cave in tunnel_caves:
		if prev_cave:
			var new_point  = Util.choose(cave)
			var prev_point = Util.choose(prev_cave)

			# ensure not the same point
			if new_point != prev_point:
				create_tunnel(new_point, prev_point, cave)

		prev_cave = cave


# do a drunken walk from point1 to point2
func create_tunnel(point1, point2, cave):
	randomize()          # for randf
	var max_steps = 500  # set a max_steps so editor won't hang if walk fails
	var steps = 0
	var drunk_x = point2[0]
	var drunk_y = point2[1]

	while steps < max_steps and !cave.has(Vector2(drunk_x, drunk_y)):
		steps += 1

		# set initial dir weights
		var n       = 1.0
		var s       = 1.0
		var e       = 1.0
		var w       = 1.0
		var weight  = 1

		# weight the random walk against edges
		if drunk_x < point1.x: # drunkard is left of point1
			e += weight
		elif drunk_x > point1.x: # drunkard is right of point1
			w += weight
		if drunk_y < point1.y: # drunkard is above point1
			s += weight
		elif drunk_y > point1.y: # drunkard is below point1
			n += weight

		# normalize probabilities so they form a range from 0 to 1
		var total = n + s + e + w
		n /= total
		s /= total
		e /= total
		w /= total

		var dx
		var dy

		# choose the direction
		var choice = randf()

		if 0 <= choice and choice < n:
			dx = 0
			dy = -1
		elif n <= choice and choice < (n+s):
			dx = 0
			dy = 1
		elif (n+s) <= choice and choice < (n+s+e):
			dx = 1
			dy = 0
		else:
			dx = -1
			dy = 0

		# ensure not to walk past edge of map
		if (2 < drunk_x + dx and drunk_x + dx < map_w-2) and \
			(2 < drunk_y + dy and drunk_y + dy < map_h-2):
			drunk_x += dx
			drunk_y += dy
			if get_cell(drunk_x, drunk_y) == Tiles.ROOF:
				set_cell(drunk_x, drunk_y, Tiles.GROUND)

				# optional: make tunnel wider
				set_cell(drunk_x+1, drunk_y, Tiles.GROUND)
				set_cell(drunk_x+1, drunk_y+1, Tiles.GROUND)


# check in 8 dirs to see how many tiles are roofs
func check_nearby(x, y):
	var count = 0
	if get_cell(x, y-1)   == Tiles.ROOF:  count += 1
	if get_cell(x, y+1)   == Tiles.ROOF:  count += 1
	if get_cell(x-1, y)   == Tiles.ROOF:  count += 1
	if get_cell(x+1, y)   == Tiles.ROOF:  count += 1
	if get_cell(x+1, y+1) == Tiles.ROOF:  count += 1
	if get_cell(x+1, y-1) == Tiles.ROOF:  count += 1
	if get_cell(x-1, y+1) == Tiles.ROOF:  count += 1
	if get_cell(x-1, y-1) == Tiles.ROOF:  count += 1
	return count