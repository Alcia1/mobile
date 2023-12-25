extends Node

func changeScene(path :String, node :String):
	var packedScene = load(path)
	print(packedScene)
	get_tree().root.add_child(packedScene.instantiate())
	get_tree().root.get_node(node).queue_free()
