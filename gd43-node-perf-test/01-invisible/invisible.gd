extends Node2D

var stressor_scene = preload("res://01-invisible/stressor.tscn")
@onready var system_perf = $SystemPerf
@onready var scene_stats = $SceneStats
@onready var stressors = $Stressors


var tln_count: int = 0
var tln_sub_count: int = 1000


func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	system_perf.text = "FPS = %d" % Engine.get_frames_per_second()
	scene_stats.text = "Top-Level Nodes = %d, Sub-Nodes Each = %d" % [tln_count, tln_sub_count]


func _on_button_pressed() -> void:
	for i in range(100):
		tln_count += 1
		var new_stressor = stressor_scene.instantiate()
		new_stressor.sub_count = tln_sub_count
		stressors.add_child(new_stressor)
