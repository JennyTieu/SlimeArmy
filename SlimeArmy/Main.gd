extends Node2D

const SLIME = 3
const PLANT = 4
var plant_pos = []
var plant_pic = []
var slime_body = [Vector2(5,10)]
var slime_direction = Vector2(1,0)
var add_plant = false
var time_passed = 0
var time_new = 0
var reset = 0
var time_reset=0
var season = 0
var season_x = 0
var health = 3

func _ready():
	init_plant()
	draw_plant()
	draw_slime()
	
func place_plant():
	randomize()
	var x = randi() % 30
	var y = randi() % 20
	return Vector2(x,y)
		
func draw_plant():
	for i in range(plant_pos.size()):
		$SlimePlant.set_cell(plant_pos[i].x, plant_pos[i].y, plant_pic[i])

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
	for i in range(plant_pos.size()):
		if plant_pos[i] == slime_body[0]:
			plant_pos[i] = place_plant()
			
			if season == 0:
				if (plant_pic[i] > 5 && plant_pic[i] < 6) || (plant_pic[i] > 8 && plant_pic[i] < 9):
					update_score(slime_body.size())
					add_plant = true
				else:
					health = health - 1
					update_health(health)
			elif season == 1:
				if (plant_pic[i] > 4 && plant_pic[i] < 5) || (plant_pic[i] > 6 && plant_pic[i] < 7):
					update_score(slime_body.size())
					add_plant = true
				else:
					health = health - 1
					update_health(health-1)
			elif season == 2:
				if (plant_pic[i] > 9 && plant_pic[i] < 10) || (plant_pic[i] > 8 && plant_pic[i] < 9):
					update_score(slime_body.size())
					add_plant = true
				else:
					health = health - 1
					update_health(health-1)
			elif season == 3:
				if (plant_pic[i] > 7 && plant_pic[i] < 8) || (plant_pic[i] > 6 && plant_pic[i] < 7):
					update_score(slime_body.size())
					add_plant = true
				else:
					health = health - 1
					update_health(health - 1)
		
func check_game_over():
	var head = slime_body[0]
	#leaves screen
	if head.x > 28 or head.x < 0 or head.y < 0 or head.y > 20:
		reset()
	#hits army
	for block in slime_body.slice(1,slime_body.size()-1):
		if block == head:
			reset()
	if health == 0:
		reset()
	
func reset():
	slime_body = [Vector2(5,10)]
	slime_direction = Vector2(1,0)
	timer_reset()
	update_score(0)
	health = 3
	update_health(health)

func _on_SlimeTick_timeout():
	move_slime()
	draw_plant()
	draw_slime()
	check_plant_farmed()
	timer()
	check_season()
	
func _process(delta):
	check_game_over()

#Funktion zum initialisieren von mehreren plants + ihren Bildern
func init_plant():
	for i in range (10):
		plant_pos.append(place_plant())
		var x = rand_range(4,10) #range: const der tiles
		plant_pic.append(x)

#TODO:
#Zeitlimit für season, vlt iwo anzeigen lassen
#Timer hat Probleme wenn man schnell hintereinander stirbt
func timer():
	time_new = (OS.get_ticks_msec()/1000-1) - (time_reset*reset)
	if time_passed < time_new:
		time_passed = time_new
	#	einkommentieren damit time in konsole
		$HUD.update_time(time_passed)
		#print(time_passed)

func timer_reset():
	reset+=1
	time_reset = time_passed
	time_passed = 0
	season_x=0
	return reset

#"season change" nach 10 sek
func check_season():
	if  season_x < time_passed:
		season_x = time_passed
		if season_x % 10 == 0:
			season=season+1%4
			#print("season changed")
			match season:
				0: $HUD.update_season("Spring")
				1: $HUD.update_season("Summer")
				2: $HUD.update_season("Autumn")
				3: $HUD.update_season("Winter")
		if season == 0:
			update_season_plants("res://Graphics/blue-berry.png", "res://Graphics/purple-flower.png")
		elif season == 1:
			update_season_plants("res://Graphics/blue-flower.png", "res://Graphics/red-berry.png")
		elif season == 2:
			update_season_plants("res://Graphics/purple-flower.png", "res://Graphics/yellow-flower.png")
		elif season == 3:
			update_season_plants("res://Graphics/green-mint.png", "res://Graphics/blue-flower.png")

func update_score(slime_length):
	$HUD/Score/Score.text = str(slime_length)
 
func update_health(slime_health):
	$HUD/Health/Health.text = str(slime_health)

func update_season_plants(seasonPlant1, seasonPlant2):
	$HUD/Season/SeasonSprite1.texture = load(seasonPlant1)
	$HUD/Season/SeasonSprite2.texture = load(seasonPlant2)
