extends Node

func _ready():
	pass # Replace with function body.

func _on_Restart_pressed():
	get_tree().change_scene("res://MainScene/Main.tscn");

func _on_Menu_pressed():
	get_tree().change_scene("res://TitleScreen/TitleScreen.tscn");
