extends Area2D

signal hit
signal grab

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play()
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if velocity.length() > 0:
		velocity = velocity * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.length() != 0:
		$AnimatedSprite2D.rotation = velocity.angle()
		$AnimatedSprite2D.animation = "walk"
		
	else:
		$AnimatedSprite2D.animation = "stand"

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body):
	print("Player colliding with " + body.name)
	if body.name.contains("Mob"):
		hide() # Player disappears after being hit.
		hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
		
	if body.name.contains("ScoreToken"):
		body.queue_free()
		$PickupSound.play()
		grab.emit()
	
