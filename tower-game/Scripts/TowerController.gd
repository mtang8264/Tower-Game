class_name TowerController
extends Node2D

@export var sprite_ready: Texture2D
@export var sprite_recharging: Texture2D
@export var sprite_projectile: Texture2D

@export_range(0,1) var look_turn_lerp_amount: float = 0.15

@export var time_to_shoot: float = 0.5
@export var recharge_time: float = 1.5

@onready var sprite2d: Sprite2D = find_child("Sprite2D")

var projectile_obj = preload("res://Objects/obj_projectile.tscn")

enum TowerState {READY, RECHARGING}
@export var state: TowerState = TowerState.READY
var visible_enemies: Array = []
var in_range_enemies: Array = []

var shoot_timer: float = 0.0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	look_at_enemy()
	_shoot(delta)
	_sprite_change()

func _sprite_change() -> void:
	match state:
		TowerState.READY:
			sprite2d.texture = sprite_ready
		TowerState.RECHARGING:
			sprite2d.texture = sprite_recharging
	pass

func _shoot(delta: float) -> void:
	if state == TowerState.READY and len(in_range_enemies) > 0:
		shoot_timer += delta
		if shoot_timer >= time_to_shoot:
			state = TowerState.RECHARGING
			shoot_timer = 0.0
			var p = projectile_obj.instantiate()
			add_child(p)
			p.target = get_most_progressed_enemy()
	elif state == TowerState.RECHARGING:
		shoot_timer += delta
		if shoot_timer >= recharge_time:
			state = TowerState.READY
			shoot_timer = 0.0
	pass

## Returns the EnemyController of the enemy that is further along its path by percentage.
## Returns null if there are no enemies in range.
func get_most_progressed_enemy() -> EnemyController:
	if len(visible_enemies) == 0:
		return null
	
	var enemy = null
	var ratio = 0.0
	for e in visible_enemies:
		if enemy == null:
			enemy = e
			ratio = e.get_progress_ratio()
		elif e.get_progress_ratio() > ratio:
			enemy = e
			ratio = e.get_progress_ratio()
	return enemy

## Turns the Sprite2D child of the tower to look at the enemy that is further progressed.
func look_at_enemy() -> void:
	var ideal_angle = get_look_angle_to_enemy()
	if ideal_angle == 6969:
		return
	var angle = lerp(sprite2d.rotation, ideal_angle, look_turn_lerp_amount)
	sprite2d.rotation = angle

## Returns the angle in radians that the tower should be rotated to look at the enemy that is furthest progressed.
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
	visible_enemies.append(area)

## Removes an enemy when it is out of detection range.
func _on_detection_area_exited(area: Area2D) -> void:
	visible_enemies.erase(area)


func _on_fire_area_entered(area: Area2D) -> void:
	in_range_enemies.append(area)


func _on_fire_area_exited(area: Area2D) -> void:
	in_range_enemies.erase(area)
