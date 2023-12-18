extends Node2D

var chunk1 = preload("res://src/levels/generation_test/chunks/test1.tscn")

#load next chunk when player passes area2d
var chunk2 = preload("res://src/levels/generation_test/chunks/test2.tscn")
var chunk3 = preload("res://src/levels/generation_test/chunks/test3.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print(chunk1.can_instantiate())
	var instance = chunk1.instantiate()
	var pos = Vector2(0, -648)
	instance.position = pos
	add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
