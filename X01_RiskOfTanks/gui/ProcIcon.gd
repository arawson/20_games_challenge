extends TextureRect

var item: ProcItem = null
onready var counter = $Counter

var quantity: int setget set_quantity, get_quantity

func _ready():
	assert(item != null)
	texture = item.icon

func set_quantity(value: int) -> void:
	quantity = value
	counter.text = "%d" % value

func get_quantity() -> int:
	return quantity
