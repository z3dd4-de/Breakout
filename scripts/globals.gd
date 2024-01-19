extends Node

signal Destroyed
signal LevelCompleted

var colors = [ Color.BLACK, Color.WHITE, Color.GREEN, Color.YELLOW, Color.RED, Color.BLUE ]
var bricks = 0

func get_color() -> Color:
	colors.shuffle()
	return colors.front()


func brick_destroyed(points: int):
	Destroyed.emit(points)


func check_level():
	if bricks == 0:
		LevelCompleted.emit()
