extends Node

var gm

export (int) var life
export (int) var maxCardsOnTurnEnd
export (int) var maxActions
var actions

export (float) var paralyzisAttackFailPercentage
export (int) var frozenActions
export (int) var burnDamage

export (GameManager.Status) var status = GameManager.Status.None
export (GameManager.Character) var whoIAm

func _ready():
	print("hello world")
	gm = get_tree().get_root().get_node("GameManager")
	add_to_group("Entities")
	actions = maxActions
	
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
	# If my turn ended
	if (gm.turn != whoIAm):
		if (status == GameManager.Status.Burning):
			print("Burn damage")
			takeDamage(burnDamage)
			
func takeDamage(damage):
	life -= damage
	print("Took damage: " + str(damage))
	print("Life = " + str(life))
	
	if (life <= 0):
		if (whoIAm == GameManager.Character.Player):
			gm.gameOver()
		else:
			gm.onEnemyDeath()