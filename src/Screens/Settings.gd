extends TextureButton

func _on_pressed():
	get_parent().get_child(4).get_child(0).animate(true)
