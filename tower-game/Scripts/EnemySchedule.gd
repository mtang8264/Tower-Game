class_name EnemySchedule
extends Resource

## The schedule of enemies. This is a Dictionary where the key is a float representing the time of
## the spawn and the value is a String representing the enemy type as represented in the EnemyMaster
## enemy_objects Dictionary.
@export var schedule: Dictionary

## A function that returns an Array containing all of the enemy spawns that should occur during a
## given time frame.
func get_spawns(last_time, current_time) -> Array:
	var spawns = []
	var keys = []
	
	for k in schedule.keys():
		if k > last_time and k <= current_time:
			spawns.append(schedule[k])
	
	return spawns
