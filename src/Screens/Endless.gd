extends TextureButton

func _on_pressed():
	get_parent().get_child(5).get_child(0).animate(true)
