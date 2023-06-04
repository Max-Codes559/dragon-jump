extends KinematicBody2D

signal spider_died

onready var Main = $"../.."

onready var sprite = $Sprite
onready var animation = $AnimationPlayer
onready var EdgeCheckLeft = $EdgeCheckLeft
onready var EdgeCheckRight = $EdgeCheckRight
onready var WebRay = $WebRay
onready var AttBox = $AttBox
onready var AttBoxCollider = AttBox.get_child(0)
onready var ExplosionSound = $ExplosionSound
onready var PunchSound = $PunchSound
onready var WebLine = $WebLine
onready var WebBox = get_node("HitBox/WebBox")
onready var WebParticles = $WebParticles

onready var HitWall = $HitWall
onready var PhaseOneBox = HitWall.get_child(0)
onready var PhaseTwoBox = HitWall.get_child(1)
onready var Explosion = $Explosion

export(int, 10, 100) var SpeedTwo = 30
#export(String, "Vertical", "Horizontal") var Direction = "Vertical"
export var switch = 1

const up = Vector2(0, -1)
var motion = Vector2()
var PatrolPoint = Vector2.ZERO
var Position1 = Vector2.ZERO

var SecondPhaseAct = false
var gravity = 30
var MaxFallSpeed = 600
var IsFalling = false
var IsExploding = false

func Draw_web():
	yield(get_tree().create_timer(0.1), "timeout")
	yield(VisualServer, "frame_post_draw")
	#Allows tiles to draw first before drawing Line2D for spiderweb
	var WebPoint = to_local(WebRay.get_collision_point())
	WebLine.add_point(WebPoint)
	
	WebBox.shape.b = WebPoint
	#WebParticles.position = WebPoint
	var Web_destroy = animation.get_animation("web_destroy")
	Web_destroy.track_set_key_value(0, 0, WebPoint)

func Ground_walk(delta):
	if IsExploding == false:
		motion.x = (SpeedTwo * delta * 100) * switch
		animation.play("ground_walk")
		if switch == 1:
			sprite.flip_h = false
		if switch == -1:
			sprite.flip_h = true
		Detect_edges()
		
	motion.y += gravity * delta * 53
	if motion.y > MaxFallSpeed:
		motion.y = MaxFallSpeed
		#Gravity

func Second_phase():
	WebBox.set_deferred("disabled", true)
	IsFalling = false
	PhaseOneBox.set_deferred("disabled", true)
	PhaseTwoBox.set_deferred("disabled", false)
	switch = 1
	sprite.rotation = 2 * PI
	SecondPhaseAct = true
	EdgeCheckLeft.enabled = true
	EdgeCheckRight.enabled = true
func Detect_edges():
	if EdgeCheckLeft.is_colliding() == false:
		switch = 1
		
	if EdgeCheckRight.is_colliding() == false:
		switch = -1

func Falling(delta):
	if IsFalling == true:
		animation.stop()
		motion.y += gravity * delta * 53
		if is_on_floor() == true:
			Second_phase()

func Explode():
	for areas in Explosion.get_overlapping_areas():
		if areas.name == "CrateArea":
			print("crate breaks by spider explosion")
	
	motion.x = 0
	IsExploding = true
	animation.play("explode")
	ExplosionSound.playing = true
	emit_signal("spider_died")

func _ready():
	add_to_group("spiders")
	Draw_web()

func _physics_process(delta):
	motion = move_and_slide(motion, up)
	
	Falling(delta)

	if SecondPhaseAct == true:
		Ground_walk(delta)
		
func _on_HitBox_area_entered(_area):
	if SecondPhaseAct == false:
		PunchSound.playing = true
		animation.play("web_destroy")
		
	elif SecondPhaseAct == true:
		Explode()

func _on_HitWall_body_entered(_body):
	switch *= -1
	PhaseTwoBox.position.x *= -1
	if SecondPhaseAct == false:
		sprite.rotate(PI)

func _on_AttBox_area_entered(area):
	if IsExploding == false and area.name == "PlayerHitBox":
		Main.player_damaged(1, "enemy", global_position)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "explode":
		queue_free()
	if anim_name == "web_destroy":
		WebLine.visible = false
		IsFalling = true
