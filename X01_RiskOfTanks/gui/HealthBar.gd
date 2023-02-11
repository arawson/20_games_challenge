extends ProgressBar

onready var health_text = $HealthLabel

func set_health(health: float, max_health: float, precision: int = 1):
	var format = "%%2.%df/%%2.%df" % [precision, precision]
	health_text.text = format % [health, max_health]
	max_value = max_health
	value = health
