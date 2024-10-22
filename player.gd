extends CharacterBody3D


const SPEED = 8.0
const JUMP_VELOCITY = 4.5
const TURN_SPEED = 0.05

func _ready() -> void:
	$AnimatedSpriteControl/AnimatedSprite2D.animation_finished.connect(on_AnimatedSprite2D_animation_finished)

func _process(delta: float) -> void:
	
	# When user presses space, fire weapon
	if Input.is_action_just_pressed("ui_select"):
		if Global.current_weapon == "knife":
			$AnimatedSpriteControl/AnimatedSprite2D.play("knife_stab")
		
		# GUN
		elif Global.current_weapon == "gun":
			if Global.gun_ammo > 0:
				$AnimatedSpriteControl/AnimatedSprite2D.play("gun_shoot")
				Global.gun_ammo -= 1
				print("Ammo left:", Global.gun_ammo)
			else:
				Global.current_weapon = "knife"
				$AnimatedSpriteControl/AnimatedSprite2D.play("knife_idle")
				
		# MACHINE GUN
		elif Global.current_weapon == "machinegun":
			if Global.machinegun_ammo > 0:
				$AnimatedSpriteControl/AnimatedSprite2D.play("machinegun_shoot")
				Global.machinegun_ammo -= 1
				print("Ammo left:", Global.machinegun_ammo)
			else:
				if Global.gun_ammo > 0:
					Global.current_weapon = "gun"
					$AnimatedSpriteControl/AnimatedSprite2D.play("gun_idle")
				else:
					Global.current_weapon = "knife"
					$AnimatedSpriteControl/AnimatedSprite2D.play("knife_idle")
		
		# MINIGUN
		elif Global.current_weapon == "minigun":
			if Global.minigun_ammo > 0:
				$AnimatedSpriteControl/AnimatedSprite2D.play("minigun_shoot")
				Global.minigun_ammo -= 1
				print("Ammo left:", Global.minigun_ammo)
			else:
				if Global.machinegun_ammo > 0:
					Global.current_weapon = "machinegun"
					$AnimatedSpriteControl/AnimatedSprite2D.play("machinegun_idle")
				elif Global.gun_ammo > 0:
					Global.current_weapon = "gun"
					$AnimatedSpriteControl/AnimatedSprite2D.play("gun_idle")
				else:
					Global.current_weapon = "knife"
					$AnimatedSpriteControl/AnimatedSprite2D.play("knife_idle")
					
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
	if Global.current_weapon == "knife":
		$AnimatedSpriteControl/AnimatedSprite2D.play("knife_idle")
	elif Global.current_weapon == "gun":
		$AnimatedSpriteControl/AnimatedSprite2D.play("gun_idle")
	elif Global.current_weapon == "machinegun":
		$AnimatedSpriteControl/AnimatedSprite2D.play("machinegun_idle")
	elif Global.current_weapon == "minigun":
		$AnimatedSpriteControl/AnimatedSprite2D.play("minigun_idle")
