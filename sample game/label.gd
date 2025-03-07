extends RichTextLabel

func _on_Timer_timeout():
	visible_characters += 1

func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://main.tscn")
