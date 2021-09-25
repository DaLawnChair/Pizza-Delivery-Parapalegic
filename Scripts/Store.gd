extends Area2D
"""
This script is for Store which changes scenes.
"""
export var reference_path = "" #Variable is exported to connect a reference path throught the inspector.
onready var player_path = get_parent().get_node("Player") #Path to Player.

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered",self,"_on_Body_Entered") #Connect the 'body_entered' signal to self.

#Change to the next scene when the player reaches this checkpoint.
func _on_Body_Entered(body:Node) -> void:
	if body.name == "Player": #If the Player enters self...
		if (reference_path != ""):
			#Change scenes.
			get_tree().change_scene(reference_path)
			#Garbage collect the pizzas in Player.pizza_collector.
			player_path.pizza_counter = []
		else:
			#Default stores to change scene to the end screen.
			get_tree().change_scene("res://Stages/End Screen.tscn")

