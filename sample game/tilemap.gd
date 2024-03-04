extends Node2D

var _tween = null
		
func _process(_delta):
	if not _tween == null and  _tween.is_running():
		return
	var pos = $TileMap.world_to_map($Char.position)
	var cell = $TileMap.get_cell(pos.x, pos.y)
	if Input.is_key_pressed(KEY_LEFT) and not cell == -1:
		_tween = get_tree().create_tween()
		_tween.tween_property($Char, "position:x", $Char.position.x - 16.0, 0.25)
		$Char/AnimatedSprite.play("walk_left")
	elif Input.is_key_pressed(KEY_RIGHT):
		_tween = get_tree().create_tween()
		_tween.tween_property($Char, "position:x", $Char.position.x + 16.0, 0.25)
		$Char/AnimatedSprite.play("walk_right")
	elif Input.is_key_pressed(KEY_UP):
		_tween = get_tree().create_tween()
		_tween.tween_property($Char, "position:y", $Char.position.y - 16.0, 0.25)
		$Char/AnimatedSprite.play("walk_up")
	elif Input.is_key_pressed(KEY_DOWN):
		_tween = get_tree().create_tween()
		_tween.tween_property($Char, "position:y", $Char.position.y + 16.0, 0.25)
		$Char/AnimatedSprite.play("walk_down")
	elif $Char/AnimatedSprite.animation == "walk_left":
		$Char/AnimatedSprite.play("idle_left")
	elif $Char/AnimatedSprite.animation == "walk_right":
		$Char/AnimatedSprite.play("idle_right")
	elif $Char/AnimatedSprite.animation == "walk_up":
		$Char/AnimatedSprite.play("idle_up")
	elif $Char/AnimatedSprite.animation == "walk_down":
		$Char/AnimatedSprite.play("idle_down")

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

