@tool
extends RigidBody2D

var points = 50
@export var x: int
@export var y: int


func _draw() -> void:
	draw_rect(Rect2(0, 0, x, y), Globals.get_color())


func _ready() -> void:
	randomize()
	#$Area2D/CollisionShape2D.position = Vector2(x/2, y/2)
	#$Area2D/CollisionShape2D.shape.extents = Vector2(x, y)
	#$CollisionShape2D.position = Vector2(x/2, y/2)
	#$CollisionShape2D.shape.extents = Vector2(x, y)


func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("ball"):
		Globals.Destroyed.emit(points)
		$Timer.start()


func _on_timer_timeout() -> void:
	self.queue_free()
	Globals.bricks -= 1
	Globals.check_level()
