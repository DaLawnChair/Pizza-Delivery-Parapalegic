extends Node
"""
This script controls the Boundaries node.
"""
onready var player_path = get_tree().get_root().get_node("World").get_node("Player") #Path to player
export (Vector2) var return_position = Vector2(0,0) #Coordinate of the return position of the Player.

#Distribute .return_position to each of the boundary child nodes.return_position in self.
func _distribute() -> void:	
	for boundaries in self.get_children():
		boundaries.return_position = return_position

