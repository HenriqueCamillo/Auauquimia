extends Node2D

var searching = false
var highlight = false
signal enter
signal exit

var target = null
var limit = 80

var slotCard = null
export (bool) var isEntity
export (int) var index

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if searching:
		var distance = (global_position - target.global_position).length()
		if !highlight && distance <= limit:
			highlight = true
			get_tree().call_group("hand","chooseSlot", $".")
		elif highlight && distance > limit:
			if target == slotCard:
				get_parent().eraseCard(index)
			highlight = false
			get_tree().call_group("hand","forgetSlot")
#	pass

func beAware(card):
	searching = true
	target = card
	
func goSleep():
	searching = false
	highlight = false
	target = null
	
func interact(card):
	slotCard = card
	if !isEntity:
		get_parent().placeCard(index, card)
	else:
		var cardInfo = load("res://cards/" + card.title.to_lower() + ".tres")
		#GameManager(player, cardInfo, get_parent().enemy???)
		pass
	print("LEEEEROOOOOOYYY")

func erase():
	slotCard = null
	goSleep()