extends Area2D
"""
This script controls the boundary.
"""
onready var player_path = get_tree().get_root().get_node("World").get_node("Player")#Path to player
export (Vector2) var return_position = Vector2(0,0) #Coordinate of the return position of the Player.

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered",self,"_on_Body_Entered") #Connect the 'body_entered' signal to self.

	#Call Boundaries._distribute() if self is a child of Boundaries.
	if ("Boundaries" in get_parent().name):
		get_parent()._distribute()

#Called every time a body enters the Area2D.
func _on_Body_Entered(body:Node) -> void:
	if body.name == "Player": #When the Player collides with the boundary.
		body.position = return_position #Teleport Player to return_position.
		body.velocity = Vector2.ZERO #Set Player velocity to (0,0).
		body.get_node("Hook").call_deferred("_release") #Release Hook in order to prevent being pulled after teleportation.
		
		#Remove all flying pizzas from the scene.
		for pizza in player_path.pizza_counter:
			pizza.get_node("Pizza Collector")._picked_up()


