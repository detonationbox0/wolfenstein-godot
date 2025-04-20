extends Node3D

var is_open = false;
var is_checking = false;

func _ready():
	
	# Player enters / leaves the door area
	$TouchArea.connect("body_entered", _on_body_entered)
	$TouchArea.connect("body_exited", _on_body_exited)

# When the player is inside the door area,
# - assign the player's door object to this door,
# - let the player object know they are near the door
# - start monitoring for the player to leave
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.inside_door_area = true
		body.current_door = self
		
		# Wait for the user to leave...
		if not is_checking:
			is_checking = true # Start monitoring player for leaving
			_start_presence_check(body)

# The player is no longer by the door
# - Unset the current door on the player object
# - Let the player object know they are not near the door
func _on_body_exited(body):
	if body.is_in_group("player") and body.current_door == self:
		body.current_door = null
		body.inside_door_area = false
		
func _start_presence_check(player):
	# Initiate player check while loop
	check_loop(player)

# Every 5 seconds, check if the player is near me
# If not, close the door
func check_loop(player):
	await get_tree().create_timer(5.0).timeout
	
	if player.current_door != self:
		print("Away from door")
		is_checking = false
		if is_open == true:
			toggleDoor()
		return
		
	print("Is not away from door...")
	check_loop(player) # While loop

# Trigger door opening or closing
func toggleDoor() -> void:
	var tween = create_tween()
	var start_pos = $Door.transform.origin
	if is_open == false:
		# Open the door...
		var end_pos = start_pos + Vector3(3, 0, 0)
		is_open = true
		tween.tween_property($Door, "transform:origin", end_pos, 1.0)
	else:
		# Close the door...
		var end_pos = start_pos + Vector3(-3, 0, 0)
		is_open = false
		tween.tween_property($Door, "transform:origin", end_pos, 1.0)


	
