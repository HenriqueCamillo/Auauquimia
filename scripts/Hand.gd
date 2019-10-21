extends Node2D

#exports
export (PackedScene) var card
export (int) var cardMax = 7
export (Vector2) var center = Vector2(0, 0)
export (Vector2) var offset = Vector2(150, 50)
export (float) var rot = 0.25

#ints
var cardCount = 0

#arrays
var deck = ["fire", "water", "energy", "air"]

signal grab
signal release

#aux
var cardOnHand = null
var chosenSlot = null
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		drawCard()

func drawCard():
	var sortCard = rng.randi_range(0, deck.size() - 1)
	loadCard(deck[sortCard])

func loadCard(cardName):
	if cardCount + 1 <= cardMax:
		#instance card
		var c = card.instance()
		add_child(c)
		cardCount += 1
		#place card
		get_tree().call_group("cards", "shift", offset/2, cardCount, rot/2)
		c.position = center
		c.position.x += (cardCount - 1) * offset.x / 2
		c.position.y += round(cardCount/2) * offset.y / 2
		c.rotate(round(cardCount/2) * rot / 2)
		
		c.add_to_group("cards")
		
		c.init(cardName, cardCount)

func grabCard(card):
	cardOnHand = card
	get_tree().call_group("target","beAware", card)

func chooseSlot(slot):
	chosenSlot = slot

func forgetSlot():
	chosenSlot = null

func releaseCard():
	get_tree().call_group("target","goSleep")
	cardOnHand.onRelease(chosenSlot)
	cardOnHand = null
	chosenSlot = null
	
func eraseCard(index):
	get_tree().call_group("cards", "refresh", index, offset/2, cardCount, rot/2)
	cardCount -= 1
		