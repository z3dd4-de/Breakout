@tool
extends StaticBody2D

var points = 0
@export var x: int
@export var y: int


func _draw() -> void:
	draw_rect(Rect2(0, 0, x, y), Globals.get_color())


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
