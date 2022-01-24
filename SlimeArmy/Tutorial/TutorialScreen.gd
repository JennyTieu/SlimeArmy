extends Node

func _ready():
	pass # Replace with function body.

func _on_Back_pressed():
	$Sounds/Button.play(0)
	get_tree().change_scene("res://TitleScreen/TitleScreen.tscn");

func _on_AudioPlayButton_pressed():
	$Sounds/Countdown.play(0)
