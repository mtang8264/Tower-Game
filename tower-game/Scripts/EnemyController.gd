class_name EnemyController
extends Node2D

## The speed, in pixels, that the enemy moves per second.
@export var move_speed: float = 200.0
## The Path2D instance that the enemy should follow.
@export var path: Path2D
## The PathFollow2D object, as a PackedScene, which the enemy will spawn to follow.
var path_follow_object: PackedScene = preload("res://Objects/obj_enemyPathFollow.tscn")

## The PathFollow2D instance the enemy is following.
var path_follow: PathFollow2D
## The enemies progress, in pixels, along the path.
var progress: float = 0.0
## The percentage of the path that the enemy had cleared last frame.
## Used to check when the enemy has completed its path.
var last_progress_ratio: float = -1

var spawn_timestamp: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_path_follower()
	spawn_timestamp = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_move(delta)

## Spawns the PathFollow2D instance required for the enemy to know where to stand.
func _spawn_path_follower() -> void:
	path_follow = path_follow_object.instantiate()
	path.add_child(path_follow)
	path_follow.progress = 0.0
	position = path_follow.position

## Moves the enemy along its path.
func _move(delta: float) -> void:
	progress += delta * move_speed
	path_follow.progress = progress
	position = path_follow.position
	rotation = path_follow.rotation
	
	# Check if the enemy has reached the end of its path.
	# If it hasn't then it just records how far it is on the path to check against next frame.
	if path_follow.progress_ratio < last_progress_ratio:
		_reached_path_end()
	else:
		last_progress_ratio = path_follow.progress_ratio

## Runs all code appropriate when the enemy reaches the end of its path.
func _reached_path_end() -> void:
	path_follow.queue_free()
	queue_free()

func get_progress_ratio() -> float:
	return path_follow.progress_ratio
