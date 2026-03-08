class_name EnemySchedule
extends Resource

## The schedule of enemies. This is a Dictionary where the key is a float representing the time of
## the spawn and the value is a String representing the enemy type as represented in the EnemyMaster
## enemy_objects Dictionary.
@export var schedule: Dictionary

## An array which represents enemies that should be spawned continually at a fixed interval.
## Each array should have either 2 or 3 entries on start.
## [0] should be a float representing the time interval at which the enemies should be spawned.
## [1] should be a string representing the enemy type to spawn.
## [2], if present, should be an integer representing how many spawns this entry is allowed to cause.
@export var recurring: Array

## A function that returns an Array containing all of the enemy spawns that should occur during a
## given time frame.
func get_spawns(last_time, current_time) -> Array:
	var spawns = []
	var keys = []
	
	# Fixed spawns
	for k in schedule.keys():
		if k > last_time and k <= current_time:
			spawns.append(schedule[k])
	
	# Recurring spawns
	for r in recurring:
		# If there aren't at least 2 entries in the array something is wrong.
		if len(r) < 2:
			continue
		# Check if the entry has a limit that has been met
		if len(r) == 4 and r[3] >= r[2]:
			continue
		# Figure out the time since the last frame.
		var l_full_cycles = floor(last_time / r[0])
		var l_overflow = last_time - (l_full_cycles * r[0])
		var c_full_cycles = floor(current_time / r[0])
		var c_overflow = current_time - (c_full_cycles * r[0])
		# If the current time is before the last time it means the interval for the spawn has
		# already happened and the enemy should be spawned.
		if c_overflow < l_overflow:
			spawns.append(r[1])
			# Record the spawn if the entry has a limit.
			if len(r) == 3:
				r.append(1)
			elif len(r) == 4:
				r[3] = r[3] + 1
	
	return spawns
