extends Node2D

var searching = false
var highlight = false
signal enter
signal exit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func beAware():
	searching = true
	
func goSleep():
	searching = false
	highlight = false

func onMouseEnter():
	if searching:
		highlight = true
		emit_signal("enter")
	pass # Replace with function body.


func onMouseExit():
	if searching && highlight:
		highlight = false
		emit_signal("exit")
	pass # Replace with function body.
