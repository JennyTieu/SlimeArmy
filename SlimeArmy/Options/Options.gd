extends Node

var music_volume = 0;
var value;

func _ready():
	windowMode()
	$Options/WindowMode/OptionButton.select(value)
	
func _on_Back_pressed():
	$Sounds/Button.play(0)
	get_tree().change_scene("res://TitleScreen/TitleScreen.tscn");

func _on_HSlider_value_changed(value):
	$Sounds/Button.play(0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_OptionButton_item_selected(index):
	$Sounds/Button.play(0)
	if index == 0:
		OS.window_fullscreen = false;
		index = 0;
	elif index == 1:
		OS.window_fullscreen = true;
		index = 1;

func windowMode():
	if OS.window_fullscreen:
		value = 1
	elif !OS.window_fullscreen:
		value = 0
