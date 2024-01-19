@tool
extends CharacterBody2D

const SPEED = 800.0

@export var width: int
@export var height: int


func _draw() -> void:
	draw_rect(Rect2(Vector2(-width/2, -height/2), Vector2(width, height)), Globals.get_color())


func _ready() -> void:
	randomize()


func _physics_process(_delta) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
