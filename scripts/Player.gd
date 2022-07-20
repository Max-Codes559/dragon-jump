extends KinematicBody2D

const MenuScene = preload("res://scenes/Menu.tscn")
onready var Main = get_parent()
onready var animation = $AnimationPlayer
onready var CameraM = get_node("../Camera2D")
onready var sprite = $Sprite
onready var AttBox = $AttBox
onready var KickBox = $KickBox
onready var KickBoxShape = $KickBox/CollisionShape2D
onready var CoyoteTimer = $CoyoteTimer
onready var PlayerSound = $PlayerSound
onready var PickupSound = $PickupSound

var JumpSound = preload("res://assets/sounds/Retro FootStep 03.wav")
var TreasureSound = preload("res://assets/sounds/Retro PickUp Coin 07.wav")
var HealthSound = preload("res://assets/sounds/Retro PickUp 18.wav")
#Impact and explosion are both played from spider
const up = Vector2(0, -1)
var motion = Vector2()
export(int, 1, 20) var Speed = 1
var MaxSpeed = 12500 * Speed

const DashSpeed = 32500
var Dashes = 2 
var DashDirect = Vector2.ZERO
var DashingMove = false
var DashingInv = false
#Invincibility from dashing, slightly longer than move
var DashMoveTime = 0.4
var DashGraceTime = 0.3

var Kicking = false
#set true and false with animation

export var gravity = 15
var DefMFS = 300
var MaxFallSpeed = DefMFS
var GlideSpeed = 100
const JumpForce = 400
var jumps = 2
var CanGlide = false
var Gliding = false
var IsFalling = false
var IsJumping = false

func dash():
	if DashingInv == false and Kicking == false:
		animation.play("Dash")
		DashDirect = get_local_mouse_position()
		if DashDirect != Vector2.ZERO:
			DashDirect = DashDirect.normalized()
			DashDirect *= DashSpeed
			#motion = Vector2(DashDirect.x * 10 * DashSpeed, DashDirect.y * DashSpeed)
		
			if DashDirect.x > 0:
				sprite.flip_h = false
			elif DashDirect.x < 0:
				sprite.flip_h = true
			
		MaxFallSpeed = DefMFS

func set_dashing():
	if DashingInv == false:
		AttBox.monitorable = true
		DashingMove = true
		DashingInv = true
		yield(get_tree().create_timer(DashMoveTime, false), "timeout")
		DashingMove = false
		
		yield(get_tree().create_timer(DashGraceTime, false), "timeout")
		AttBox.monitorable = false
		DashingInv = false
		print("Dash ended")
		Dashes -= 1
	
func jump():
	if jumps > 0 and Kicking == false:
		IsJumping = true
		animation.play("JumpUp")
		PlayerSound.stream = JumpSound
		PlayerSound.playing = true
		motion.y = -JumpForce
		jumps -= 1
		#double jump
func glide():
	if Kicking == false:
		Gliding = true
		MaxFallSpeed = GlideSpeed
		animation.play("Gliding")
		print("gliding")
		#glide function
func kick():
	if DashingInv == false:
		Kicking = true
		if sprite.flip_h == false:
			KickBoxShape.position.x = 18
		elif sprite.flip_h == true:
			KickBoxShape.position.x = -24
		
		KickBox.monitorable = true
		animation.play("Kick")
		yield(get_tree().create_timer(0.8, false), "timeout")
	
		Kicking = false
		KickBox.monitorable = false
		print("Kick ended")
		print(Kicking)
func falling(delta):
	if DashingMove == false and CoyoteTimer.is_stopped():
		motion.y += gravity * delta * 53
		if motion.y > MaxFallSpeed and DashingInv == false:
			motion.y = MaxFallSpeed
			#maxes out fall speed at MaxFallSpeed
func walking(delta):
	#enables built in movement function
	if Input.is_action_pressed("left") and DashingMove == false:
		motion.x = lerp(motion.x, -MaxSpeed * delta, 0.2)
		sprite.flip_h = true
		if is_on_floor() == true:
			animation.queue("Walking")
			animation.playback_speed = abs(motion.x/150)
	elif Input.is_action_pressed("right") and DashingMove == false:
		motion.x = lerp(motion.x, MaxSpeed * delta, 0.2)
		sprite.flip_h = false
		if is_on_floor() == true:
			animation.queue("Walking")
			animation.playback_speed = abs(motion.x/150)
	else:
		animation.playback_speed = 1
		if is_on_floor() == true:
			 motion.x = lerp(motion.x, 0, 0.5)
			#friction
		elif is_on_floor() == false:
			motion.x = lerp(motion.x, 0, 0.025)

	if Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		if animation.current_animation == "Walking":
			animation.stop()
			sprite.frame = 0
			#air resistance
		#basic walking
func floor_reset():
	jumps = 2
	MaxFallSpeed = DefMFS
	CanGlide = false
	Dashes = 2
	IsFalling = false
	IsJumping = false
	if sprite.frame == 8:
		sprite.frame = 0
	if Gliding == true:
		animation.stop()
		Gliding = false
		sprite.frame = 0

func _physics_process(delta):
	var was_on_floor = is_on_floor()
	motion = move_and_slide(motion, up)
	if !is_on_floor() and was_on_floor and !IsJumping:
		CoyoteTimer.start()
		motion.y = 0
	if DashingMove == true:
		motion = DashDirect * delta
	if motion.y > 200 and is_on_floor() == false and IsFalling == false and DashingMove == false:
		IsFalling = true
		animation.queue("Falling")
		#plays falling animation
	falling(delta)
	walking(delta)
	
	if is_on_floor() == true:
		floor_reset()

func _input(event):
	if Input.is_action_just_pressed("jump"):
		jump()
		if jumps == 0 and CanGlide == true:
			if MaxFallSpeed == DefMFS:
				glide()
			elif MaxFallSpeed == GlideSpeed:
				MaxFallSpeed = DefMFS
				animation.stop()
				#jump/glide
	if Input.is_action_just_released("jump") and jumps == 0:
				CanGlide = true
				print("CanGlide true")
				#enables glide
	if Input.is_action_just_pressed("kick"):
		kick()
		
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE and not CameraM.has_node("Menu"):
			get_tree().paused = true
			var ActMenu = MenuScene.instance()
			CameraM.add_child(ActMenu)
			print("menu opened")
		#Menu
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if Dashes > 0:
				dash()
				#Dash
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			if MaxFallSpeed == DefMFS:
				glide()
			elif MaxFallSpeed == GlideSpeed:
				MaxFallSpeed = DefMFS
				animation.stop()

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "Dash":
		set_dashing()
		print("Dash started")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Dash" or anim_name == "Kick":
		sprite.frame = 0

	if anim_name == "Falling" or anim_name == "JumpUp":
		sprite.frame = 8

func _on_PlayerHitBox_area_entered(area):
	if area.name == "TreasurePU":
		PickupSound.stream = TreasureSound
		PickupSound.playing = true
		print("Treasure sound Play")
	if area.name == "HealthPU" and Main.player_health < 3:
		PickupSound.stream = HealthSound
		PickupSound.playing = true
