extends Control
"""
This script pauses the screen, displaying the current score and time while paused.
"""
var new_pause_state = false #Holds the current paused status of the root.

#Called when the node enters the scene tree for the first time.
func _ready()->void:
	visible = false #Make self invisible at the start of the scene.
	if get_tree().paused:
		_pause() #Unpauses when a scene is entered.
		
#Collects input events.
func _input(event:InputEvent) -> void:
	#Call ._pause().
	if event.is_action_pressed("pause"):
		_pause()
		
#Pauses the game.
func _pause() -> void:
	new_pause_state = not get_tree().paused #Change the pause state.
	get_tree().paused = not get_tree().paused #This pauses or unpauses the root when needed.
	visible = new_pause_state #Make this scene visible.
	#Display current scoring.
	$ScoreText.text = "           PAUSED:\n---------------------------------\n" + Globals.scoring("Current")

