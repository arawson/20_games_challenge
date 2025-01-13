extends StaticBody2D


@export var state: bool = false


@onready var sprite: AnimatedSprite2D = %Sprite
@onready var sfx = %SoundEffect


signal activated()
signal deactivated()

func _ready():
	align()


func align():
	if state:
		sprite.animation = "lever_right"
	else:
		sprite.animation = "lever_left"


func activate():
	print("lever: activated")
	state = not state
	align()
	sfx.play()
	if state:
		activated.emit()
	else:
		deactivated.emit()
