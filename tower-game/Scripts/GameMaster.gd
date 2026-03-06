extends Node

var enemy_master: EnemyMaster
var tower_master: TowerMaster
var path_master: PathMaster

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

func set_tower_master(instance: TowerMaster) -> bool:
	if tower_master == null:
		tower_master = instance
		return true
	return false
	
func get_tower_master() -> TowerMaster:
	return tower_master

func set_path_master(instance: PathMaster) -> bool:
	if path_master == null:
		path_master = instance
		return true
	return false

func get_path_master() -> PathMaster:
	return path_master

func get_enemies() -> Array:
	if enemy_master == null:
		return []
	return enemy_master.get_active_enemies()
