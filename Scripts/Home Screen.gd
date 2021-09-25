extends Control
"""
This script allows the game to be played on a clean slate.
"""

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.reset() #Resets Globals to start game on a blank slate.

