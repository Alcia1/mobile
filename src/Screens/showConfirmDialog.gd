extends TextureButton

func _on_pressed():
	get_parent().find_child("ConfirmDialog").animate(true)
