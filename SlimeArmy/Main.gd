extends Node2D

const SLIME = 3
const PLANT = 4
var plant_pos
var slime_body = [Vector2(5,10)]
var slime_direction = Vector2(1,0)
var add_plant = false

func _ready():
	plant_pos = place_plant()
	draw_plant()
	draw_slime()
	
func place_plant():
	randomize()
	var x = randi() % 30
	var y = randi() % 20
	return Vector2(x,y)


func draw_plant():
	$SlimePlant.set_cell(plant_pos.x, plant_pos.y,PLANT)


func draw_slime():
	for block in slime_body:
		$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(0,0))


func move_slime():
	if add_plant:
		delete_tiles(SLIME)
		var body_copy:Array
		var new_head:Vector2
		if slime_body.size()>1:
			body_copy = slime_body.slice(0,slime_body.size()-1)
			new_head = body_copy[0] + slime_direction
		else:
			body_copy = slime_body
			new_head = body_copy[0] + slime_direction
		body_copy.insert(0, new_head)
		slime_body = body_copy
		add_plant = false
	else:
		delete_tiles(SLIME)
		var body_copy:Array
		var new_head:Vector2
		if slime_body.size()>1:
			body_copy = slime_body.slice(0,slime_body.size()-2)
			new_head = body_copy[0] + slime_direction
		else:
			new_head = slime_body[0] + slime_direction
		body_copy.insert(0, new_head)
		slime_body = body_copy
	
func delete_tiles(id:int):
	var cells = $SlimePlant.get_used_cells_by_id(id)
	for cell in cells:
		$SlimePlant.set_cell(cell.x, cell.y, -1)
		
func _input(event):
	if Input.is_action_just_pressed("ui_up"): 
		if not slime_direction == Vector2(0,1):
			slime_direction = Vector2(0,-1)
	if Input.is_action_just_pressed("ui_right"): 
		if not slime_direction == Vector2(-1,0):
			slime_direction = Vector2(1,0)
	if Input.is_action_just_pressed("ui_left"): 
		if not slime_direction == Vector2(1,0):
			slime_direction = Vector2(-1,0)
	if Input.is_action_just_pressed("ui_down"): 
		if not slime_direction == Vector2(0,-1):
			slime_direction = Vector2(0,1)
	
func check_plant_farmed():
	if plant_pos == slime_body[0]:
		plant_pos = place_plant()
		add_plant = true
		
func check_game_over():
	var head = slime_body[0]
	#leaves screen
	if head.x > 28 or head.x < 0 or head.y < 0 or head.y > 20:
		reset()
	#hits army
	for block in slime_body.slice(1,slime_body.size()-1):
		if block == head:
			reset()
	
func reset():
	slime_body = [Vector2(5,10)]
	slime_direction = Vector2(1,0)

func _on_SlimeTick_timeout():
	move_slime()
	draw_plant()
	draw_slime()
	check_plant_farmed()
	
	
func _process(delta):
	check_game_over()
