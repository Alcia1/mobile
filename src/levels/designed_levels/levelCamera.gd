extends Camera2D

var player
var moving = true

func _ready():
	player = get_parent().find_child("player")

func _physics_process(_delta):
	if player != null and moving:
		self.position.y = player.position.y - 100
