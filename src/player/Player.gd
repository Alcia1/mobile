extends CharacterBody2D

const PX_PER_SEC_DASH = 0.1/100
var GRAVITY = 450.0
const WALK_SPEED = 80 #150

#var velocity = Vector2(0,0)

var jump_count = 2
var dash_count = 1
var dashing = false
var dead = false

var point_count = 0
var distance_traveled = 0
var enemies_count = 0

var disable_input = false
var end_scene_set = false

var direction: int #direction 2 = góra, 1 = prawo, 0 = lewo

var sfx_disabled = false

###do testów### debug
@onready var debug_labels = get_parent().find_child("debug").get_child(0)
@onready var interface = get_parent().find_child("debug").get_child(2)

func _ready():
	if SaveGame.saveDataSettings["sfx"] == 0:
		sfx_disabled = true

func _physics_process(delta):
	#debug_labels.get_child(5).text = str(point_count)
	debug_labels.get_child(4).text = str(Engine.get_frames_per_second()) #statystki debugowania
	#debug_labels.get_child(3).text = str(Input.get_accelerometer().x)
	#debug_labels.get_child(1).text = str(dash_count)
	interface.get_child(1).text = str(point_count)
	if is_on_floor() and dashing == false: #reset dasha i skoku
		jump_count = 2
		dash_count = 1
		debug_labels.get_child(0).text = "on floor"
	else:
		debug_labels.get_child(0).text = "not on floor"
	
	if !Input.is_action_pressed("ctrl"): #do testów
		if velocity.y < 240 and !dashing: #max prędkość spadania
			velocity.y += delta * GRAVITY
		elif dashing and velocity.y >= 0:
			velocity.y = 0
	
	if Input.is_action_just_pressed("shift"):
		if Input.is_action_pressed("ui_left"):
			dash()
		elif Input.is_action_pressed("ui_right"):
			dash()
		else:
			dash()
		
	if !disable_input:###TEST DISABLE INPUT
		if Input.get_accelerometer().x > 1 and !dashing: #obliczanie szybkości i kierunku
			velocity.x = 2.2 * WALK_SPEED
		elif Input.get_accelerometer().x < -1 and !dashing:
			velocity.x = 2.2 * -WALK_SPEED
		elif !dashing: #zatrzymanie się, lepsze niż zwykłe else, ponieważ ruch jest trochę bardziej płynny
			#abs(velocity.x) <= 15 and 
			velocity.x = 0
	
	if !disable_input:
		if velocity.x > 0 and !dashing: #prawo
			velocity.x -= 15 #podczas chodzenia, zwolnij postać o 15px, dzięki temu (i ifie wyżej) postać może stanąć w miejscu
		elif velocity.x < 0 and !dashing:
			velocity.x += 15 #podczas chodzenia, zwolnij postać o 15px, dzięki temu (i ifie wyżej) postać może stanąć w miejscu
		
	#do testów#
	if !disable_input:###TEST DISABLE INPUT
		if Input.is_action_pressed("ui_left") and !dashing:
			velocity.x = -WALK_SPEED * 2
			direction = 0
		if Input.is_action_pressed("ui_right") and !dashing:
			velocity.x =  WALK_SPEED * 2
			direction = 1
		if Input.is_action_just_pressed("ui_up") and !dashing:
			direction = 2
			jump()
		if Input.is_key_pressed(KEY_CTRL):
			if Input.is_action_pressed("ui_up"):
				velocity.y = -WALK_SPEED * 2
			if Input.is_action_pressed("ui_down"):
				velocity.y = WALK_SPEED * 2
		
	###TEST END SCENE
	#if disable_input and is_on_floor() and !end_scene_set:
		#$AnimatedSprite2D.play("idle")
		#await get_tree().create_timer(1).timeout
		#$AnimatedSprite2D.play("walk")
		#velocity.x = WALK_SPEED * 2
		#end_scene_set = true
	
	#ustaw animacje
	if dashing == false and !dead:
		if velocity.y > 0 and !is_on_floor():
			$AnimatedSprite2D.play("fall")
		if velocity.y < 0 and !is_on_floor():
			$AnimatedSprite2D.play("jump")
		elif velocity.x != 0 and is_on_floor():
			$AnimatedSprite2D.play("walk")
		elif velocity.x == 0 and is_on_floor():
			$AnimatedSprite2D.animation = "idle"
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = true
		elif velocity.x < 0:
			$AnimatedSprite2D.flip_h = false
	
# warning-ignore:return_value_discarded
	set_velocity(velocity)
	set_up_direction(Vector2(0, -1))
	move_and_slide()
	

#debug
func hit():
	if !sfx_disabled:
		$sfxHit.play()
	disable_input = true
	dead = true
	GRAVITY = 0
	velocity.y = 0
	velocity.x = 0
	
	if get_parent().name == "EndlessGame":
		get_parent().find_child("Camera2D").moving = false
		if point_count > SaveGame.saveDataEndless["high_score"]:
			get_parent().find_child("debug").get_child(1).get_child(1).text = "New record!"
		get_parent().save()

	$AnimatedSprite2D.play("hit")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.disabled = true

	$hit.emitting = true
	if !sfx_disabled:
		$sfxGameOver.play()
	await get_tree().create_timer(2).timeout
	#$hit.emitting = false
	#self.process_mode = Node.PROCESS_MODE_DISABLED#in progress
	queue_free()

	get_parent().find_child("debug").get_child(1).animate(true)

#zmienne do sprawdzenia kierunku swipe'a
var swipe_start = Vector2(0,0)
var swipe_end = Vector2(0,0)

#sprawdzenie swipe'a i uruchomienie dasha
func _input(event):
	if event is InputEventScreenTouch and !disable_input:###TEST DISABLE INPUT
		if event.pressed:
			swipe_start = event.position #zbierz początek swipe'a
		else:
			swipe_end = event.position #zbierz koniec swipe'a
			
			if swipe_start.y > get_parent().find_child("debug").get_child(2).position.y + get_parent().find_child("debug").get_child(2).size.y:
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
	if !disable_input:###TEST DISABLE INPUT
		if !is_on_floor() and jump_count > 0:
			velocity.y = -250
			jump_count -= 2
			print("skok w powietrzu")
			if !sfx_disabled:
				$sfxJump.play()
		elif jump_count > 0:
			velocity.y = -250
			jump_count -= 1
			print("skok z ziemi")
			if !sfx_disabled:
				$sfxJump.play()

#całkowity czas trwania dasha
func dashTimer():
	#self.modulate = Color(0,1,0)
	await get_tree().create_timer(0.15).timeout
	dashing = false
	$dashCollision.disabled = true
	$Area2D/CollisionShape2D2.disabled = true
	#self.modulate = Color(1,1,1)
	
	velocity.x = 0
	velocity.y = 0
	
	if direction == 2:
		velocity.y -= 90

func dash():
	if dash_count > 0 and !disable_input:
		$dashCollision.disabled = false
		$Area2D/CollisionShape2D2.disabled = false
		if !sfx_disabled:
			$sfxDash.play()
		dashing = true
		if direction == 0 or direction == 1:
			$AnimatedSprite2D.play("dash")
		match direction:
			0:
				velocity.x -= 900
				$AnimatedSprite2D.flip_h = false
			1:
				velocity.x += 900
				$AnimatedSprite2D.flip_h = true
			2:
				$AnimatedSprite2D.play("dash_up")
				velocity.y -= 900
				pass
		
		dash_count -= 1
		dashTimer()

#debug
func _on_button_pressed():
	get_tree().reload_current_scene()

func _on_area_2d_body_entered(body):
	if body.name == "obstacles":
		hit()

func jumpPad():
	if !dashing:
		velocity.y = -400
