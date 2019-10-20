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

var typeStatusTable = []
var fusionTable = []

		
		
# Called when the node enters the scene tree for the first time.
func _ready():
	var ar = preload("res://scripts/AttackResult.gd")
	
										# None						# Burning						# Wet						# Paralyzed						# Frozen
	var fireAtck			= [ar.new(1, Status.Burning), 	ar.new(1, Status.Burning),		ar.new(0, Status.None),		ar.new(1, Status.NoChanges),	ar.new(0.5, Status.Wet)]
	var waterAtck			= [ar.new(0, Status.Wet),		ar.new(0, Status.None),			ar.new(0, Status.Wet),		ar.new(0, Status.NoChanges),	ar.new(0, Status.NoChanges)]
	var airAtck				= [ar.new(1, Status.None), 		ar.new(1, Status.Burning),		ar.new(1, Status.Frozen),	ar.new(1, Status.None),			ar.new(1, Status.NoChanges)]
	var electricAtck		= [ar.new(1, Status.Paralyzed),	ar.new(1, Status.NoChanges),	ar.new(2, Status.NoChanges),ar.new(1, Status.Renovation),	ar.new(1, Status.NoChanges)]
	var iceAtck				= [ar.new(1, Status.Frozen),	ar.new(0.5, Status.NoChanges),	ar.new(2, Status.Frozen),	ar.new(1, Status.Renovation),	ar.new(1, Status.Renovation)]
	var metalAtck			= [ar.new(1, Status.None),	 	ar.new(1, Status.NoChanges),	ar.new(1, Status.NoChanges),ar.new(0, Status.SelfDamage),	ar.new(2, Status.NoChanges)]
	var waterElectricAtck	= [ar.new(0, Status.Paralyzed),	ar.new(0, Status.NoChanges),	ar.new(0, Status.NoChanges),ar.new(0, Status.Renovation),	ar.new(0, Status.NoChanges)]
	var airFireAtck			= [ar.new(1, Status.Burning), 	ar.new(1, Status.Burning),		ar.new(1, Status.None),		ar.new(1, Status.NoChanges),	ar.new(1, Status.Wet)]
	var airElectricAtck		= [ar.new(1, Status.Paralyzed),	ar.new(1, Status.NoChanges),	ar.new(1, Status.NoChanges),ar.new(1, Status.Renovation),	ar.new(1, Status.NoChanges)]
	var airIceAtck			= [ar.new(1, Status.Frozen),	ar.new(1, Status.NoChanges),	ar.new(1, Status.Frozen),	ar.new(1, Status.Renovation),	ar.new(1, Status.Renovation)]
	var metalFireAtck		= [ar.new(1, Status.Burning), 	ar.new(1, Status.Burning),		ar.new(1, Status.None),		ar.new(0, Status.NoChanges),	ar.new(2, Status.Wet)]
	var metalElectricAtck	= [ar.new(1, Status.Paralyzed),	ar.new(1, Status.NoChanges),	ar.new(1, Status.NoChanges),ar.new(0, Status.Renovation),	ar.new(2, Status.NoChanges)]
	
	typeStatusTable = [fireAtck, waterAtck, airAtck, electricAtck, iceAtck, metalAtck, waterElectricAtck, airFireAtck, airElectricAtck, airIceAtck, metalFireAtck, metalElectricAtck]
	
							# Fire				# Water				# Air 				# Electric 			# Ice 			# Metal 		# Fire2 	# Water2 	# Air2 	# Electric2 # Ice2		# Metal2 # WaterElectric # AirFire # AirElectric # AirIce # MetalFire # MetalElectric
	var fireFsn				= [Type.Fire2,		Type.None,			Type.AirFire,		Type.Metal, 		Type.Water,		Type.MetalFire]
	var waterFsn			= [Type.None,		Type.Water2,		Type.Ice, 			Type.WaterElectric, Type.None,		Type.None]
	var airFsn				= [Type.AirFire,	Type.Ice,			Type.Air2,			Type.AirElectric,	Type.AirIce,	Type.None]
	var electricFsn			= [Type.Metal,		Type.WaterElectric,	Type.AirElectric,	Type.Electric2,		Type.None,		Type.MetalElectric]
	var iceFsn				= [Type.Water,		Type.None,			Type.AirIce,		Type.None,			Type.Ice2, 		Type.None]
	var metalFsn			= [Type.MetalFire,	Type.None,			Type.None,			Type.MetalElectric,	Type.None,		Type.Metal2]
#	
	fusionTable = [fireFsn, waterFsn, airFsn, electricFsn, iceFsn, metalFsn]

func getAttackResult(type, status):
	if (type >= Type.Fire2):
		type -= Type.Fire2
	return typeStatusTable[type][status]
	
# Returns the type of the result card of the fusion
func getFusionResult(type1, type2):
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