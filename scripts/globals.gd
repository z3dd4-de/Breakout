extends Node

signal Destroyed
signal LevelCompleted

var colors = [ Color.BLACK, Color.WHITE, Color.GREEN, Color.YELLOW, Color.RED, Color.BLUE, Color.PURPLE, 
				Color.AQUA, Color.BROWN, Color.DARK_ORANGE, Color.DARK_BLUE, Color.DARK_RED ]
var bricks = 0

func get_color() -> Color:
	colors.shuffle()
	return colors.front()


func brick_destroyed(points: int) -> void:
	Destroyed.emit(points)


func check_level() -> void:
	if bricks == 0:
		LevelCompleted.emit()
