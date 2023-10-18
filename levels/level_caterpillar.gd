extends Node
@export var mob_scene: PackedScene
@export var consumable_scene: PackedScene
@export var score_needed = 1

var score = 0

signal player_hit
signal level_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	start_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_level():
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()
	$MobTimer.start()
	$ConsumableTimer.start()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spwan_location = get_node("MobPath/MobSpawnLocation")
	mob_spwan_location.progress_ratio = randf()
	
	var direction = mob_spwan_location.rotation + PI / 2

	mob.position = mob_spwan_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction + PI / 2
	mob.name = "mob"
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)


func _on_player_hit():
	player_hit.emit()

func _on_consumable_timer_timeout():
	var leaf = consumable_scene.instantiate()
	
	var rand_x = randi_range(0, $ConsumablesSpawnArea.get_rect().size.x)
	var rand_y = randi_range(0, $ConsumablesSpawnArea.get_rect().size.y)
	
	var leaf_position = Vector2(rand_x, rand_y)
	leaf.position = leaf_position
	leaf.points = 1
	
	add_child(leaf)

func _on_player_pickup(item):
	if(item.is_in_group("consumables")):
		score += item.points
		var score_percentage = (float(score) / score_needed) * 100
		item.queue_free()
		$ProgressBar.set_value_no_signal(score_percentage)
		
		if(is_level_finished()):
			get_tree().call_group("mobs", "queue_free")
			get_tree().call_group("consumables", "queue_free")
			$Player.freeze()
			$MobTimer.stop()
			$ConsumableTimer.stop()
			level_finished.emit()

	# Safeguard, should never happen but will prevent crashes
	else:
		item.queue_free()

func is_level_finished():
	return score >= score_needed
