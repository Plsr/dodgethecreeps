extends RigidBody2D

@export var points = 1
@export var despawn_time_s = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = despawn_time_s
	$Timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start(pos):
	position = pos
	show()



func _on_timer_timeout():
	queue_free()
