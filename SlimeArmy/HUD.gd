extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_time(value):
	$TimeBox/HBoxContainer/Time.text = str(value)

func update_season(value): 
	$SeasonBox/HBoxContainer/Season.text = str(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
