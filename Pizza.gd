extends KinematicBody2D

"""
This script controls Pizza.
"""
onready var player_path = get_parent().get_node("Player") #Path to the Player.
const SPEED = 3 #Speed of the Pizza.

var velocity = Vector2() #Velocity of the Pizza.
var collision #Movement and collision of the Pizza.
var flying = false #The flying status (has it hit anything yet) of the Pizza. 

#Update physics every frame.
func _physics_process(delta: float) -> void:
	#Moves the Pizza and detects collisions.
	collision = move_and_collide(velocity.normalized() * SPEED)
	if collision: #Once the Pizza has collided with something...
		$"Pizza Collector".monitoring = true #Allow the Pizza to be picked up by Player.
			
		if collision.collider.name == "Grapple": #Do nothing when it collides with Grapple from Hook.
			pass
		else: #When colliding with a building(Store and House) or terrain...
			if "House" in collision.collider.name: #If collding with a House...
				if collision.collider.already_scored == false: 
					#If you can score on the house, call that House's .add_score() and Pizza Collector's ._remove().
					collision.get_collider().add_score()
					$"Pizza Collector".call_deferred("_remove") 
	
			velocity.x = 0 #Stop horizontal motion.
			#Let the pizza fall down .
			if velocity.y < 0:
				velocity.y = -0.2 * velocity.y




