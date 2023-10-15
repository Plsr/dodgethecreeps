extends Node
@export var mob_scene: PackedScene
@export var consumable_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	$ConsumableTimer.stop()
	
func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get ready!")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()


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

func _on_start_timer_timeout():
	$MobTimer.start()
	$ConsumableTimer.start()


# TODO: Spawn at random position inside spawn area
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
		$HUD.update_score(score)
		item.queue_free()
	# Safeguard, should never happen but will prevent crashes
	else:
		item.queue_free()
