extends Node

@export var mob_scene: PackedScene
@export var smear_scene: PackedScene
@export var score_token_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	var smear = smear_scene.instantiate()
	smear.position = $Player.position
	add_child(smear)
	
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func grab_token():
	score += 1;
	$HUD.update_score(score)

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	$MobTimer.wait_time = 0.5
	
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("tokens", "queue_free")


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0) * (1 + (0.05 * score)), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
	if $MobTimer.wait_time > 0.1:
		$MobTimer.wait_time *= 0.99


func _on_score_timer_timeout():
	score += 1
	if score % 5 == 0 && score != 0:
		var token = score_token_scene.instantiate()
		token.position = Vector2(randf_range(30, 1092), randf_range(30, 588))
		add_child(token)
	
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
