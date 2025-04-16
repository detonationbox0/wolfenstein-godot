extends CharacterBody3D


const SPEED = 8.0
const JUMP_VELOCITY = 4.5
const TURN_SPEED = 0.05

var time_since_last_shot = 0.0
var fire_rate = 1.0
var can_shoot = true

@onready var ray = $Camera3D/RayCast3D

var player_health = 100

func _ready() -> void:
	add_to_group("player")
	$AnimatedSpriteControl/AnimatedSprite2D.animation_finished.connect(on_AnimatedSprite2D_animation_finished)
	$AnimatedSpriteControl/AnimatedSprite2D.play(Global.current_weapon + "_idle")

func _process(delta: float) -> void:
	
	# Fire rate logic
	time_since_last_shot += delta
	can_shoot = time_since_last_shot >= (1.0 / fire_rate)
	
	# Switch to Knife when out of ammo
	if Global.current_weapon != "knife" and Global.gun_ammo <= 0:
		Global.current_weapon = "knife"
		$AnimatedSpriteControl/AnimatedSprite2D.play("knife_idle")
	
	# When user presses space, and cool down is over, fire weapon
	if Input.is_action_pressed("ui_select") and can_shoot:
		if Global.current_weapon == "knife":
			$AnimatedSpriteControl/AnimatedSprite2D.play("knife_stab")
		else:
			$AnimatedSpriteControl/AnimatedSprite2D.play(Global.current_weapon + "_shoot")
		
		# Reset cool down
		time_since_last_shot = 0
		
		if Global.current_weapon != "knife":
			# Expend ammo
			if Global.gun_ammo > 0:
				Global.gun_ammo -= 1
			print("Ammo left:", Global.gun_ammo)
		
		# Set fire_rate based on current weapon
		match Global.current_weapon:
			"gun":
				fire_rate = 3.0
			"machinegun":
				fire_rate = 6.0
			"minigun":
				fire_rate = 10.0
			"knife":
				fire_rate = 2.0
			_:
				fire_rate = 1.0

		shoot()

func _physics_process(delta: float) -> void:

	# Add the user's gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if Input.is_action_pressed("Left"):
		self.rotate_y(TURN_SPEED)
	if Input.is_action_pressed("Right"):
		self.rotate_y(-TURN_SPEED)

	move_and_slide()

func on_AnimatedSprite2D_animation_finished() -> void:
	$AnimatedSpriteControl/AnimatedSprite2D.play(Global.current_weapon + "_idle")
	
func shoot() -> void:
	if ray.is_colliding() && ray.get_collider().has_method("die"):
		ray.get_collider().die()
		
func damage() -> void:
	player_health -= 10
	if player_health <= 0:
		if Global.lives <= 1:
			queue_free()
		else:
			Global.lives -= 1
			# Restart game, minus one life
			get_tree().change_scene_to_file("res://world.tscn")
