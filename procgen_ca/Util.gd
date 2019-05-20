tool
extends Node


# the percent chance something happens
func chance(num):
	randomize()

	if randi() % 100 <= num:  return true
	else:                     return false


# Util.choose(["one", "two"])   returns one or two
func choose(choices):
	randomize()

	var rand_index = randi() % choices.size()
	return choices[rand_index]