extends CanvasLayer

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Reset the labels if not dead
	$ammo_label.text = "AMMO"
	$lives_label.text = "LIVES"
	$bj.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_player_health()
	update_player_ammo()
	update_player_lives()
	if player != null:
		update_face_animation(player.player_health)
	else:
		$bj.visible = false
	
func update_player_health():
	if player == null:
		# Should probably display a Game Over message here.
		$health.text = "He's dead, Jim."
		return
	$health.text = str(player.player_health) + "%"
	

func update_player_ammo():
	if player == null:
		# Hide the ammo stuff
		$ammo.text = ""
		$ammo_label.text= ""
		return

	$ammo.text = str(Global.gun_ammo)

func update_player_lives():
	if player == null:
		# Player is dead, hide stuff
		$lives.text = ""
		$lives_label.text= ""
		return
	
	# Update the player's lives
	$lives.text = str(Global.lives)
	
func update_face_animation(health):
	var animation_name = ""
	if health > 90:
		animation_name = "100"
	elif health > 75:
		animation_name = "90"
	elif health > 60:
		animation_name = "75"
	elif health > 45:
		animation_name = "60"
	elif health > 30: 
		animation_name = "45"
	elif health > 15:
		animation_name = "30"
	else:
		animation_name = "15"
	$bj.play(animation_name)
