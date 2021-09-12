extends Node2D
"""
This script controls grappling hook.
"""
var direction := Vector2(0,0)	#The direction in which Hook was shot.
var grapple := Vector2(0,0)			#The global position the grapple should be in.
								#We use an extra var for this, because Hook is 
								#connected to the Player and thus all .position
								#properties would get messed with when the Player moves.

onready var timer = get_node("Hook Timer") #Timer for Hook.
const SPEED = 15 #The speed with which Grapple moves.

var flying = false	#Whether Hook is moving through the air.
var hooked = false	#Whether Hook has connected a body.
var item_picked_up = false #Whether the Pizza that is hooked onto is already picked up.
var collision #Movement and collision of the hook.

#Shoots the hook in a given direction.
func shoot(dir: Vector2) -> void:
	$Grapple/CollisionShape2D.disabled = false #Allows Grapple to collide.
	if flying == false: #Plays 'GrappleTo' when just shot.
		$GrappleSFX/GrappleTo.play()
	direction = dir.normalized()	#Normalize the direction and save it.
	flying = true					#Make flying true.
	grapple = self.global_position		#Reset Grapple's position to the Player's position.
	timer.start() #Start the timer.

#Release the hook.
func release() -> void:
	$Grapple/CollisionShape2D.disabled = true #Disables Grapple from colliding.
	if (flying or hooked): #Plays 'GrappleRelease' when "shoot_hook"(In Player._input(event: InputEvent)) is let go of.  
		$GrappleSFX/GrappleRelease.play()
	flying = false	#Not flying anymore.	
	hooked = false	#Not attached anymore.
	item_picked_up = false #No item is able to be picked up.


#Every graphics frame we update the visuals.
func _process(_delta: float) -> void:
	self.visible = flying or hooked	#Only visible if flying or hooked onto something.
	if not self.visible: 
		return	#Don't display anything when not visible.
	var grapple_loc = to_local(grapple)	#Set .grapple_loc to the position of .grapple.
	# We rotate Rope and Grapple to fit on the line between self.position (= origin = player.position) and Grapple
	$Rope.rotation = self.position.angle_to_point(grapple_loc) - deg2rad(90)
	$Grapple.rotation = self.position.angle_to_point(grapple_loc) - deg2rad(90)
	$Rope.position = grapple_loc						#The Rope is positioned to start at Grapple.
	$Rope.region_rect.size.y = grapple_loc.length()		#Rope is extended the length of the Player to Grapple.

#Every frame, physics is updated.
func _physics_process(_delta: float) -> void:
	$Grapple.global_position = grapple	#The Player might have moved and thus updated the position of Grapple by resetting it.
	if flying: #When Hook is flying in the air...
		#Move Grapple and detect collision.
		collision = $Grapple.move_and_collide(direction * SPEED)
		if collision: #When a collision is detected...
			$GrappleSFX/GrappleOn.play() #Play 'GrappleOn'
			hooked = true	#Hook is hooked onto something.
			flying = false	#No longer flying.
			
			if "Pizza" in collision.collider.name: #Allow Pizza/Pizza Collector to detect if the Player enters it.
				collision.collider.get_node("Pizza Collector").monitoring = true
		else:
			if timer.is_stopped(): #Prevents infinite distance hooking.
				release() #Release the hook after timer has stopped.
				
	#Prevents the hook from clamping onto a picked up pizza.
	if item_picked_up:
		item_picked_up = false #Reset it for future use.
		release() #Release to prevent the clamping.
		
	grapple = $Grapple.global_position	#Set Grapple as starting position for next frame.

#When the timer times out, stop the timer.
func _hook_timer_timeout() -> void:
	timer.stop()
