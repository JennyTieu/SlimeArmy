extends Node

onready var label: Label = get_node("FinalScore/CenterRow/Buttons/ScoreLabel");

func _ready():
	$Sounds/Music.play(1)
	label.text = label.text % [PlayerData.score]
	pass # Replace with function body.

func _on_Restart_pressed():
	$Sounds/Button.play(0)
	get_tree().change_scene("res://MainScene/Main.tscn");

func _on_Menu_pressed():
	$Sounds/Button.play(0)
	get_tree().change_scene("res://TitleScreen/TitleScreen.tscn");
