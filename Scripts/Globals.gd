extends Node
"""
This script holds the global variables and its functions.
"""
var time = 0.0 #Stages Play time.
var player_score = 0 #Player's score.
var score = 0 #The current score of run.

#Resets the global variables. 
func reset() -> void:
	time = 0.0
	player_score = 0
	score = 0

#Calculates .score and returns this scripts variables.
func scoring(type: String) -> String:
	if time > 0: #Calculates .score.
		score = player_score / time
	else: #Prevents division by zero.
		score = 0
	return "Player Score: " + str(Globals.player_score) + "\nTime: " \
	+ str(stepify(Globals.time,0.1)) + "\n"+type+" Score: " + str(stepify(score,0.1))

