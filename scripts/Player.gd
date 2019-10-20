extends "Entity.gd"

onready var hand = get_node("Hand")
signal turnEnded

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("ui_down") and whoIAm == gm.turn):
		endTurn()
#	pass

func onTurnStart():
	if (status == GameManager.Status.Frozen):
		actions -= frozenActions
		
func endTurn():
	if (hand.cardCount <= maxCardsOnTurnEnd):
		emit_signal("turnEnded")
	else:
		pass
		
func takeDamage(damage):
	life -= damage
	print("Took damage: " + str(damage))
	print("Life = " + str(life))