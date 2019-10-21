extends Node2D

var cards = [ null, null ]
var slots = [ $Slot0, $Slot1 ]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("right_click"):
		genCard()
	pass
	
func placeCard(index, card):
	if cards[index] != null:
		cards[index].onRelease(null)
	cards[index] = card
	
func eraseCard(index):
	cards[index] = null

func genCard():
	if cards[0] != null && cards[1] != null:
		var gm = get_parent().get_parent().gm
		var cardName = gm.getFusionCard(cards[0], cards[1]).name.to_lower()
		cards[0].queue_free()
		cards[1].queue_free()
		cards[0] = null
		cards[1] = null
		get_parent().loadCard(cardName)
	else:
		print("NÃO DÁ")