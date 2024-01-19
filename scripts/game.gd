extends Node2D

var game_running = false
var points = 0
var level = 1
var max_level = 6
var game_won = false
var level_name = ""
@onready var ball = $Ball
@onready var _master = AudioServer.get_bus_index("Master")


func _ready():
	Globals.Destroyed.connect(update_points)
	Globals.LevelCompleted.connect(check_level_complete)
	randomize()
	get_tree().paused = true
	#switch_level()


func show_level_name():
	$UI/LevelNamePanel.visible = true
	$UI/LevelNamePanel/LevelNameLabel.text = level_name
	$ShowMessageTimer.start()


func switch_level():
	match level:
		1:
			level_1()
		2:
			level_2()
		3: 
			level_3()
		4:
			level_4()
		5:
			level_5()
		6: 
			level_6()
	$UI/LevelPanel/LevelLabel.text = "Level " + str(level)
	show_level_name()


func check_level_complete():
	get_tree().paused = true
	game_running = false
	$UI/LevelCompletePanel.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	level += 1
	if level <= max_level:
		$UI/LevelCompletePanel/VBoxContainer/NextLevelButton.disabled = false
	else:
		$UI/LevelCompletePanel/VBoxContainer/LevelCompletedLabel.text = "Game won!\nDo you want to start again?"
		$UI/LevelCompletePanel/VBoxContainer/NextLevelButton.text = "New Game"
		game_won = true


func level_1():		# Just a few bricks
	level_name = "Just a few bricks"
	Globals.bricks = 0
	var brick_count = 30
	var lines = 5
	var bricks_per_line = brick_count/lines
	var x = 50
	var y = 50
	for i in lines:
		x = 50
		for j in bricks_per_line:
			var br = preload("res://scenes/brick.tscn").instantiate()
			br.scale = Vector2(4, 4)
			br.position = Vector2(x, y)
			add_child(br)
			Globals.bricks += 1
			x += 300
		y += 80


func level_2():		# One Brick only
	level_name = "One Brick only"
	Globals.bricks = 1
	var br = preload("res://scenes/brick.tscn").instantiate()
	br.scale = Vector2(2, 2)
	var x = randi_range(200, 1600)
	var y = randi_range(50, 200)
	br.position = Vector2(x, y)
	br.points = 200
	add_child(br)


func level_3():		# A little bit faster
	level_name = "A little bit faster"
	Globals.bricks = 0
	var brick_count = 10
	var x = 20
	var y = 20
	for i in brick_count:
		var br = preload("res://scenes/brick.tscn").instantiate()
		br.scale = Vector2(2, 2)
		br.points = 75
		x += randi_range(10, 150)
		y += randi_range(10, 100)
		if x <= 1800 and y <= 600:
			Globals.bricks += 1
			br.position = Vector2(x, y)
			add_child(br)
	ball.velocity = Vector2(500, 500)


func level_4():		# 4 Circles
	level_name = "4 Circles"
	Globals.bricks = 0
	var x = 1920/2
	var y = 350
	var radius = 280
	var brick_count = 12
	var angle_in_degrees = 0
	for i in brick_count:
		var br = preload("res://scenes/brick.tscn").instantiate()
		br.scale = Vector2(2, 2)
		br.points = 75
		br.position = Vector2(x + radius * cos(deg_to_rad(angle_in_degrees)), y + radius * sin(deg_to_rad(angle_in_degrees)))
		add_child(br)
		angle_in_degrees += 30
		Globals.bricks += 1
		
	x = 1920/3
	y = 400
	for i in brick_count:
		var br = preload("res://scenes/brick.tscn").instantiate()
		br.scale = Vector2(2, 2)
		br.points = 75
		br.position = Vector2(x + radius * cos(deg_to_rad(angle_in_degrees)), y + radius * sin(deg_to_rad(angle_in_degrees)))
		add_child(br)
		angle_in_degrees += 30
		Globals.bricks += 1
	
	x = 1920/4 - 100
	y = 300
	for i in brick_count:
		var br = preload("res://scenes/brick.tscn").instantiate()
		br.scale = Vector2(2, 2)
		br.points = 75
		br.position = Vector2(x + radius * cos(deg_to_rad(angle_in_degrees)), y + radius * sin(deg_to_rad(angle_in_degrees)))
		add_child(br)
		angle_in_degrees += 30
		Globals.bricks += 1
	
	x = 1920 - 400
	y = 300
	for i in brick_count:
		var br = preload("res://scenes/brick.tscn").instantiate()
		br.scale = Vector2(2, 2)
		br.points = 75
		br.position = Vector2(x + radius * cos(deg_to_rad(angle_in_degrees)), y + radius * sin(deg_to_rad(angle_in_degrees)))
		add_child(br)
		angle_in_degrees += 30
		Globals.bricks += 1
	ball.position = Vector2(1920/2, 900)
	$Player.position.x = 1920/2


func level_5(): 		# A lot more bricks
	level_name = "A lot more bricks"
	Globals.bricks = 0
	var brick_count = 90
	var lines = 10
	var bricks_per_line = brick_count/lines
	var x = 50
	var y = 50
	for i in lines:
		x = 50
		for j in bricks_per_line:
			var br = preload("res://scenes/brick.tscn").instantiate()
			br.scale = Vector2(1, 1)
			br.position = Vector2(x, y)
			add_child(br)
			Globals.bricks += 1
			x += 200
		y += 30
	ball.velocity = Vector2(500, 500)


func level_6():			# 3 little bricks
	level_name = "3 little bricks"
	Globals.bricks = 0
	var brick_count = 3
	for i in brick_count:
		var br = preload("res://scenes/brick.tscn").instantiate()
		br.scale = Vector2(0.5, 0.5)
		br.points = 400
		var x = randi_range(200, 1600)
		var y = randi_range(50, 400)
		br.position = Vector2(x, y)
		add_child(br)
		Globals.bricks += 1
	ball.velocity = Vector2(700, 700)


func update_points(new_points: int) -> void:
	points += new_points
	$UI/PointsPanel/PointsLabel.text = str(points)


func _on_start_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	game_running = true
	switch_level()
	$UI/ButtonPanel.visible = false
	$UI/TitlePanel.visible = false
	$UI/PointsPanel.visible = true
	$UI/LevelPanel.visible = true
	$Player.visible = true
	ball.visible = true
	ball.position = Vector2(1000, 400)
	get_tree().paused = false


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _input(event) -> void:
	if event.is_action_pressed("esc") and game_running:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$UI/ButtonPanel.visible = true
		$UI/TitlePanel.visible = true
		$UI/PointsPanel.visible = false
		$UI/LevelPanel.visible = false
		$Player.visible = false
		ball.visible = false
		get_tree().paused = true


func _on_bottom_area_body_entered(body) -> void:
	if body.is_in_group("ball"):
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$UI/GameOverPanel/VBoxContainer/PointsLabel.text = str(points) + " Points"
		$UI/GameOverPanel.visible = true
		$UI/PointsPanel.visible = false
		$UI/LevelPanel.visible = false


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_next_level_button_pressed() -> void:
	if !game_won:
		switch_level()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		$UI/LevelCompletePanel.visible = false
		game_running = true
		get_tree().paused = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().reload_current_scene()


func _on_audio_button_pressed():
	$UI/ButtonPanel.visible = false
	$UI/AudioPanel.visible = true


func _on_video_button_pressed():
	pass


func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(_master, linear_to_db(value))


func _on_toggle_check_button_toggled(toggled_on):
	AudioServer.set_bus_mute(_master, toggled_on)


func _on_audio_back_button_pressed():
	$UI/ButtonPanel.visible = true
	$UI/AudioPanel.visible = false


func _on_show_message_timer_timeout():
	$UI/LevelNamePanel.visible = false
