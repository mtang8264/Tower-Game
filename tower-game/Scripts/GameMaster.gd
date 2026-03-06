extends Node

var enemy_master: EnemyMaster

## Sets the EnemyMaster for the game.
## Returns true if it was set.
## Returns false if there was already an EnemyMaster set.
func set_enemy_master(instance: EnemyMaster) -> bool:
	if enemy_master == null:
		enemy_master = instance
		return true
	return false

func get_enemy_master() -> EnemyMaster:
	return enemy_master

func get_enemies() -> Array:
	if enemy_master == null:
		return []
	return enemy_master.get_active_enemies()
