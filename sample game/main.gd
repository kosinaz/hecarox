extends Node2D

onready var save = $Game.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("save"):
		save.queue_free()
		save = get_child(0).duplicate()
	if Input.is_action_just_released("load"):
		get_child(0).queue_free()
		add_child(save.duplicate())
	if Input.is_action_just_released("restart"):
		get_tree().reload_current_scene()
