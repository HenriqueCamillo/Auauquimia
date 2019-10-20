extends Node2D

class_name GameManager

enum Status {
	None,
	Burning,
	Wet,
	Paralyzed,
	Frozen,
	Renovation,
	NoChanges,
	SelfDamage
}

enum Type {
	None
	Fire,
	Water,
	Air,
	Electric,
	Ice,
	Metal,
	WaterElectric,
	AirFire,
	AirElectric,
	AirIce,
	MetalFire,
	MetalElectric,
	Fire2,
	Water2,
	Air2,
	Electric2,
	Ice2,
	Metal2,
	WaterElectric2,
	AirFire2,
	AirElectric2,
	AirIce2,
	MetalFire2,
	MetalElectric2,
}

enum Character {
	Player,
	Enemy
}

var attackTable = []
var fusionTable = []

var turn = Character.Player
signal playerTurn
signal enemyTurn

var currentEnemy
var enemyIndex = 0
export (PackedScene) var enemy
export (Array, Resource) var enemies

export (PackedScene) var card
export (Array, Resource) var cards

var player
# Creates the fusion and the attack table
func _ready():
	# Loads Attack Result class
	var ar = preload("res://scripts/AttackResult.gd")
	player = $Player
										# None						# Burning						# Wet						# Paralyzed						# Frozen
	var fireAtck			= [ar.new(1, Status.Burning), 	ar.new(1, Status.Burning),		ar.new(0, Status.None),			ar.new(1, Status.NoChanges),	ar.new(0.5, Status.Wet)]
	var waterAtck			= [ar.new(0, Status.Wet),		ar.new(0, Status.None),			ar.new(0, Status.Wet),			ar.new(0, Status.NoChanges),	ar.new(0, Status.NoChanges)]
	var airAtck				= [ar.new(1, Status.None), 		ar.new(1, Status.Burning),		ar.new(1, Status.Frozen),		ar.new(1, Status.None),			ar.new(1, Status.NoChanges)]
	var electricAtck		= [ar.new(1, Status.Paralyzed),	ar.new(1, Status.NoChanges),	ar.new(2, Status.NoChanges),	ar.new(1, Status.Renovation),	ar.new(1, Status.NoChanges)]
	var iceAtck				= [ar.new(1, Status.Frozen),	ar.new(0.5, Status.NoChanges),	ar.new(2, Status.Frozen),		ar.new(1, Status.Renovation),	ar.new(1, Status.Renovation)]
	var metalAtck			= [ar.new(1, Status.None),	 	ar.new(1, Status.NoChanges),	ar.new(1, Status.NoChanges),	ar.new(0, Status.SelfDamage),	ar.new(2, Status.NoChanges)]
	var waterElectricAtck	= [ar.new(0, Status.None),		ar.new(0, Status.None),			ar.new(0, Status.None),			ar.new(0, Status.None), 		ar.new(0, Status.None),]
	var airFireAtck			= [ar.new(1, Status.Burning), 	ar.new(1, Status.Renovation),	ar.new(0.75, Status.None),		ar.new(1, Status.Burning),		ar.new(1, Status.Wet)]
	var airElectricAtck		= [ar.new(1, Status.Paralyzed),	ar.new(1, Status.Paralyzed),	ar.new(1.5, Status.Paralyzed),	ar.new(1, Status.Renovation),	ar.new(1, Status.NoChanges)]
	var airIceAtck			= [ar.new(1, Status.Frozen),	ar.new(0.75, Status.NoChanges),	ar.new(1.5, Status.Frozen),		ar.new(1, Status.Frozen),		ar.new(1, Status.Renovation)]
	var metalFireAtck		= [ar.new(1, Status.Burning), 	ar.new(1, Status.Renovation),	ar.new(1, Status.None),			ar.new(1, Status.Burning),		ar.new(2, Status.Burning)]
	var metalElectricAtck	= [ar.new(1, Status.Paralyzed),	ar.new(1, Status.Paralyzed),	ar.new(1.5, Status.NoChanges),	ar.new(1, Status.Renovation),	ar.new(2, Status.Paralyzed)]
	
	attackTable = [fireAtck, waterAtck, airAtck, electricAtck, iceAtck, metalAtck, waterElectricAtck, airFireAtck, airElectricAtck, airIceAtck, metalFireAtck, metalElectricAtck]
	
					# Fire				# Water				# Air				# Electric 			# Ice 			# Metal 
	var fireFsn		= [Type.Fire2,		Type.None,			Type.AirFire,		Type.Metal, 		Type.Water2,	Type.MetalFire]
	var waterFsn	= [Type.None,		Type.Water2,		Type.Ice, 			Type.WaterElectric, Type.None,		Type.None]
	var airFsn		= [Type.AirFire,	Type.Ice,			Type.Air2,			Type.AirElectric,	Type.AirIce,	Type.None]
	var electricFsn	= [Type.Metal,		Type.WaterElectric,	Type.AirElectric,	Type.Electric2,		Type.None,		Type.MetalElectric]
	var iceFsn		= [Type.Water2,		Type.None,			Type.AirIce,		Type.None,			Type.Ice2, 		Type.None]
	var metalFsn	= [Type.MetalFire,	Type.None,			Type.None,			Type.MetalElectric,	Type.None,		Type.Metal2]
#	
	fusionTable = [fireFsn, waterFsn, airFsn, electricFsn, iceFsn, metalFsn]
	
	#instantiateEnemy(enemyIndex)
	currentEnemy = enemy.instance()
	add_child(currentEnemy)
	currentEnemy.gm = $"."
	startTurn(turn)

func _process(delta):
	#print(turn)
	pass

# Returns the attack result containing the multiplier and the status
func getAttackResult(type, status):
	if (type >= Type.Fire2):
		type -= Type.Fire2 - Type.Fire
	return attackTable[type][status]
	
# Returns the type of the result card of the fusion
func getFusionResultType(type1, type2):
	# If both are level 1
	if (type1 < Type.Fire2 and type2 < Type.Fire2):
		return fusionTable[type1][type2]
	# If both are level 2
	elif (type1 >= Type.Fire2 and type2 >= Type.Fire2):
		type1 -= Type.Fire2 - Type.Fire
		type2 -= Type.Fire2 - Type.Fire
		
		return fusionTable[type1][type2] + Type.Fire2
	# If type 1 is level 1 and type 2 is level 2
	elif (type1 < Type.Fire2 and type2 >= Type.Fire2):
		type2 -= Type.Fire2 - Type.Fire
		return fusionTable[type1][type2]
	# If type 1 is level 2 and type 2 is level 1
	elif (type1 >= Type.Fire2 and type2 < Type.Fire2):
		type1 -= Type.Fire2 - Type.Fire
		return fusionTable[type1][type2]
	else:
		return Type.None

# Changes the turn, passes the signal to the entities, and then starts the turn
func onTurnEnded():
	get_tree().call_group("Entities", "onTurnEnded")
	switchTurn()
	print("Called entities")
	startTurn(turn)
	
func switchTurn():
	print("Switching turn...")
	if (turn == Character.Player):
		print("Enemy's turn")
		turn = Character.Enemy
	else:
		print("Player's turn")
		turn = Character.Player
		
func startTurn(turn):
	if (turn == Character.Player):
		emit_signal("playerTurn")
	else:
		currentEnemy.onTurnStart()
	
func onEnemyDeath():
	enemyIndex += 1
	if (enemyIndex < enemies.size()):
		instantiateEnemy(enemyIndex)
	else:
		# Finished the game
		pass
		
func instantiateEnemy(index):
	print("New enemy")
	currentEnemy = enemy.instance()
	add_child(currentEnemy)
	
	var enemyData = enemies[index]
	
	currentEnemy.gm = $"."
	currentEnemy.life = enemyData.life
	currentEnemy.attack = enemyData.attack
	#TODO add other things
	
func attackPlayer(damage):
	$Player.takeDamage(damage)
	
func gameOver():
	pass
	
func castCard(caster, card, target):
	var result = getAttackResult(card.type, currentEnemy.status)
	target.status = result.status
	target.takeDamage(card.damage * result.multiplier)
	
	caster.onCastCard()

func getFusionCard(card1, card2):
	var result = getFusionResultType(card1.type, card2.type)
	if (result != Type.None):
		for i in range(cards.size()):
			if (cards[i].type == result):
				return cards[i]
	else:
		return null