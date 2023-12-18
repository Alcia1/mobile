extends Area2D

func _on_body_entered(body):
	if body is CharacterBody2D:
		get_parent().get_parent().call_deferred("loadNextChunk")
		self.call_deferred("set_process_mode", PROCESS_MODE_DISABLED)

func _on_visible_on_screen_notifier_2d_screen_exited():
	get_parent().queue_free()
