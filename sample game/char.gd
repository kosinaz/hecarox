extends Node2D

var tween = null

func _unhandled_input(event):
	if not tween == null and tween.is_running():
		return
	if  event.is_action_pressed("ui_left"):
		tween = get_tree().create_tween()
		tween.tween_property(self, "position:x", position.x - 16.0, 0.5)
	if  event.is_action_pressed("ui_right"):
		tween = get_tree().create_tween()
		tween.tween_property(self, "position:x", position.x + 16.0, 0.5)
	if  event.is_action_pressed("ui_up"):
		tween = get_tree().create_tween()
		tween.tween_property(self, "position:y", position.y - 16.0, 0.5)
	if  event.is_action_pressed("ui_down"):
		tween = get_tree().create_tween()
		tween.tween_property(self, "position:y", position.y + 16.0, 0.5)
