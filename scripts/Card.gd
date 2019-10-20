extends Node2D
# booleans
var isFocus = false
var isGrabbed = false
var canDrag = true

# Vector 2
var mouseOffset = Vector2(0,0)

#int
var handIndex = 0

#info vars
var title = ""
var damage = 0.0
var heal = 0.0
var effect = 0
var type = 0
var desc = ""

#on release vars
var originalPos = Vector2(0,0)
var originalRot = 0
var originalZ = 0

signal released


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(cardName, index):
	handIndex = index
	
	var info = load("res://cards/" + cardName + ".tres")
	title = info.name
	type = info.type
	effect = info.effect
	damage = info.damage
	heal = info.heal
	desc = info.desc
	
	$Art.texture = info.art
	$Name.text = title
	
	print(str(handIndex) + "-> pos: " + str(position) + " rot: " + str(rotation))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("left_click") && isFocus):
		var mousePos = get_global_mouse_position()
		
		if !isGrabbed:
			isGrabbed = true
			mouseOffset = position - mousePos
			originalPos = position
			originalRot = rotation
			originalZ = z_index
			rotation = 0.0
			z_index = 5
		else:
			position = mousePos + mouseOffset
			
	if (Input.is_action_just_released("left_click") && isGrabbed):
		isGrabbed = false
		emit_signal("released")
		onRelease(null)
	pass

func onMouseEnter():
	isFocus = true


func onMouseExit():
	isFocus = false
	
func onRelease(destiny):
	if destiny == null:
		position = originalPos
		rotation = originalRot
		z_index = originalZ
	
func shift(offset, count, rot):
	position.x -= offset.x
	
	if (count % 2 == 0 && handIndex <= count/2):
		position.y += offset.y
		rotate(-rot)
		
	elif (count % 2 == 1 && handIndex > count/2):
		position.y -= offset.y
		rotate(-rot)
		
	print(str(handIndex) + "-> pos: " + str(position) + " rot: " + str(rotation))
	