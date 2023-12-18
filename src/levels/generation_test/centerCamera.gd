extends Camera2D

var player

func _ready():
	player = get_parent().find_child("player")

func _physics_process(_delta):
	if self.position.y > player.position.y - 100:
		self.position.y = player.position.y - 100
		if int(self.position.y) % 3 == 0:
			player.point_count += 1
		if int(self.position.y) % 50 == 0:
			player.distance_travelled += 1

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		body.call_deferred("hit")
