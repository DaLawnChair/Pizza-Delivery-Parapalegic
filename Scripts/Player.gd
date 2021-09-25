extends KinematicBody2D
"""
This script controls the players' movement, visuals, and throwing of objects.
"""

const pizza_path = preload("res://Interactives/Pizza.tscn") #Path to Pizza.
		
const MOVE_SPEED = 500			#Movement speed.
const GRAVITY = 30				#Gravity.
const FRICTION_AIR = 0.95		#Air friction.
const FRICTION_GROUND = 0.99	#Ground friction.
const HOOK_PULL = 100			#Hook pull.

var pizza_count 					#How many pizzas are available.
var pizza_counter = [] 				#The pizzas currently flying.
var velocity = Vector2(0,0)			#Velocity.
var wheel_turn = -1					#The motion the wheels should turn.
var hook_velocity := Vector2(0,0) 	#Hook veloicty. How the Player is pulled to Hook/Grapple.
var pizza							#Pizza instance.
var grounded 						#Grounded status
var direction = Vector2()			#Mouse cursor position.
var current_side = "right"			#Current side the Player is facing.

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pizza_count should represent the number of houses.
	pizza_count = get_parent().get_node("Houses").get_child_count() 
	#Get the stage name and remove all the prefixes and suffixes.
	var stage_name = get_tree().current_scene.filename
	stage_name = stage_name.substr(stage_name.find("Stages/")+7)
	stage_name.erase(stage_name.length()-5,5)
	$"Camera2D/Stage Name".text = stage_name #Display stage_name
	
#Update graphics, time, and direction every frame.
func _process(delta: float) -> void:
	Globals.time += delta #Update time.
	#Update direction
	direction.x = get_global_mouse_position().x - self.position.x 
	direction.y = get_global_mouse_position().y - self.position.y
	
	#Score display
	$Camera2D/Score.text = "Time: " +str(stepify(Globals.time,0.1)) + "\nScore: " + \
	str(Globals.player_score) + "\nPizza Count: " + str(pizza_count)

	#Wheels spin
	if !grounded: #If in the air, rotate the wheels independently from velocity.x.
		$"Person/Front Wheel".rotation_degrees += 3 * wheel_turn
		$"Person/Back Wheel".rotation_degrees += 3 * wheel_turn
	else: #If on the ground...
		if velocity.x != 0: #Change wheel_turn to the direction the Player is going.
			wheel_turn = sign(velocity.x)
		if !$PlayerSFX/WheelSpin.playing and abs(velocity.x) > 40: #Play 'WheelSpin' when at sufficient velocity.x.
			$PlayerSFX/WheelSpin.play()
		#Rotate wheels dependantly on velocity.x
		$"Person/Front Wheel".rotation_degrees += velocity.x / 10
		$"Person/Back Wheel".rotation_degrees += velocity.x / 10
	
	#Visually aim pizza. Add back self.position to get get_global_mouse_position().
	$"Pizza Rotator".look_at(direction + self.position) 
	$Person/ArmRotator/Arm.look_at(direction + self.position)  
	$Person/ArmRotator/Arm.rotation_degrees += 270 #Rotate Arm to match the mouse cursor.
	
	#Make the Pizza on the Arm visible when Player has at least one pizza.
	if pizza_count > 0:
		$Person/ArmRotator/Arm/Pizza.visible = true
	else:
		$Person/ArmRotator/Arm/Pizza.visible = false
		
	#Change the direction the Player is facing.	
	if direction.x < 0 and current_side == "right":
		change_side("left")
	elif direction.x > 0 and current_side == "left":
		change_side("right")

#Change the side the Player is facing.
func change_side(side) -> void:
	if side == "left":
		$Person.set_flip_h(true)
		$Person/ArmRotator/Arm.position.x = -5.5
		$"Person/Front Wheel".position.x = -14.2
		$"Person/Back Wheel".position.x = 17.5
		current_side = "left"
	else: #side == "right" 
		$Person.set_flip_h(false)
		$Person/ArmRotator/Arm.position.x = 5.5
		$"Person/Front Wheel".position.x = 14.2
		$"Person/Back Wheel".position.x = -17.5
		$Body.position.x = 3.4
		$"Feet and Wheels".position.x = -2.6
		current_side = "right"
		
#Collect InputEvents.
func _input(event: InputEvent) -> void:
	if event.is_action("shoot_hook"): #"shoot_hook" is defaulted to mouse left click. 
		if event.pressed:
			#Shoot the hook to the given direction. 
			#$Hook.call_deferred("shoot",direction)
			$Hook._shoot(direction)
		else:
			#Release the hook when the "shoot_hook" button is released.
			#$Hook.call_deferred("release")
			$Hook._release()
	if event.is_action("throw_pizza"): #"throw_pizza" is defaulted to mouse right click.
		if event.pressed and pizza_count > 0: #When "throw_pizza" is pressed and Player has more than 0 pizzas, throw a pizza.
			pizza_throw()

#Thow a pizza.
func pizza_throw() -> void:
	pizza_count -= 1 #Decrease pizza_count.
	pizza = pizza_path.instance() #Set pizza to an instance of the Pizza scene.
	get_parent().add_child(pizza) #Add pizza to Stage.
	pizza_counter.append(pizza) #Appened the pizza id to pizza_counter.
	$PlayerSFX/PizzaThrow.play() #Play the 'PizzaThrow' sound.
	pizza.position = $"Pizza Rotator/Pizza Spawn".global_position #Postion pizza.
	pizza.velocity = Vector2(direction.x,direction.y) #Grant pizza velocity.	

#Update physics every frame.
func _physics_process(delta: float) -> void:
	#Increase Gravity.
	velocity.y += GRAVITY
	
	#Hook physics.
	if $Hook.hooked:
		#Set hook_velocity to the direction that the hook is pulling.
		hook_velocity = to_local($Hook.grapple).normalized() * HOOK_PULL
		if hook_velocity.y > 0:
			hook_velocity.y *= 0.55 #Pulling down isn't as strong.
		else:
			hook_velocity.y *= 1.35 #Pulling up is stronger.
	else:
		hook_velocity = Vector2(0,0) #hook_velocity is (0,0) when the not hooked.
		
	velocity += hook_velocity #Apply hook_velocity.
	
	velocity = move_and_slide(velocity, Vector2.UP)	#Update velocity.
	
	grounded = is_on_floor() #Is the Player on the floor?
	#Apply air and ground friction
	if !grounded: #Apply air friction.
		velocity.x *= FRICTION_AIR
		if velocity.y > 0: #Apply air friction to pull downwards.
			velocity.y *= FRICTION_AIR 
	else: #Apply ground friction.
		velocity.x *= FRICTION_GROUND 
		
