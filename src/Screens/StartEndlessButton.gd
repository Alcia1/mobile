extends TextureButton

func _on_pressed():
	var GT = preload("res://src/levels/generation_test/EndlessGame.tscn")
	get_tree().change_scene_to_packed(GT)
