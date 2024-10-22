extends CharacterBody3D

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")

const SPEED = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dead = false
var is_attacking = false
var attack_range = 5

func ready() -> void:
	add_to_group("enemy")
	
func _physics_process(delta: float) -> void:
	if dead or is_attacking: # Don't do anything...
		return
		
	if player == null: # Don't do anything...
		return
	
	# Point towards player
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	
	velocity = dir * SPEED
	
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	move_and_slide()
	attack()
	
func attack() -> void:
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		return # do nothing...
	else:
		print("Player in range")
		is_attacking = true
		$AnimatedSprite3D.play("shoot")
		await $AnimatedSprite3D.animation_finished
		is_attacking = false
	
func die() -> void:
	dead = true
	$AnimatedSprite3D.play("die")
	$CollisionShape3D.disabled = true
	
	
