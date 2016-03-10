
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var debug_label = get_node("DebugLabel")

func _ready():
	debug_label.set_pos(get_viewport_rect().end/2)
	get_node("ActionTest").play_action()
	
	pass
	
func _on_action_is_played( action ):
	debug(action.get_name() + ": action is playing")
	pass # replace with function body

func _on_action_is_done( action ):
	debug(action.get_name() + ": action is done")
	pass # replace with function body

func debug(text):
	print(text)
	debug_label.set_text(text)


