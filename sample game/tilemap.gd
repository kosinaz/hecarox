extends Node2D

var fov = Fov.new()
var _tween = null
var floors = [0, 3, 11]
var foundations = [1, 4, 7]
var walls = [2, 5, 8, 14]
var doors = [8, 14]
var wall_cells = []
var map_position = Vector2()
var current_fov = []
var time = 0
var dead = false
onready var hero = $Hero
onready var tilemap = $TileMap
onready var tilemap2 = $TileMap2

func _ready():
	tilemap.hide()
	for i in foundations:
		wall_cells.append_array(tilemap.get_used_cells_by_id(i))
	for i in walls:
		wall_cells.append_array(tilemap.get_used_cells_by_id(i))
	map_position = tilemap.world_to_map(hero.position)
	draw_fov()

func _process(_delta):
	if dead:
		return
	if not _tween == null and  _tween.is_running():
		return
	var animation = "idle"
	map_position = tilemap.world_to_map(hero.position)
	if Input.is_key_pressed(KEY_LEFT):
		if floors.has(tilemap.get_cell(map_position.x - 1, map_position.y)):
			map_position.x -= 1
			hero.get_node("AnimatedSprite").flip_h = true
			animation = "walk"
	elif Input.is_key_pressed(KEY_RIGHT):
		if floors.has(tilemap.get_cell(map_position.x + 1, map_position.y)):
			map_position.x += 1
			hero.get_node("AnimatedSprite").flip_h = false
			animation = "walk"
	if Input.is_key_pressed(KEY_UP):
		if doors.has(tilemap.get_cell(map_position.x, map_position.y - 1)):
			tilemap.set_cell(map_position.x, map_position.y - 1, 11)
			wall_cells.erase(Vector2(map_position.x, map_position.y - 1))
		if map_position == Vector2(2, -20):
			if tilemap.get_cell(2, -21) == 17:
				tilemap.set_cell(2, -21, 20)
				for x in range(0, 5):
					tilemap.set_cell(x, -19, 6)
					for y in range(-18, -14):
						tilemap.set_cell(x, y, 9)
				for enemy in get_tree().get_nodes_in_group("enemies"):
					var enemy_map_position = tilemap.world_to_map(enemy.position)
					if -1 < enemy_map_position.x and enemy_map_position.x < 5:
						if  -20 < enemy_map_position.y and enemy_map_position.y < -14:
							enemy.queue_free()
				for enemy in get_tree().get_nodes_in_group("corpses"):
					var enemy_map_position = tilemap.world_to_map(enemy.position)
					if -1 < enemy_map_position.x and enemy_map_position.x < 5:
						if  -20 < enemy_map_position.y and enemy_map_position.y < -14:
							enemy.queue_free()
			elif tilemap.get_cell(2, -21) == 20:
				tilemap.set_cell(2, -21, 17)
				for x in range(0, 5):
					for y in range(-19, -14):
						tilemap.set_cell(x, y, 3)
			animation = "walk"
			draw_fov()
		if floors.has(tilemap.get_cell(map_position.x, map_position.y - 1)):
			map_position.y -= 1
			animation = "walk"
	elif Input.is_key_pressed(KEY_DOWN):
		if floors.has(tilemap.get_cell(map_position.x, map_position.y + 1)):
			map_position.y += 1
			animation = "walk"
	hero.get_node("AnimatedSprite").play(animation)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.get_node("AnimatedSprite").play("idle")
	if animation == "idle":
		return
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if map_position == tilemap.world_to_map(enemy.position):
			if enemy.name.begins_with("Imp"):
				enemy.get_node("AnimatedSprite").play("die")
				enemy.remove_from_group("enemies")
				enemy.add_to_group("corpses")
				enemy.z_index = 0
			if enemy.name.begins_with("Golem"):
				hero.get_node("AnimatedSprite").play("die")
				hero.z_index = 0
				enemy.get_node("AnimatedSprite").play("walk")
				dead = true
	time += 1
	_tween = get_tree().create_tween()
	_tween.set_parallel()
	_tween.tween_property(hero, "position", map_position * 16 + Vector2(8, 8), 0.25)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.name.begins_with("Golem") and time % 2:
			continue
		var enemy_map_position = tilemap.world_to_map(enemy.position)
		if current_fov.has(enemy_map_position):
			if enemy_map_position.x < map_position.x:
				if floors.has(tilemap.get_cell(enemy_map_position.x + 1, enemy_map_position.y)):
					enemy_map_position.x += 1
					enemy.get_node("AnimatedSprite").flip_h = false
			if enemy_map_position.x > map_position.x:
				if floors.has(tilemap.get_cell(enemy_map_position.x - 1, enemy_map_position.y)):
					enemy_map_position.x -= 1
					enemy.get_node("AnimatedSprite").flip_h = true
			if enemy_map_position.y < map_position.y:
				if floors.has(tilemap.get_cell(enemy_map_position.x, enemy_map_position.y + 1)):
					enemy_map_position.y += 1
			if enemy_map_position.y > map_position.y:
				if floors.has(tilemap.get_cell(enemy_map_position.x, enemy_map_position.y - 1)):
					enemy_map_position.y -= 1
			_tween.tween_property(enemy, "position", enemy_map_position * 16 + Vector2(8, 8), 0.25)
			enemy.get_node("AnimatedSprite").play("walk")
			if map_position == enemy_map_position:
				hero.get_node("AnimatedSprite").play("die")
				hero.z_index = 0
				dead = true
	draw_fov()

func draw_fov():
	current_fov = fov.calculate(map_position.x, map_position.y, 7, wall_cells)
	tilemap2.clear()
	for cell_map_position in current_fov:
		var cell = tilemap.get_cell(cell_map_position.x, cell_map_position.y)
		var cell_above = tilemap.get_cell(cell_map_position.x, cell_map_position.y - 1)
		var cell_map_position_above = cell_map_position + Vector2(0, -1)
		if current_fov.has(cell_map_position_above) and floors.has(cell_above) and walls.has(cell):
			cell -= 1
		tilemap2.set_cell(cell_map_position.x, cell_map_position.y, cell)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.visible = current_fov.has(tilemap.world_to_map(enemy.position))
	for enemy in get_tree().get_nodes_in_group("corpses"):
		enemy.visible = current_fov.has(tilemap.world_to_map(enemy.position))

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

