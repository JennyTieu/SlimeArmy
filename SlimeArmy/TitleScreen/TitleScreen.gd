extends Node

func _ready():
	pass

func _on_NewGame_pressed():
	get_tree().change_scene("res://MainScene/Main.tscn");

func _on_Options_pressed():
	get_tree().change_scene("res://Options/Options.tscn");

func _on_Quit_pressed():
	get_tree().quit();
