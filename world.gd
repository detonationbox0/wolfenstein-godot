extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Global.current_floor = 2
		get_tree().change_scene_to_file("res://floor_2.tscn")
