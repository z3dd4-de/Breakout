extends Node2D

var level_name = ""
@onready var ball = $Ball


func _ready():
	test_level()


func test_level():
	level_name = "You can't destroy them all"
	Globals.bricks = 0
	var brick_count = 20
	var lines = 10
	var x = 150
	var y = 50
	
	for i in lines:
		x = 150
		var bricks_per_line = 2
		var coin = randi_range(0, 1)
		if coin == 0:
			var ub = preload("res://scenes/indestructible_brick.tscn").instantiate()
			ub.scale = Vector2(3, 3)
			ub.position = Vector2(randi_range(x, 1500), y)
			add_child(ub)
			x += 150
		else:
			var br = preload("res://scenes/brick.tscn").instantiate()
			br.scale = Vector2(3, 3)
			br.position = Vector2(randi_range(x, 1500), y)
			add_child(br)
			Globals.bricks += 1
			
		y += 50
	ball.velocity = Vector2(600, 600)
	print(Globals.bricks)


func _input(event) -> void:
	if event.is_action_pressed("esc"):
		get_tree().quit()
