extends KinematicBody2D

onready var Main = get_parent()
onready var player = get_node("../Player")

onready var sprite = $Sprite
onready var EdgeCheckLeft = $EdgeCheckLeft
onready var EdgeCheckRight = $EdgeCheckRight
onready var AttBox = $AttBox
onready var PunchSound = $PunchSound

onready var HitWall = $HitWall

export(int, 10, 100) var Speed = 13
export var switch = 1

const up = Vector2(0, -1)
var motion = Vector2()
var gravity = 30
var MaxFallSpeed = 600

func Walk(delta):
	motion.x = (Speed * delta * 100) * switch
	if switch == 1:
		sprite.flip_h = false
	if switch == -1:
		sprite.flip_h = true
	Detect_edges()
		
	motion.y += gravity * delta * 53
	if motion.y > MaxFallSpeed:
		motion.y = MaxFallSpeed
		#Gravity
		
func Detect_edges():
	if EdgeCheckLeft.is_colliding() == false:
		switch = 1
		#print("Left not colliding")
		
	if EdgeCheckRight.is_colliding() == false:
		switch = -1
		#print("right not colliding")

func _physics_process(delta):
	motion = move_and_slide(motion, up)
	Walk(delta)

func _on_HitWall_body_entered(_body):
	print("demon hit wall")
	switch *= -1

func _on_AttBox_area_entered(area):
	if area.name == "PlayerHitBox":
		Main.player_damaged(1, "enemy", global_position)

func _on_Hitbox_area_entered(area):
	if area.name == "AttBox" or area.name =="KickBox":
		player.knockback_large_enemy(global_position)
