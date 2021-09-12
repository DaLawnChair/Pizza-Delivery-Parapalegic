extends Button
"""
This script allows buttons to be interactable and function.
"""
export var reference_path = "" #Variable is exported to connect a reference path throught the inspector.
export (bool) var start_focused = false #Allows a button to be focused if chosen to on the inspector.

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (start_focused): #Lets this button be focused when starting the scene.
		grab_focus()
	#Connect the 'mouse_entered' and 'pressed' signals to self.
	connect("mouse_entered",self,"_on_Button_mouse_entered")
	connect("pressed",self,"_on_Button_Pressed")

#Called when the mouse enters self.
func _on_Button_mouse_entered() -> void:
	grab_focus() #Grabs focus.
	$ButtonHover.play() #Plays the 'ButtonHover'sound.
	
#Called when self is pressed.
func _on_Button_Pressed() -> void:
	if (reference_path.begins_with("res://")):
		#Changes the scene.
		get_tree().change_scene(reference_path)
	else:
		if (reference_path == "resume"): #Resumes the current scene.
			get_parent()._pause()
		else: #Exits the program.
			get_tree().quit()

