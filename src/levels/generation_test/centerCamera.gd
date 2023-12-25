extends Camera2D

var player
var moving = true
var start = false

func _ready():
	player = get_parent().find_child("player")

func _physics_process(_delta):
	if player != null and self.position.y > player.position.y - 100 and moving:
		self.position.y = player.position.y - 100
	
	if player != null and start and moving:
		self.position.y -= 1
		if int(self.position.y) % 3 == 0:
			player.point_count += 1
		if int(self.position.y) % 50 == 0:
			player.distance_traveled += 1
	
	if player != null:
		get_parent().find_child("debug").get_child(2).get_child(2).text = str(player.distance_traveled)

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		body.call_deferred("hit")
		moving = false

func _on_area_2d_2_body_entered(body):
	if body is CharacterBody2D:
		body.disable_input = true
		body.velocity.x = 0
		await get_tree().create_timer(1.5).timeout

		$Area2D.visible = true
		moving = true
		await get_tree().create_timer(0.3).timeout
		start = true
		body.disable_input = false
		get_parent().find_child("Area2D2").monitoring = false
