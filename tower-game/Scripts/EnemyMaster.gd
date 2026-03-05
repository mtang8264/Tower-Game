extends Node

@export var path: Path2D

@export var enemy_objects: Dictionary = {
	"Basic": preload("res://Objects/obj_enemy.tscn")
}

@export var enemy_schedule: EnemySchedule

var timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
