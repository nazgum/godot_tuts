tool
extends Node2D

export(bool)  var draw_caves  setget draw_caves


# this scene exists solely to run redraw on Caves.tscn
# without the tilemap selected, so the grid isn't shown in
# the webp animation on the blog post

func draw_caves(value = null):

	# only do this if we are working in the editor
	if !Engine.is_editor_hint(): return

	$Caves.redraw()