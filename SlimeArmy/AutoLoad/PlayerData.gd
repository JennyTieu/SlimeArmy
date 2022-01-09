extends Node

signal score_updated
signal volume_updated

var score = 0 setget set_score
var volume = 0 setget set_volume

func set_score(value: int) -> void:
	score = value
	emit_signal("score_updated")
	
func set_volume(value: float) -> void:
	volume = value
	emit_signal("volume_updated")
