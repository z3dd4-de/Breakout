extends Node2D

var level_name = ""
@onready var ball = $Ball


func _ready():
	test_level()


func test_level():
	level_name = "The Wall"
	Globals.bricks = 0
	var brick_count = 121
	var lines = 10
	var bricks_per_line = brick_count/lines
	var x = 50
	var y = 50
	for i in lines:
		x = 50
		for j in bricks_per_line:
			var br = preload("res://scenes/brick.tscn").instantiate()
			br.scale = Vector2(3, 3)
			br.position = Vector2(x, y)
			add_child(br)
			Globals.bricks += 1
			x += 150
		y += 30
	ball.velocity = Vector2(500, 500)


func _input(event) -> void:
	if event.is_action_pressed("esc"):
		get_tree().quit()
