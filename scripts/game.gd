extends Node2D

# Magic numbers
const MAX_WIDTH = 1920
const MAX_HEIGHT = 1080
const HIGHSCORE_ENTRIES = 10

var game_running = false
var points = 0
var level = 1
var max_level = 10
var game_won = false
var level_name = ""
@onready var ball = $Ball
@onready var _master = AudioServer.get_bus_index("Master")
var player_pos: Vector2

var highscore: Highscores

# Labels
var name_labels = []
var level_labels = []
var point_labels = []
@onready var name_1_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Name1Label
@onready var lvl_1_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Lvl1Label
@onready var points_1_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Points1Label
@onready var name_2_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Name2Label
@onready var lvl_2_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Lvl2Label
@onready var points_2_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Points2Label
@onready var name_3_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Name3Label
@onready var lvl_3_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Lvl3Label
@onready var points_3_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Points3Label
@onready var name_4_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Name4Label
@onready var lvl_4_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Lvl4Label
@onready var points_4_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Points4Label
@onready var name_5_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Name5Label
@onready var lvl_5_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Lvl5Label
@onready var points_5_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Points5Label
@onready var name_6_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Name6Label
@onready var lvl_6_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Lvl6Label
@onready var points_6_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Points6Label
@onready var name_7_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Name7Label
@onready var lvl_7_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Lvl7Label
@onready var points_7_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Points7Label
@onready var name_8_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Name8Label
@onready var lvl_8_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Lvl8Label
@onready var points_8_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Points8Label
@onready var name_9_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Name9Label
@onready var lvl_9_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Lvl9Label
@onready var points_9_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Points9Label
@onready var name_10_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Name10Label
@onready var lvl_10_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Lvl10Label
@onready var points_10_label = $UI/HighscoresPanel/VBoxContainer/MarginContainer/GridContainer/Points10Label

# SaveLoad variables
var m_Password = "R4nd0m_p455w0Rd"
var m_GameStateFile = "user://breakout.dat"       # File path to the saved game state


func _ready():
	Globals.Destroyed.connect(update_points)
	Globals.LevelCompleted.connect(check_level_complete)
	randomize()
	SaveLoadHighscores.Initialize(m_GameStateFile, m_Password)
	open_save_game()
	get_tree().paused = true
	$Player.position.x = MAX_WIDTH/2
	player_pos = $Player.position
	name_labels = [name_1_label, name_2_label, name_3_label, name_4_label, name_5_label, name_6_label, name_7_label, name_8_label, name_9_label, name_10_label]
	level_labels = [lvl_1_label, lvl_2_label, lvl_3_label, lvl_4_label, lvl_5_label, lvl_6_label, lvl_7_label, lvl_8_label, lvl_9_label, lvl_10_label]
	point_labels = [points_1_label, points_2_label, points_3_label, points_4_label, points_5_label, points_6_label, points_7_label, points_8_label, points_9_label, points_10_label]
	$UI/AddHighscorePanel/VBoxContainer/PlayernameLineEdit.text = highscore.last_player
	build_highscore_list()


func build_highscore_list():
	var i = 0
	for entry in highscore.list:
		if !entry.is_empty():
			var dict = entry
			for key in dict:
				var value = dict[key]
				var level = key.split(";")
				print(level)
				name_labels[i].text = level[0]
				level_labels[i].text = level[1]
				point_labels[i].text = str(value)
				name_labels[i].visible = true
				level_labels[i].visible = true
				point_labels[i].visible = true
		else:
			name_labels[i].visible = false
			level_labels[i].visible = false
			point_labels[i].visible = false
		i += 1


func open_save_game():
	var status = SaveLoadHighscores.OpenFile(FileAccess.READ)		# Open the file with READ access
	if status != OK:
		highscore = Highscores.new(HIGHSCORE_ENTRIES)
		highscore.last_player = "Playername"
		print("Unable to open the file %s. Received error: %d" % [m_GameStateFile, status])
	else:
		highscore = Highscores.new(HIGHSCORE_ENTRIES)
		SaveLoadHighscores.Deserialize(highscore)
		SaveLoadHighscores.CloseFile()


func write_save_game():
	var status = SaveLoadHighscores.OpenFile(FileAccess.WRITE)
	if status != OK:
		print("Unable to open the file %s. Received error: %d" % [m_GameStateFile, status])
		return
	SaveLoadHighscores.Serialize(highscore)
	SaveLoadHighscores.CloseFile()


func _exit_tree():
	write_save_game()
	SaveLoadHighscores.Clear()


func _process(_delta):
	# Bugfix: if Player is below original position, the y-position will be reset to original position
	if $Player.position.y != player_pos.y:
		$Player.position.y = player_pos.y


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
		7:
			level_7()
		8:
			level_8()
		9:
			level_9()
		10:
			level_10()
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
		$UI/LevelCompletePanel/VBoxContainer/AddHighscoreButton2.visible = false
	else:
		$UI/LevelCompletePanel/VBoxContainer/LevelCompletedLabel.text = "Game won!\nDo you want to start again?"
		$UI/LevelCompletePanel/VBoxContainer/NextLevelButton.text = "New Game"
		$UI/LevelCompletePanel/VBoxContainer/AddHighscoreButton2.visible = true
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
			get_tree().get_current_scene().add_child(br)
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
	get_tree().get_current_scene().add_child(br)


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
			get_tree().get_current_scene().add_child(br)
	ball.velocity = Vector2(500, 500)


func level_4():		# 4 Circles
	level_name = "4 Circles"
	Globals.bricks = 0
	var x = MAX_WIDTH/2
	var y = 350
	var radius = 280
	var brick_count = 12
	var angle_in_degrees = 0
	for i in brick_count:
		var br = preload("res://scenes/brick.tscn").instantiate()
		br.scale = Vector2(2, 2)
		br.points = 75
		br.position = Vector2(x + radius * cos(deg_to_rad(angle_in_degrees)), y + radius * sin(deg_to_rad(angle_in_degrees)))
		get_tree().get_current_scene().add_child(br)
		angle_in_degrees += 30
		Globals.bricks += 1
		
	x = 1920/3
	y = 400
	for i in brick_count:
		var br = preload("res://scenes/brick.tscn").instantiate()
		br.scale = Vector2(2, 2)
		br.points = 75
		br.position = Vector2(x + radius * cos(deg_to_rad(angle_in_degrees)), y + radius * sin(deg_to_rad(angle_in_degrees)))
		get_tree().get_current_scene().add_child(br)
		angle_in_degrees += 30
		Globals.bricks += 1
	
	x = 1920/4 - 100
	y = 300
	for i in brick_count:
		var br = preload("res://scenes/brick.tscn").instantiate()
		br.scale = Vector2(2, 2)
		br.points = 75
		br.position = Vector2(x + radius * cos(deg_to_rad(angle_in_degrees)), y + radius * sin(deg_to_rad(angle_in_degrees)))
		get_tree().get_current_scene().add_child(br)
		angle_in_degrees += 30
		Globals.bricks += 1
	
	x = MAX_WIDTH - 400
	y = 300
	for i in brick_count:
		var br = preload("res://scenes/brick.tscn").instantiate()
		br.scale = Vector2(2, 2)
		br.points = 75
		br.position = Vector2(x + radius * cos(deg_to_rad(angle_in_degrees)), y + radius * sin(deg_to_rad(angle_in_degrees)))
		get_tree().get_current_scene().add_child(br)
		angle_in_degrees += 30
		Globals.bricks += 1
	ball.position = Vector2(MAX_WIDTH/2, 900)
	$Player.position.x = MAX_WIDTH/2


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
			get_tree().get_current_scene().add_child(br)
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
		get_tree().get_current_scene().add_child(br)
		Globals.bricks += 1
	ball.velocity = Vector2(700, 700)


func level_7():
	level_name = "Stacking bricks"
	Globals.bricks = 0
	var brick_count = 48
	var lines = 8
	var bricks_per_line = brick_count/lines
	var x = 50
	var y = 50
	for i in lines:
		x = 50
		for j in bricks_per_line:
			var br = preload("res://scenes/brick.tscn").instantiate()
			br.scale = Vector2(4, 4)
			br.position = Vector2(x, y)
			get_tree().get_current_scene().add_child(br)
			Globals.bricks += 1
			x += 300
		y += 30
	ball.velocity = Vector2(500, 500)


func level_8():
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
			get_tree().get_current_scene().add_child(br)
			Globals.bricks += 1
			x += 150
		y += 30
	ball.velocity = Vector2(600, 500)


func level_9():
	level_name = "You can't destroy them all"
	Globals.bricks = 0
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
			get_tree().get_current_scene().add_child(ub)
			x += 150
		else:
			var br = preload("res://scenes/brick.tscn").instantiate()
			br.scale = Vector2(3, 3)
			br.position = Vector2(randi_range(x, 1500), y)
			get_tree().get_current_scene().add_child(br)
			Globals.bricks += 1
			
		y += 50
	ball.velocity = Vector2(600, 600)


func level_10():
	level_name = "The Rectangle"
	Globals.bricks = 0
	var lines = 11
	var x = 150
	var y = 50
	for i in lines:
		x = 150
		var bricks_per_line = 2
		if i == 0 or i == 10:
			bricks_per_line = 11
		else:
			bricks_per_line = 2
		if i == 5:
			var x_k = 400
			for k in 7:
				var ub = preload("res://scenes/indestructible_brick.tscn").instantiate()
				ub.scale = Vector2(3, 3)
				ub.position = Vector2(x_k, y)
				get_tree().get_current_scene().add_child(ub)
				x_k += 150
		for j in bricks_per_line:
			var br = preload("res://scenes/brick.tscn").instantiate()
			br.scale = Vector2(3, 3)
			br.position = Vector2(x, y)
			if i == 0 or i == 10:
				x += 150
			else:
				x += 1500
			get_tree().get_current_scene().add_child(br)
			Globals.bricks += 1
		y += 50
	ball.velocity = Vector2(500, 500)


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
	$UI/ButtonPanel.visible = false
	$UI/VideoPanel.visible = true


func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(_master, linear_to_db(value))


func _on_toggle_check_button_toggled(toggled_on):
	AudioServer.set_bus_mute(_master, toggled_on)


func _on_audio_back_button_pressed():
	$UI/ButtonPanel.visible = true
	$UI/AudioPanel.visible = false


func _on_show_message_timer_timeout():
	$UI/LevelNamePanel.visible = false


func _on_video_back_button_pressed():
	$UI/ButtonPanel.visible = true
	$UI/VideoPanel.visible = false


func _on_vsync_check_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_borderless_check_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)


func _on_fullscreen_check_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_highscores_button_pressed():
	$UI/HighscoresPanel.visible = true
	$UI/ButtonPanel.visible = false


func _on_highscores_back_button_pressed():
	$UI/HighscoresPanel.visible = false
	$UI/ButtonPanel.visible = true


func _on_add_highscore_button_pressed():
	var player = $UI/AddHighscorePanel/VBoxContainer/PlayernameLineEdit.text
	$UI/AddHighscorePanel/VBoxContainer/LevelLabel.text = "Level " + str(level)
	var lvl = $UI/AddHighscorePanel/VBoxContainer/LevelLabel.text
	var point = int($UI/AddHighscorePanel/VBoxContainer/PointsLabel.text)
	var player_lvl = player + ";" + "Level " + str(level)
	highscore.add_entry(player_lvl, point)
	#highscore.show_entries()
	build_highscore_list()
	highscore.last_player = str(player)
	$UI/AddHighscorePanel.visible = false
	$UI/ButtonPanel.visible = true
	level = 1
	points = 0
	Globals.bricks = 0
	get_tree().reload_current_scene()


func _on_add_highscore2_button_pressed():
	$UI/GameOverPanel.visible = false
	$UI/AddHighscorePanel.visible = true
	$UI/AddHighscorePanel/VBoxContainer/PlayernameLineEdit.text = highscore.last_player
	$UI/AddHighscorePanel/VBoxContainer/PointsLabel.text = str(points)
	$UI/AddHighscorePanel/VBoxContainer/LevelLabel.text = "Level " + str(level)
