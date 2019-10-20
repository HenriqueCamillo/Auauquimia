extends "Entity.gd"

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("ui_up") and whoIAm == gm.turn):
		endTurn()

func onTurnStart():
	for i in range(3):
		print("Attacking")
		attack()
		
func attack():
	#if (status == GameManager.Status.Paralyzed):
	gm.attackPlayer(2)
	
func endTurn():
	print("end")
	gm.onTurnEnded()