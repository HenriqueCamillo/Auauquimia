extends Node2D

var searching = false
var highlight = false
signal enter
signal exit

var target = Vector2(0,0)

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
		get_tree().call_group("hand","chooseSlot", $".")
	pass # Replace with function body.

func onMouseExit():
	if searching && highlight:
		highlight = false
		get_tree().call_group("hand","forgetSlot")
	pass # Replace with function body.
	
func interact():
	print("LEEEEROOOOOOYYY")
