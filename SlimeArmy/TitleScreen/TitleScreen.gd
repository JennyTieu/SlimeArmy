extends Node

func _ready():
	$Sounds/Music.play(0)
	pass

func _on_NewGame_pressed():
	$Sounds/Button.play(0)
	get_tree().change_scene("res://MainScene/Main.tscn");

func _on_Options_pressed():
	$Sounds/Button.play(0)
	get_tree().change_scene("res://Options/Options.tscn");

func _on_Quit_pressed():
	$Sounds/Button.play(0)
	get_tree().quit();

func _on_Controls_pressed():
	$Sounds/Button.play(0)
	get_tree().change_scene("res://ControlScreen/Controls.tscn");


func _on_Tutorial_pressed():
	$Sounds/Button.play(0)
	get_tree().change_scene("res://Tutorial/TutorialScreen.tscn");
