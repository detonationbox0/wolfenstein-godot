extends CanvasLayer

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_player_health()

func update_player_health():
	if player == null:
		# Should probably display a Game Over message here.
		$health.text = "He's dead, Jim."
		return
	$health.text = str(player.player_health) + "%"
