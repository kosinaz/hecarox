extends Node2D

var _tween = null
		
func _process(_delta):
	if not _tween == null and  _tween.is_running():
		return
	if Input.is_key_pressed(KEY_LEFT):
		_tween = get_tree().create_tween()
		_tween.tween_property(self, "position:x", position.x - 16.0, 0.5)
		$AnimatedSprite.play("walk_left")
	elif Input.is_key_pressed(KEY_RIGHT):
		_tween = get_tree().create_tween()
		_tween.tween_property(self, "position:x", position.x + 16.0, 0.5)
		$AnimatedSprite.play("walk_right")
	elif Input.is_key_pressed(KEY_UP):
		_tween = get_tree().create_tween()
		_tween.tween_property(self, "position:y", position.y - 16.0, 0.5)
		$AnimatedSprite.play("walk_up")
	elif Input.is_key_pressed(KEY_DOWN):
		_tween = get_tree().create_tween()
		_tween.tween_property(self, "position:y", position.y + 16.0, 0.5)
		$AnimatedSprite.play("walk_down")
	elif $AnimatedSprite.animation == "walk_left":
		$AnimatedSprite.play("idle_left")
	elif $AnimatedSprite.animation == "walk_right":
		$AnimatedSprite.play("idle_right")
	elif $AnimatedSprite.animation == "walk_up":
		$AnimatedSprite.play("idle_up")
	elif $AnimatedSprite.animation == "walk_down":
		$AnimatedSprite.play("idle_down")
