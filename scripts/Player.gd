extends KinematicBody2D

const MenuScene = preload("res://scenes/Menu.tscn")
onready var Main = get_parent()
onready var animation = $AnimationPlayer
onready var CameraM = get_node("../Camera2D")
onready var sprite = $Sprite
onready var AttBox = $AttBox
onready var AttBoxShape = $AttBox/CollisionShape2D
onready var KickBox = $KickBox
onready var KickBoxShape = $KickBox/CollisionShape2D
onready var CoyoteTimer = $CoyoteTimer
onready var StunTimer = $StunTimer
onready var PlayerSound = $PlayerSound
onready var PickupSound = $PickupSound

onready var LevelMusic = $LevelMusic
const DashSound = preload("res://assets/sounds/Dash_other.wav")
const KickSound = preload("res://assets/sounds/Kick_sound.wav")
const JumpSound = preload("res://assets/sounds/Retro FootStep 03.wav")
const HurtSound = preload("res://assets/sounds/Bone hit.wav")
const KnockbackLargeSound = preload("res://assets/sounds/Retro Event Wrong Simple 07.wav")
const TreasureSound = preload("res://assets/sounds/Retro PickUp Coin 07.wav")
const HealthSound = preload("res://assets/sounds/Retro PickUp 18.wav")
#Impact and explosion are both played from spider
var stunned = false
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

func death():
	motion = Vector2.ZERO
	DashingMove = false
	animation.play("respawn")
	stunned = true
	StunTimer.start()

func play_sound(sound, volume: int = 0):
	PlayerSound.stream = sound
	PlayerSound.volume_db = volume
	PlayerSound.playing = true

func knockback(direction):
	motion = Vector2.ZERO
	var KnockbackD = global_position - direction
	KnockbackD = KnockbackD.normalized()
	motion = KnockbackD * 700
	play_sound(HurtSound)
	
func knockback_large_enemy(direction):
	DashingMove = false
	stunned = true
	StunTimer.start()
	var KnockbackD = global_position - direction
	KnockbackD = KnockbackD.normalized()
	motion = KnockbackD * Vector2(1000, 500)
	play_sound(KnockbackLargeSound, -13)
	
func grace(start_end, direction):
	if start_end == "start":
		sprite.modulate = Color(1, 1, 1, 0.5)
		StunTimer.start()
		stunned = true
		sprite.frame = 4
		knockback(direction)
		
	if start_end == "end":
		sprite.modulate = Color(1, 1, 1, 1)

func dash_accessable(AccDashDirect):
	if DashingInv == false and Kicking == false:
		animation.play("Dash")
		play_sound(DashSound)
		
		DashDirect = AccDashDirect
		AccDashDirect = AccDashDirect.normalized()
		AccDashDirect *= DashSpeed
	
		if AccDashDirect.x > 0:
			sprite.flip_h = false
		elif AccDashDirect.x < 0:
			sprite.flip_h = true
			
		MaxFallSpeed = DefMFS

func dash():
	if DashingInv == false and Kicking == false:
		animation.play("Dash")
		play_sound(DashSound)
		DashDirect = get_local_mouse_position()
		if DashDirect != Vector2.ZERO:
			DashDirect = DashDirect.normalized()
			DashDirect *= DashSpeed
		
			if DashDirect.x > 0:
				sprite.flip_h = false
			elif DashDirect.x < 0:
				sprite.flip_h = true
			
		MaxFallSpeed = DefMFS

func set_dashing():
	if DashingInv == false:
		AttBox.monitorable = true
		AttBoxShape.set_deferred("disabled", false)
		DashingMove = true
		DashingInv = true
		yield(get_tree().create_timer(DashMoveTime, false), "timeout")
		DashingMove = false
		
		yield(get_tree().create_timer(DashGraceTime, false), "timeout")
		AttBox.monitorable = false
		AttBoxShape.set_deferred("disabled", true)
		DashingInv = false
		Dashes -= 1
	
func jump():
	if jumps > 0 and Kicking == false:
		IsJumping = true
		animation.play("JumpUp")
		play_sound(JumpSound)
		motion.y = -JumpForce
		jumps -= 1
		#double jump

func glide():
	if Kicking == false:
		Gliding = true
		MaxFallSpeed = GlideSpeed
		animation.play("Gliding")
		#glide function

func kick():
	if DashingInv == false:
		Kicking = true
		play_sound(KickSound)
		if sprite.flip_h == false:
			KickBoxShape.position.x = 18
		elif sprite.flip_h == true:
			KickBoxShape.position.x = -24
		
		KickBox.monitorable = true
		KickBoxShape.set_deferred("disabled", false)
		animation.play("Kick")
		yield(get_tree().create_timer(0.8, false), "timeout")
	
		Kicking = false
		KickBox.monitorable = false
		KickBoxShape.set_deferred("disabled", true)

func falling(delta):
	if DashingMove == false and CoyoteTimer.is_stopped():
		motion.y += gravity * delta * 53
		if motion.y > MaxFallSpeed and DashingInv == false:
			motion.y = MaxFallSpeed
			#maxes out fall speed at MaxFallSpeed
func walking(delta):
	#enables built in movement function
	if stunned == false:
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
	elif stunned == true:
		animation.stop()
		sprite.frame = 4
		animation.playback_speed = 1
		if is_on_floor() == true:
			 motion.x = lerp(motion.x, 0, 0.025)
			#friction while stunned = less
		elif is_on_floor() == false:
			motion.x = lerp(motion.x, 0, 0.025)
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

func _ready():
	Main.connect("hurt_grace", self, "grace")
	Main.connect("player_death", self, "death")

func _physics_process(delta):
	var was_on_floor = is_on_floor()
	motion = move_and_slide(motion, up)
	if !is_on_floor() and was_on_floor and !IsJumping:
		CoyoteTimer.start()
		motion.y = 0
	if DashingMove == true:
		motion = DashDirect.normalized() * delta * 36000
	if motion.y > 200 and is_on_floor() == false and IsFalling == false and DashingMove == false:
		IsFalling = true
		animation.queue("Falling")
		#plays falling animation
	falling(delta)
	walking(delta)
	
	if is_on_floor() == true:
		floor_reset()

func _input(event):
	if Input.is_action_just_pressed("MusicToggle"):
		if LevelMusic.MusicOn == true:
			LevelMusic.MusicOn = false
			LevelMusic.stop()
			#Music off
		elif LevelMusic.MusicOn == false:
			LevelMusic.MusicOn = true
			#Music on
	if stunned == false:
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
					#enables glide
		if Input.is_action_just_pressed("kick"):
			kick()
			
		if Input.is_action_just_pressed("dash_left"):
			if Dashes > 0:
				dash_accessable(Vector2(-1, -0.1))
				
		if Input.is_action_just_pressed("dash_right"):
			if Dashes > 0:
				dash_accessable(Vector2(1, -0.1))
				
		if Input.is_action_just_pressed("dash_up"):
			if Dashes > 0:
				dash_accessable(Vector2(0, -1))
			
		if Input.is_action_just_pressed("dash_down"):
			if Dashes > 0:
				dash_accessable(Vector2(0, 1))
			
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
		
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE and not CameraM.has_node("Menu"):
			get_tree().paused = true
			var ActMenu = MenuScene.instance()
			CameraM.add_child(ActMenu)
		#Menu

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "Dash":
		set_dashing()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Dash" or anim_name == "Kick":
		sprite.frame = 0

	if anim_name == "Falling" or anim_name == "JumpUp":
		sprite.frame = 8

func _on_PlayerHitBox_area_entered(area):
	if area.name == "TreasurePU":
		PickupSound.stream = TreasureSound
		PickupSound.playing = true
	if area.name == "HealthPU" and Main.player_health < 3:
		PickupSound.stream = HealthSound
		PickupSound.playing = true
#damage handled between enemy scripts and main
func _on_StunTimer_timeout():
	stunned = false
	sprite.frame = 0

func _on_PlayerSound_finished():
	PlayerSound.volume_db = 0
