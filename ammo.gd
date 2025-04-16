extends Area3D

func _on_body_entered(body: Node3D) -> void:
	# Is the body a player or NPC?
	if body.is_in_group("player"):
		# Add 10 to the global 'gun_ammo' variable
		Global.gun_ammo += 10
		
		# Add to queue to delete this ammo from world
		queue_free()
