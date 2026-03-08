class_name ProjectileController
extends Node2D

@export var move_speed: float = 400.0

enum ProjectileMode {DIRECTIONAL, TARGETED}
var mode: ProjectileMode

var direction: Vector2
var target: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_move(delta)

func initialize(_mode: ProjectileMode, _arg, _speed: float = 600):
	mode = _mode
	
	match mode:
		ProjectileMode.DIRECTIONAL:
			if typeof(_arg) != TYPE_VECTOR2:
				return
			direction = _arg
			rotation = get_look_angle_to_target()
		ProjectileMode.TARGETED:
			if typeof(_arg) != TYPE_OBJECT:
				return
			target = _arg
			rotation = get_look_angle_to_direction()

	move_speed = _speed

func _move(delta: float):
	match mode:
		ProjectileMode.TARGETED:
			global_position = global_position.move_toward(target.global_position, move_speed * delta)
			rotation = get_look_angle_to_target()
		ProjectileMode.DIRECTIONAL:
			global_position = global_position + (direction.normalized() * move_speed * delta)
			rotation = get_look_angle_to_direction()

func _on_area_entered(area):
	if area is EnemyController:
		area.queue_free()
		queue_free()
		
## Returns the angle in radians that the tower should be rotated to look at the enemy that is furthest progressed.
func get_look_angle_to_target() -> float:
	if target == null:
		return 0
	
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

func get_look_angle_to_direction() -> float:
	if direction == null:
		return 0
	var opp = abs(direction.x)
	var adj = abs(direction.y)
	
	var ang = atan(opp/adj)
	
	if direction.x < 0:
		if direction.y < 0:
			return -ang
		else:
			return (-PI) + ang
	else:
		if direction.y < 0:
			return ang
		else:
			return PI - ang
