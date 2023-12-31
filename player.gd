extends Area2D
signal hit
signal pickup

@export var speed = 400
@export var frozen: bool = false
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!frozen):
		move(delta)
	
func move(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x > 0

		# Adapt collisionshape to rotated sprite
		if $CollisionShape2D.rotation != (PI / 2):
			$CollisionShape2D.set_rotation(PI / 2)
			
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
		# Adapt collisionshape to rotated sprite
		if $CollisionShape2D.rotation != 0:
			$CollisionShape2D.set_rotation(0)


func _on_body_entered(body):
	if (body.is_in_group('mobs')):
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred('disabled', true)
	if (body.is_in_group('consumables')):
		pickup.emit(body)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func freeze():
	frozen = true
