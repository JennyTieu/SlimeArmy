extends Node2D

const SLIME = 7
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
var plant_time = 0

func _ready():
	PlayerData.score = 0
	init_plant()
	draw_plant()
	draw_slime()
	update_health(health)
	$Sounds/BackgroundMusic.play()
	$PauseMenu/CanvasLayer/Panel.visible = false
	
func place_plant():
	randomize()
	var x = randi() % 30
	var y = randi() % 20
	return Vector2(x,y)
		
func draw_plant():
	for i in range(plant_pos.size()):
		$SlimePlant.set_cell(plant_pos[i].x, plant_pos[i].y, plant_pic[i])

func draw_slime():
	for block_index in slime_body.size():
		var block = slime_body[block_index]
		if block_index==0 && slime_body.size()==1:
			if slime_direction == Vector2(-1,0):
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(0,1))
			if slime_direction == Vector2(1,0):
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(1,1))
			if slime_direction == Vector2(0,-1):
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(0,0))
			if slime_direction == Vector2(0,1):
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(1,0))
		elif block_index==0 && slime_body.size()!=1:
			var head_dir = relation2(slime_body[0],slime_body[1])
			if head_dir == 'right':
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(0,1))
			if head_dir == 'left':
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(1,1))
			if head_dir == 'top':
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(1,0))
			if head_dir == 'bottom':
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(0,0))
		elif block_index==slime_body.size()-1 && slime_body.size()!=1:
			var head_dir = relation2(slime_body[-1],slime_body[-2])
			if head_dir == 'right':
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(1,1))
			if head_dir == 'left':
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(0,1))
			if head_dir == 'top':
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(0,0))
			if head_dir == 'bottom':
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(1,0))
		else:
			var previous_block = slime_body[block_index +1] - block
			var next_block =slime_body[block_index -1] - block
			
			if previous_block.x == 1 :
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(0,1))
			if previous_block.x == -1:
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(1,1))
			if previous_block.y == 1:
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(0,0))
			if previous_block.y == -1:
				$SlimePlant.set_cell(block.x,block.y, SLIME, false, false, false,Vector2(1,0))

func relation2(first_block: Vector2, second_block:Vector2):
	var block_relation = second_block - first_block
	if block_relation == Vector2(-1,0): return 'left'
	if block_relation == Vector2(1,0): return 'right'
	if block_relation == Vector2(0,1): return 'bottom'
	if block_relation == Vector2(0,-1): return 'top'

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
	if Input.is_action_just_pressed("ui_cancel"): 
		get_tree().paused = true
		$PauseMenu/CanvasLayer/Panel.visible = true

func check_plant_farmed():
	for i in range(plant_pos.size()):
		if plant_pos[i] == slime_body[0]:
			plant_pos[i] = place_plant()
			if season == 0:
				if (plant_pic[i] > 0 && plant_pic[i] < 1) || (plant_pic[i] > 3 && plant_pic[i] < 4):
					update_score(slime_body.size())
					PlayerData.score += 1
					add_plant = true
					$Sounds/Eating.play(0)
				else:
					health = health - 1
					update_health(health)
					$Sounds/Health.play(0)
			elif season == 1:
				if (plant_pic[i] > 1 && plant_pic[i] < 2) || (plant_pic[i] > 4 && plant_pic[i] < 5):
					update_score(slime_body.size())
					PlayerData.score += 1
					add_plant = true
					$Sounds/Eating.play(0)
				else:
					health = health - 1
					update_health(health)
					$Sounds/Health.play(0)
			elif season == 2:
				if (plant_pic[i] > 3 && plant_pic[i] < 4) || (plant_pic[i] > 5 && plant_pic[i] < 6):
					update_score(slime_body.size())
					PlayerData.score += 1
					add_plant = true
					$Sounds/Eating.play(0)
				else:
					health = health - 1
					update_health(health)
					$Sounds/Health.play(0)
			elif season == 3:
				if (plant_pic[i] > 2 && plant_pic[i] < 3) || (plant_pic[i] > 1 && plant_pic[i] < 2):
					update_score(slime_body.size())
					PlayerData.score += 1
					add_plant = true
					$Sounds/Eating.play(0)
				else:
					health = health - 1
					update_health(health)
					$Sounds/Health.play(0)

func check_game_over():
	var head = slime_body[0]
	#leaves screen
	if head.x > 29 or head.x < 0 or head.y < 0 or head.y > 20:
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
	update_score(0)
	health = 3
	update_health(health)
	init_plant()
	get_tree().change_scene("res://FinalScore/FinalScore.tscn")

func _on_SlimeTick_timeout():
	move_slime()
	check_plant()
	draw_plant()
	draw_slime()
	check_plant_farmed()
	check_season()
	
func _process(delta):
	check_game_over()

#Funktion zum initialisieren von mehreren plants + ihren Bildern
func init_plant():
	for y in range(plant_pos.size()):
		delete_tiles(y)
	plant_pos.clear()
	plant_pic.clear()
	
	for i in range (10):
		plant_pos.append(place_plant())
		var x = rand_range(0,6) #range: const der tiles
		plant_pic.append(x)

#löscht ab und zu alte plants und erstellt neue
func check_plant():
	if plant_time < int(14-$Timer.time_left):
		plant_time = int(14-$Timer.time_left)
		if plant_time % 3 ==0:
			plant_pos.append(place_plant())
			var y = rand_range(0,6) 
			plant_pic.append(y)
		if plant_time % 6 ==0:
			var x = rand_range(0,plant_pos.size())
			delete_tiles(plant_pic[x])
			plant_pos.remove(x)
			plant_pic.remove(x)
		if plant_time %14 ==13:
			plant_time = 0
		
#"season change" nach 14 sek
func check_season():
	if  season_x < int(14-$Timer.time_left):
		season_x = int(14- $Timer.time_left)
		if season_x%14 == 10:
			$Sounds/Countdown.play(0)
		if season_x%14 == 13:
			season=(season+1) % 4
			$Timer.start(15)
			season_x = 0
		if season == 0:
			update_season_plants("res://Graphics/blue_berry.png", "res://Graphics/purple_flower.png","res://Graphics/spring_icon.png")
			$TextureRect.texture = load("res://Graphics/spring.png")
		elif season == 1:
			update_season_plants("res://Graphics/blue_flower.png", "res://Graphics/red_berry.png", "res://Graphics/summer_icon.png")
			$TextureRect.texture = load("res://Graphics/grass.png")
		elif season == 2:
			update_season_plants("res://Graphics/purple_flower.png", "res://Graphics/yellow_flower.png","res://Graphics/fall_icon.png")
			$TextureRect.texture = load("res://Graphics/fall.png")
		elif season == 3:
			update_season_plants("res://Graphics/mint.png", "res://Graphics/blue_flower.png", "res://Graphics/winter_icon.png")
			$TextureRect.texture = load("res://Graphics/snow.png")

func update_score(slime_length):
	$HUD/Score/Score.text = str(slime_length)
 
func update_health(slime_health):
	if health == 3 :
		$HUD/Health/Sprite1.visible = true;
		$HUD/Health/Sprite2.visible = true;
		$HUD/Health/Sprite3.visible = true;
	elif health == 2:
		$HUD/Health/Sprite1.visible = true;
		$HUD/Health/Sprite2.visible = true;
		$HUD/Health/Sprite3.visible = false;
	elif health == 1:
		$HUD/Health/Sprite1.visible = true;
		$HUD/Health/Sprite2.visible = false;
		$HUD/Health/Sprite3.visible = false;
	elif health == 0:
		$HUD/Health/Sprite1.visible = false;
		$HUD/Health/Sprite2.visible = false;
		$HUD/Health/Sprite3.visible = false;

func update_season_plants(seasonPlant1, seasonPlant2, seasonIcon):
	$HUD/Season/SeasonSprite1.texture = load(seasonPlant1)
	$HUD/Season/SeasonSprite2.texture = load(seasonPlant2)
	$HUD/Season/SeasonSprite3.texture = load(seasonIcon)


func _on_Restart_pressed():
	get_tree().paused = false
	$Sounds/Button.play(0)
	get_tree().change_scene("res://MainScene/Main.tscn");

func _on_Menu_pressed():
	get_tree().paused = false
	$Sounds/Button.play(0)
	get_tree().change_scene("res://TitleScreen/TitleScreen.tscn");

func _on_Quit_pressed():
	get_tree().paused = false
	$Sounds/Button.play(0)
	get_tree().quit();$Sounds/Button.play(0)
	get_tree().change_scene("res://TitleScreen/TitleScreen.tscn");

func _on_Cancel_pressed():
	get_tree().paused = false
	$PauseMenu/CanvasLayer/Panel.visible = false
