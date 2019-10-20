extends Node

export (int) var life
export (int) var maxCardsOnTurnEnd
export (int) var maxOfActions

export (float) var paralyzisAttackFailPercentage
export (int) var frozenCards
export (int) var burnDamage

export (GameManager.Status) var status = GameManager.Status.None
export (GameManager.Character) var whoIAm



func _ready():
	add_to_group("Entities")	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Deals burn damage
func burn():
	life -= burnDamage
	
# Returns true or false
func attackSuccessful():
	if (status == GameManager.Status.Paralyzed):
		if (randf() < paralyzisAttackFailPercentage):
			return false
		else:
			return true

func onCardMerged():
	pass

func onCardUsed():
	pass

func onTurnEnded():
	if (GameManager.turn == whoIAm):
		if (status == GameManager.Burning):
			burn()