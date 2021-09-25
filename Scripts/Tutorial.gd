extends Node2D
"""
This script gives the player extra pizzas to complete the tutorial.
"""
#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.pizza_count = 100 #Give Player 100 pizzas.

