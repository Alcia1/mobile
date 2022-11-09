#naprawić flip dasha kiedy dashujesz w przeciwną stronę w którą idziesz

extends KinematicBody2D

const PX_PER_SEC_DASH = 0.1/100
const GRAVITY = 450.0
const WALK_SPEED = 80 #150

var velocity = Vector2(0,0)

var jump_count = 2
var dash_count = 1
var dashing = ""

###do testów###
onready var debug_labels = get_parent().find_node("debug").get_child(0)

func _physics_process(delta):
	debug_labels.get_child(4).text = str(Engine.get_frames_per_second())
	debug_labels.get_child(3).text = str(Input.get_accelerometer().x)
	debug_labels.get_child(1).text = str(dash_count)
	if is_on_floor() and dashing == "":
		jump_count = 2
		dash_count = 1
		debug_labels.get_child(0).text = "on floor"
	else:
		debug_labels.get_child(0).text = "not on floor"
	
	if velocity.y < 240: #max prędkość spadania
		velocity.y += delta * GRAVITY
	
	if abs(Input.get_accelerometer().x) > 0.8: #obliczanie szybkości i kierunku
		velocity.x = Input.get_accelerometer().x * WALK_SPEED
	elif abs(velocity.x) <= 15: #zatrzymanie się, lepsze niż zwykłe else, ponieważ ruch jest trochę bardziej płynny
		velocity.x = 0
	
	if velocity.x > 0: #prawo
		flip_tail(false)
		velocity.x -= 15 #podczas chodzenia, zwolnij postać o 15px, dzięki temu (i ifie wyżej) postać może stanąć w miejscu
	elif velocity.x < 0:
		flip_tail(true)
		velocity.x += 15 #podczas chodzenia, zwolnij postać o 15px, dzięki temu (i ifie wyżej) postać może stanąć w miejscu
	
	#do testów#
	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED * 2
		
		flip_tail(true)
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED * 2
		
		flip_tail(false)
	elif Input.is_action_just_pressed("ui_up"):
		jump()
	
	if $AnimatedSprite.animation != "idle" and $AnimatedSprite.playing == false:
		$AnimationPlayer.stop()
		$AnimatedSprite.playing = true
	
	#ustaw animacje
	if dashing == "":
		if velocity.y > 0 and !is_on_floor():
			$AnimatedSprite.animation = "fall"
		if velocity.y < 0 and !is_on_floor():
			$AnimatedSprite.animation = "jump"
		elif velocity.x != 0 and is_on_floor():
			$AnimatedSprite.animation = "walk"
		elif velocity.x == 0 and is_on_floor():
			$AnimatedSprite.playing = false
			$AnimatedSprite.animation = "idle"
			$AnimationPlayer.play("idle")
	
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2(0, -1))

func hit():
	self.modulate = Color(1,0,0)
	yield(get_tree().create_timer(0.5), "timeout")
	self.modulate = Color(1,1,1)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Tween_tween_started(object, key):
	self.modulate = Color(0,1,0)
	$Timer.start(0.2)

func _on_Timer_timeout():
	if dashing == "lewo":
		$Tail.position = Vector2(6,0)
	elif dashing == "prawo":
		$Tail.position = Vector2(-6,0)
	dashing = ""
	self.modulate = Color(1,1,1)
	$Timer.stop()

#zmienne do sprawdzenia kierunku swipe'a
var swipe_start = Vector2(0,0)
var swipe_end = Vector2(0,0)
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
				dash(2) #jeżeli różnica pomiędzy zmiennymi y jest większa niż pomiędzy x to dash w górę
			elif abs(x_diff) < 10 : #grace period
				jump()
				return
			elif x_diff > 0: dash(0) #jeżeli różnica pomiędzy x jest większa od 0 to dashuj w lewo
			elif x_diff < 0: dash(1) #jeżeli różnica pomiędzy x jest mniesza od 0 to dashuj w prawo

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

#ta funkcja tylko kalkuluje o ile powinien zostać player przeniesiony i z jaką prędkością
#czasem trwania dasha zajmuje się timer
#direction 2 = góra, 1 = prawo, 0 = lewo
func dash(direction):
	var stara_pozycja = Vector2(0,0)
	var nowa_pozycja = Vector2(0,0)
	var time = 0.1
	
	if dash_count > 0 and direction == 0:
		dashing = "lewo"
		$AnimatedSprite.animation = "dash"
		flip_tail(true)
		$DashParticles.emitting = true
		
		stara_pozycja = position
		nowa_pozycja = Vector2(stara_pozycja.x-100, stara_pozycja.y)
		
		if touching_left_wall: #jeżeli nowa pozycja wyjdzie poza granicę
			nowa_pozycja.x = stara_pozycja.x #to nie poruszaj
		
		$Tween.interpolate_property(self, "position", stara_pozycja, nowa_pozycja, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		
		velocity.y = -50 #reset grawitacji
		dash_count -= 1
		
	elif dash_count > 0 and direction == 1:
		dashing = "prawo"
		$AnimatedSprite.animation = "dash"
		flip_tail(false)
		
		stara_pozycja = position
		nowa_pozycja = Vector2(stara_pozycja.x+100, stara_pozycja.y)
		
		if touching_right_wall: #jeżeli nowa pozycja wyjdzie poza granicę
			nowa_pozycja.x = stara_pozycja.x #to nie poruszaj
		
		$Tween.interpolate_property(self, "position", stara_pozycja, nowa_pozycja, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		
		velocity.y = -50 #reset grawitacji
		dash_count -= 1
		
	elif dash_count > 0 and direction == 2:
		dashing = "góra"
		$AnimatedSprite.animation = "jump"
		
		if touching_ceiling:
			$Tween.interpolate_property(self, "position:y", position.y, position.y, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$Tween.start()
		else:
			$Tween.interpolate_property(self, "position:y", position.y, position.y-100, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$Tween.start()
		
		velocity.y = -200
		dash_count -= 1

#zatrzymywanie się na ścianach 
func _on_up_stop_body_entered(body):
	if body.name != "player":
		touching_ceiling = true
		if dashing == "góra":
			$Tween.stop_all()

func _on_up_stop_body_exited(body):
	if body.name != "player":
		touching_ceiling = false

func _on_left_stop_body_entered(body):
	if body.name != "player":
		touching_left_wall = true
		if dashing == "lewo":
			$Tween.stop_all()

func _on_left_stop_body_exited(body):
	if body.name != "player":
		touching_left_wall = false

func _on_right_stop_body_entered(body):
	if body.name != "player":
		touching_right_wall = true
		if dashing == "prawo":
			$Tween.stop_all()

func _on_right_stop_body_exited(body):
	if body.name != "player":
		touching_right_wall = false

#zmienia parametry symulacji ogona i odbija w pione sprite
func flip_tail(walking_left):
	if walking_left == false and $AnimatedSprite.flip_h == false:
		$AnimatedSprite.set_flip_h(true)
		$Tail.position = Vector2(-6,0)
		$Tail/Particles2D.process_material.direction = Vector3(-1, 1, 0)
		$Tail/Particles2D.process_material.gravity = Vector3(-40, -40, 0)
		$Tail/Particles2D.process_material.tangential_accel = 20
	elif walking_left == true and $AnimatedSprite.flip_h == true:
		$AnimatedSprite.set_flip_h(false)
		$Tail.position = Vector2(6,0)
		$Tail/Particles2D.process_material.direction = Vector3(1, 1, 0)
		$Tail/Particles2D.process_material.gravity = Vector3(40, -40, 0)
		$Tail/Particles2D.process_material.tangential_accel = -20
