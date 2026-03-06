class_name EnemyMaster
extends Node

@export var path: Path2D

@export var enemy_objects: Dictionary = {
	"Basic": preload("res://Objects/obj_enemy.tscn")
}

@export var enemy_schedule: EnemySchedule

var timer: float = 0.0

var enemies: Array = []
var last_enemy_check: int = 0

func _ready() -> void:
	GameMaster.set_enemy_master(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_spawn(delta)

## Spawns all enemy instances that should be spawned.
func _spawn(delta: float) -> void:
	var old_time = timer
	timer += delta
	var spawns = enemy_schedule.get_spawns(old_time, timer)
	
	if len(spawns) == 0:
		return
	
	for i in spawns:
		var e = enemy_objects[i].instantiate()
		e.path = path
		add_child(e)

## Returns an array containing all active enemies.
func get_active_enemies() -> Array:
	# If this isn't the first call this tick, just return the list
	if last_enemy_check == Time.get_ticks_msec():
		return enemies
	# Find all children that are Enemies.
	enemies = []
	var children = get_children()
	for child in children:
		if child is EnemyController:
			enemies.append(child)
	last_enemy_check = Time.get_ticks_msec() # Record the tick
	return enemies
