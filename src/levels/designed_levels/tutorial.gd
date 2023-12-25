extends "res://src/levels/designed_levels/base.gd"

@onready var tutorial = find_child("tutorial")

var currentMessage = 0

func switchMessage():
	var tween = get_tree().create_tween()
	tween.tween_property(tutorial.get_child(currentMessage), "modulate:a", 0, 1)
	await tween.finished
	tutorial.get_child(currentMessage).visible = false
	currentMessage += 1
	tween.kill()
	
	tween = get_tree().create_tween()
	tutorial.get_child(currentMessage).visible = true
	tween.tween_property(tutorial.get_child(currentMessage), "modulate:a", 1, 1)
	await tween.finished

func _on_trigger_body_exited(body):
	if body is CharacterBody2D:
		switchMessage()
		get_child(6).get_child(0).queue_free()
