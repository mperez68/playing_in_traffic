extends RigidBody2D

var accel = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	name = "Mob"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if linear_velocity.length() < 150:
		accel = true
	elif linear_velocity.length() > 300:
		accel = false
	
	if accel:
		var velocity = Vector2(1, 0)
		linear_velocity += velocity.rotated(rotation)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
