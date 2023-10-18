extends Node
@export var mob_scene: PackedScene
@export var consumable_scene: PackedScene
var score
var score_threshold = 3
var level = 1
var level_instance: Node
@onready var main_2d: Node = $Main2D
@onready var level_finished_sound: AudioStreamPlayer2D = $LevelFinished


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$DeathSound.play()
	$HUD.show()
	$HUD.show_game_over()
	unload_level()


func unload_level():
	if(is_instance_valid(level_instance)):
		level_instance.queue_free()
		level_instance = null


func load_level():
	var level_name = "level_caterpillar"
	var level_path = "res://levels/%s.tscn" % level_name
	var level_resource := load(level_path)
	
	if(level_resource):
		level_instance = level_resource.instantiate()
		level_instance.player_hit.connect(_on_player_hit)
		level_instance.level_finished.connect(_on_level_finished)
		level_instance.score_needed = level * 3
		main_2d.add_child(level_instance)


func new_game():
	$HUD.hide_message()
	load_level()


func _on_player_hit():
	# This is just a stup for later
	var lifes = 1
	lifes -= 1
	
	if(lifes == 0):
		game_over()


func _on_level_finished():
	$HUD.show_level_finished()
	level_finished_sound.play()
	level += 1
	unload_level()
