extends Node2D

var cards = [ null, null ]
var slots = [ $Slot0, $Slot1 ]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func placeCard(index, card):
	if cards[index] != null:
		cards[index].onRelease(null)
	
	cards[index] = card
