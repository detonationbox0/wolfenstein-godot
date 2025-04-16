extends Area3D



func _on_body_entered(body: Node3D) -> void:
	# If the colliding body is the player
	if body.is_in_group("player"):
		# Add 20 to the player's health
		body.player_health += 20
		# Delete health from the world
		queue_free()
		
