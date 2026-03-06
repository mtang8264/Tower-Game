class_name TowerController
extends Node2D

@export var sprite_ready: Texture2D
@export var sprite_recharging: Texture2D
@export var sprite_projectile: Texture2D

@export_range(0,1) var look_turn_lerp_amount: float = 0.25

var in_range_enemies: Array = []

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	look_at_enemy()

func get_most_progressed_enemy() -> EnemyController:
	if len(in_range_enemies) == 0:
		return null
		
	var enemy = null
	var ratio = 0.0
	
	for e in in_range_enemies:
		if enemy == null:
			enemy = e
			ratio = e.get_progress_ratio()
		elif e.get_progress_ratio() > ratio:
			enemy = e
			ratio = e.get_progress_ratio()
	
	return enemy

func look_at_enemy() -> void:
	var ideal_angle = get_look_angle_to_enemy()
	if ideal_angle == 6969:
		return
	var angle = lerp(rotation, ideal_angle, look_turn_lerp_amount)
	rotation = angle

func get_look_angle_to_enemy() -> float:
	var enemy = get_most_progressed_enemy()
	if enemy == null:
		return 6969
	
	var opp = abs(position.x - enemy.position.x)
	var adj = abs(position.y - enemy.position.y)
	
	var ang = atan(opp/adj)
	
	if enemy.position.x < position.x:
		if enemy.position.y < position.y:
			return -ang
		else:
			return (-PI) + ang
	else:
		if enemy.position.y < position.y:
			return ang
		else:
			return PI - ang

## Records when an enemy has come within detection range.
func _on_detection_area_entered(area: Area2D) -> void:
	in_range_enemies.append(area)

## Removes an enemy when it is out of detection range.
func _on_detection_area_exited(area: Area2D) -> void:
	in_range_enemies.erase(area)
