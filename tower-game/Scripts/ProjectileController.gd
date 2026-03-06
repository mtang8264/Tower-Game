class_name ProjectileController
extends Node2D

@export var move_speed: float = 400.0

var target: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.move_toward(target.global_position, move_speed * delta)
	rotation = get_look_angle_to_target()


func _on_area_entered(area):
	if area is EnemyController:
		area.queue_free()
		queue_free()
		
## Returns the angle in radians that the tower should be rotated to look at the enemy that is furthest progressed.
func get_look_angle_to_target() -> float:
	if target == null:
		return 6969
	
	var opp = abs(global_position.x - target.global_position.x)
	var adj = abs(global_position.y - target.global_position.y)
	
	var ang = atan(opp/adj)
	
	if target.global_position.x < global_position.x:
		if target.global_position.y < global_position.y:
			return -ang
		else:
			return (-PI) + ang
	else:
		if target.global_position.y < global_position.y:
			return ang
		else:
			return PI - ang
