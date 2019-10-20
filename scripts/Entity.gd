extends Node

export (int) var life
export (int) var maxCardsOnTurnEnd
export (int) var maxOfActions
var actions

export (float) var paralyzisAttackFailPercentage
export (int) var frozenActions
export (int) var burnDamage

export (GameManager.Status) var status = GameManager.Status.None
export (GameManager.Character) var whoIAm

func _ready():
	add_to_group("Entities")
	actions = maxOfActions
	
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
	actions -= 1

func onCardUsed():
	actions -= 1

func onTurnEnded():
	if (GameManager.turn == whoIAm):
		if (status == GameManager.Status.Burning):
			burn()