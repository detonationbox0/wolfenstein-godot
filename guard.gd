extends CharacterBody3D

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var ray = $RayCast3D

const SPEED = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dead = false
var is_attacking = false
var attack_range = 20

func _ready() -> void:
	add_to_group("enemy")
	# ray.cast_to = Vector3(0, 0, -1) * 10
	
func _physics_process(delta: float) -> void:
	if dead or is_attacking: # Don't do anything...
		return
		
	if player == null: # Don't do anything...
		return
	
	# Move towards player at SPEED
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	velocity = dir * SPEED
	
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	look_at(player.global_position)
	move_and_slide()
	attack()
	
func attack() -> void:
	
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		$AnimatedSprite3D.play("default")
		return
	else:
		is_attacking = true
		$AnimatedSprite3D.play("shoot")
			
	if ray.is_colliding() and ray.get_collider().has_method("damage"):
		print("DAMAGING...")
		ray.get_collider().damage()
		
	await $AnimatedSprite3D.animation_finished
	is_attacking = false
	
func die() -> void:
	dead = true
	$AnimatedSprite3D.play("die")
	$CollisionShape3D.disabled = true
	
	
