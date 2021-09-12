extends Area2D
"""
This script controls the boundary.
"""
var start_position = Vector2() #start position.
export var start_position_x = 0 #x coordinate of start position chosen in the inspector.
export var start_position_y = 0 #y coordinate of start position chosen in the inspector.
onready var player_path = get_parent().get_parent().get_node("Player") #Path to player

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered",self,"_on_Body_Entered") #Connect the 'body_entered' signal to self.
	start_position = Vector2(start_position_x,start_position_y) #Set start_position to the specified x and y values.

#Called every time a body enters the Area2D.
func _on_Body_Entered(body:Node) -> void:
	if body.name == "Player": #When the Player collides with the boundary.
		body.position = start_position #Teleport Player to start_position
		body.velocity = Vector2.ZERO #Set Player velocity to (0,0)
		body.get_node("Hook").hooked = false #Make Hook.hooked false to prevent being pulled after teleportation.
		
		#Remove all flying pizzas from the scene
		for pizza in player_path.pizza_counter:
			pizza.get_node("Pizza Collector")._picked_up()

