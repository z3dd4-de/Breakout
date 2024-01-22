class_name Highscores extends Node

var list = []
var max_values: int
var min_val: int
var max_val: int
var sorted_values: Array
var last_player: String


func _init(max_vals = 10) -> void:
	max_values = max_vals
	for i in max_values:
		list.append({})
	last_player = ""


func sort() -> void:
	test_values()
	if sorted_values.is_empty():
		return
	var highscores_copy = []
	for i in max_values:
		highscores_copy.append({})
	var length = sorted_values.size()
	var i = length - 1
	var j = 0
	while i >= 0:
		var tmp_min = sorted_values[j]
		var pos = get_min_value_position(tmp_min)
		highscores_copy[i] = list[pos]
		j += 1
		i -= 1
	list = highscores_copy


func get_entry(p_name: String, p_points: int) -> Dictionary:
	return { p_name: p_points }


func add_entry(p_name: String, p_points: int) -> void:
	var values = []
	var test = test_empty()
	if test != -1:		# The first max_values entries can directly be pushed to the array
		list[test] = get_entry(p_name, p_points)
	else:				# if we have a full list, overwrite the one with min points
		if test_points(p_points):
			var pos = get_min_value_position(min_val)
			list[pos] = get_entry(p_name, p_points)
	sort()


func test_values() -> void:
	sorted_values = []
	for i in max_values:
		var dict = list[i]
		for key in dict:
			var value = dict[key]
			sorted_values.append(value)
		if !sorted_values.is_empty():
			sorted_values.sort()
			min_val = sorted_values.min()
			max_val = sorted_values.max()
		else:
			min_val = 0
			max_val = 0


func get_min_value_position(min: int) -> int:
	var pos = -1
	for i in max_values:
		var dict = list[i]
		for key in dict:
			var value = dict[key]
			if value == min:
				pos = i
	return pos


func Deserialize(file : FileAccess) -> void:
	list = file.get_var()
	last_player = file.get_pascal_string()


func Serialize(file : FileAccess) -> void:
	file.store_var(list)
	file.store_pascal_string(last_player)


func show_entries() -> void:
	print(list)


func test_points(points: int) -> bool:
	test_values()
	if points > min_val or test_empty() != -1:
		return true
	else:
		return false


func test_empty() -> int:
	var ret = -1
	for i in max_values:	# the first max_values entries can be added directly
		if list[i] == {}:
			ret = i
	return ret
