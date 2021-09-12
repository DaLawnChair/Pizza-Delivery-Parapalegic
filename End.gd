extends Control
"""
This script displays the end screen scene.
"""
var final_score = Globals.player_score / Globals.time #Calculate .final_score.
#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused #Pause the scene
	#Display .final_score and Globals' variables.
	$"ScoreText".text = "     Levels Complete:\n---------------------------------\n" + Globals.scoring("\nFinal")

	


