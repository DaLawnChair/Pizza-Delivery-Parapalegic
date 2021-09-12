extends StaticBody2D
"""
This script allows for scoring.
"""

var already_scored = false #Allows the house to be scored on once.
		
#Increases the score when a pizza is delivered to the house.
func add_score() -> void:
	already_scored = true #Prevents the house to be scored again (in Pizza.gd)
	Globals.player_score += 100 #Increases the .player_score.
	$Score.play() #Plays the 'Score' sound.

