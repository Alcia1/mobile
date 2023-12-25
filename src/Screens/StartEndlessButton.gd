extends TextureButton

func _on_pressed():
	#var GT = preload("res://src/levels/generation_test/EndlessGame.tscn")
	#get_tree().root.add_child(GT.instantiate())
	#get_parent().get_parent().get_parent().get_parent().queue_free()
	#SceneManager.changeScene("res://src/levels/generation_test/EndlessGame.tscn", "MainMenu")
	get_tree().change_scene_to_file("res://src/levels/generation_test/EndlessGame.tscn")
