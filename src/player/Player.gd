#naprawić flip dasha kiedy dashujesz w przeciwną stronę w którą idziesz

extends CharacterBody2D

const PX_PER_SEC_DASH = 0.1/100
const GRAVITY = 450.0
const WALK_SPEED = 80 #150

#var velocity = Vector2(0,0)

var jump_count = 2
var dash_count = 1
var dashing = false

###do testów###
@onready var debug_labels = get_parent().find_child("debug").get_child(0)

func _physics_process(delta):
	debug_labels.get_child(4).text = str(Engine.get_frames_per_second()) #statystki debugowania
	debug_labels.get_child(3).text = str(Input.get_accelerometer().x)
	debug_labels.get_child(1).text = str(dash_count)
	if is_on_floor() and dashing == false: #reset dasha i skoku
		jump_count = 2
		dash_count = 1
		debug_labels.get_child(0).text = "on floor"
	else:
		debug_labels.get_child(0).text = "not on floor"
	
	if velocity.y < 240 and !dashing: #max prędkość spadania
		velocity.y += delta * GRAVITY
	elif dashing and velocity.y >= 0:
		velocity.y = 0
	
	if abs(Input.get_accelerometer().x) > 0.8: #obliczanie szybkości i kierunku
		velocity.x = Input.get_accelerometer().x * WALK_SPEED
	elif abs(velocity.x) <= 15: #zatrzymanie się, lepsze niż zwykłe else, ponieważ ruch jest trochę bardziej płynny
		velocity.x = 0
	
	if velocity.x > 0: #prawo
		velocity.x -= 15 #podczas chodzenia, zwolnij postać o 15px, dzięki temu (i ifie wyżej) postać może stanąć w miejscu
	elif velocity.x < 0:
		velocity.x += 15 #podczas chodzenia, zwolnij postać o 15px, dzięki temu (i ifie wyżej) postać może stanąć w miejscu
	
	#do testów#
	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED * 2
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED * 2
	elif Input.is_action_just_pressed("ui_up"):
		jump()
	
	if $AnimatedSprite2D.animation != "idle" and $AnimatedSprite2D.is_playing() == true:
		$AnimationPlayer.pause()
	
	#ustaw animacje
	if dashing == false:
		if velocity.y > 0 and !is_on_floor():
			$AnimatedSprite2D.play("fall")
		if velocity.y < 0 and !is_on_floor():
			$AnimatedSprite2D.play("jump")
		elif velocity.x != 0 and is_on_floor():
			$AnimatedSprite2D.play("walk")
			if velocity.x > 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		elif velocity.x == 0 and is_on_floor() and $AnimationPlayer.current_animation != "idle":
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.stop()
			$AnimationPlayer.play("idle")
	
# warning-ignore:return_value_discarded
	set_velocity(velocity)
	set_up_direction(Vector2(0, -1))
	move_and_slide()

func hit():
	self.modulate = Color(1,0,0)
	await get_tree().create_timer(0.5).timeout
	self.modulate = Color(1,1,1)

#zmienne do sprawdzenia kierunku swipe'a
var swipe_start = Vector2(0,0)
var swipe_end = Vector2(0,0)
var direction: int #direction 2 = góra, 1 = prawo, 0 = lewo

#sprawdzenie swipe'a i uruchomienie dasha
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			swipe_start = event.position #zbierz początek swipe'a
		else:
			swipe_end = event.position #zbierz koniec swipe'a
			
			if swipe_start == swipe_end:
				jump()
				return
			
			var x_diff = swipe_start.x - swipe_end.x
			var y_diff = swipe_start.y - swipe_end.y
			
			if y_diff > abs(x_diff):
				if y_diff < 10: #grace period
					jump()
					return
				direction = 2
				dash() #jeżeli różnica pomiędzy zmiennymi y jest większa niż pomiędzy x to dash w górę
			elif abs(x_diff) < 10 : #grace period
				jump()
				return
			elif x_diff > 0:
				direction = 0
				dash() #jeżeli różnica pomiędzy x jest większa od 0 to dashuj w lewo
			elif x_diff < 0:
				direction = 1
				dash() #jeżeli różnica pomiędzy x jest mniesza od 0 to dashuj w prawo

func jump():
	if !is_on_floor() and jump_count > 0:
		velocity.y = -210
		jump_count -= 2
		print("skok w powietrzu")
		
	elif jump_count > 0:
		velocity.y = -210
		jump_count -= 1
		print("skok z ziemi")

var touching_left_wall = false
var touching_right_wall = false
var touching_ceiling = false
var tween: Tween

#całkowity czas trwania dasha
func dashTimer():
	self.modulate = Color(0,1,0)
	await get_tree().create_timer(0.15).timeout
	dashing = false
	self.modulate = Color(1,1,1)
	
	velocity.x = 0
	velocity.y = 0
	
	if direction == 2:
		velocity.y -= 90

#ta funkcja kalkuluje ile pixeli powinien zostać przeniesiony gracz
#direction 2 = góra, 1 = prawo, 0 = lewo
#func dash():
#	var nowa_pozycja = Vector2(0,0)
#	var time = 0.1
#	tween = create_tween()
#	tween.stop()
#
#	if dash_count > 0:
#		dashing = true
#		if direction == 0 or direction == 1:
#			$AnimatedSprite2D.play("dash")
#		match direction:
#			0:
#				nowa_pozycja = Vector2(position.x-100, position.y)
#				if touching_left_wall: #jeżeli nowa pozycja wyjdzie poza granicę
#					nowa_pozycja.x = position.x #to nie poruszaj
#			1:
#				nowa_pozycja = Vector2(position.x+100, position.y)
#				if touching_right_wall: #jeżeli nowa pozycja wyjdzie poza granicę
#					nowa_pozycja.x = position.x #to nie poruszaj
#			2:
#				$AnimatedSprite2D.animation = "jump"
#				nowa_pozycja = Vector2(position.x, position.y-100)
#				if touching_ceiling: #jeżeli nowa pozycja wyjdzie poza granicę
#					nowa_pozycja.y = position.y #to nie poruszaj
#
#		tween.tween_property(self, "position", nowa_pozycja, time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
#		tween.play()
#		dash_count -= 1
#
#		dashTimer()
#
#		if direction == 2: #reset grawitacji
#			velocity.y = -200
#		else:
#			velocity.y = -50

func dash():
	if dash_count > 0:
		dashing = true
		if direction == 0 or direction == 1:
			$AnimatedSprite2D.play("dash")
		match direction:
			0:
				velocity.x -= 900
			1:
				velocity.x += 900
			2:
				$AnimatedSprite2D.animation = "jump"
				velocity.y -= 900
				print(velocity.y)
				pass
		
		dash_count -= 1
		dashTimer()

#zatrzymywanie się na ścianach 
func _on_up_stop_body_entered(body):
	if body.name != "player":
		touching_ceiling = true
		if tween and direction == 2:
			tween.kill()

func _on_up_stop_body_exited(body):
	if body.name != "player":
		touching_ceiling = false

func _on_left_stop_body_entered(body):
	if body.name != "player":
		touching_left_wall = true
		if tween and direction == 0:
			tween.kill()

func _on_left_stop_body_exited(body):
	if body.name != "player":
		touching_left_wall = false

func _on_right_stop_body_entered(body):
	if body.name != "player":
		touching_right_wall = true
		if tween and direction == 1:
			print("xd")
			tween.kill()

func _on_right_stop_body_exited(body):
	if body.name != "player":
		touching_right_wall = false

