extends Node

func _ready():
	$Sounds/Music.play(1)
	pass # Replace with function body.

func _on_Restart_pressed():
	$Sounds/Button.play(0)
	get_tree().change_scene("res://MainScene/Main.tscn");

func _on_Menu_pressed():
	$Sounds/Button.play(0)
	get_tree().change_scene("res://TitleScreen/TitleScreen.tscn");
