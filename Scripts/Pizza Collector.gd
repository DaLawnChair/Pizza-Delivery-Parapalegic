extends Area2D
"""
This script allows the pizza to be collected and removed of.
"""
onready var stage_path = get_parent().get_parent() #Path to the Stage (the parent of Pizza).
onready var player_path = stage_path.get_node("Player") #Path to Player.
onready var hook_path = player_path.get_node("Hook") #Path to Hook.

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered",self,"_on_Body_Entered") #Connect "body_entered" signal to self.

#Called when a body enters self. Calls ._picked_up(). 
func _on_Body_Entered(body: Node) -> void:
	_picked_up()

#Picks up Pizza.
func _picked_up() -> void:
	player_path.pizza_count += 1 #Increases Player.pizza_count.
	hook_path.item_picked_up = true #Notifies Hook that the Pizza is picked up.
	#Issues may arise when pizza_count is increased at the same time the pizza is removed. 
	call_deferred("_remove")

#Removes Pizza.
func _remove() -> void:
	#Removes the pizza from the Stage.
	stage_path.remove_child(get_parent())
	#Removes the pizza from Player.pizza_array.
	player_path.pizza_counter.erase(get_parent())
	
