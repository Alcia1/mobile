extends TextureButton

@export var level = 1

func _on_pressed():
	get_tree().change_scene_to_file("res://src/levels/designed_levels/level"+str(level)+".tscn")

func displayCompleted():
	get_child(1).visible = true

