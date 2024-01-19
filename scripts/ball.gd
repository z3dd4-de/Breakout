@tool
extends CharacterBody2D


func _draw():
	draw_circle(Vector2(0, 0), 30.0, Color.RED)


func _ready():
	velocity = Vector2(400, 400)


func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
