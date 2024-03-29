extends KinematicBody2D

signal spider_died

onready var Main = $"../.."

onready var sprite = $Sprite
onready var animation = $AnimationPlayer
onready var EdgeCheckLeft = $EdgeCheckLeft
onready var EdgeCheckRight = $EdgeCheckRight
onready var AttBox = $AttBox
onready var AttBoxCollider = AttBox.get_child(0)
onready var ExplosionSound = $ExplosionSound
onready var PunchSound = $PunchSound
onready var Explosion = $Explosion

onready var HitWall = $HitWall
onready var PhaseOneBox = HitWall.get_child(0)
onready var PhaseTwoBox = HitWall.get_child(1)

export(int, 0, 100) var WalkLength = 5
export(int, 10, 100) var Speed = 13
export(int, 10, 100) var SpeedTwo = 30
export(String, "Vertical", "Horizontal") var Direction = "Vertical"
export var switch = 1

const up = Vector2(0, -1)
var motion = Vector2()
var PatrolPoint = Vector2.ZERO
var Position1 = Vector2.ZERO

var SecondPhaseAct = false
var gravity = 30
var MaxFallSpeed = 600
export var IsFalling = false
var IsExploding = false

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
	IsFalling = false
	PhaseOneBox.set_deferred("disabled", true)
	PhaseTwoBox.set_deferred("disabled", false)
	switch = 1
	PhaseTwoBox.position.x = abs(PhaseTwoBox.position.x) * -1
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

func Horizontal_on_wall(delta):
	motion.x = (Speed * delta * 100) * switch
	if position.x >= PatrolPoint.x:
		switch = -1
		sprite.rotate(PI)
	if position.x <= Position1.x:
		switch = 1
		sprite.rotate(PI)

func Vertical_on_wall(delta):
	motion.y = (Speed * delta * 100) * switch
	if position.y >= PatrolPoint.y:
		switch = -1
		sprite.rotate(PI)
	if position.y <= Position1.y:
		sprite.rotate(PI)
		switch = 1
		
func Explode():
	if IsExploding == false:
		for areas in Explosion.get_overlapping_areas():
			if areas.name == "CrateArea":
				areas.get_parent()._on_CrateArea_area_entered()
				print("crate breaks by spider explosion")
			if areas.name == "HitBox":
				areas.get_parent().Explode()
	
		motion.x = 0
		IsExploding = true
		animation.play("explode")
		ExplosionSound.playing = true
		emit_signal("spider_died")

func _ready():
	add_to_group("spiders")
	
	PatrolPoint = position + Vector2(WalkLength * 64, WalkLength * 64)
	Position1 = position
	if Direction == "Vertical":
		sprite.rotate(1.5 * PI)
	if Direction == "Horizontal":
		sprite.rotate(PI)
	animation.play("wall_walk")

func _physics_process(delta):
	motion = move_and_slide(motion, up)
	
	Falling(delta)
	
	if SecondPhaseAct == false:
		if Direction == "Horizontal" and IsFalling == false:
			Horizontal_on_wall(delta)

		if Direction == "Vertical" and IsFalling == false:
			Vertical_on_wall(delta)

	elif SecondPhaseAct == true:
		Ground_walk(delta)
		
func _on_HitBox_area_entered(_area):
	if SecondPhaseAct == false:
		PunchSound.playing = true
		IsFalling = true
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
