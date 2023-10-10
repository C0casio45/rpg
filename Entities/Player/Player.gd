extends "res://Entities/Entities.gd"

var animation = {
	"die" : "die",
	"walk" : {
		"up" : "back_walk",
		"down" : "front_walk",
		"side" : "side_walk",
	},
	"idle" : {
		"up" : "back_idle",
		"down" : "front_idle",
		"side" : "side_idle",
	},
	"attack" : {
		"up" : "back_attack",
		"down" : "front_attack",
		"side" : "side_attack",
		"values" : ["back_attack","front_attack","side_attack"]
	},
}

func _movement():
	velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("MooveRight"):
		orientation = "right"
		velocity.x += 1
	if Input.is_action_pressed("MooveLeft"):
		orientation = "left"
		velocity.x -= 1
	if Input.is_action_pressed("MooveDown"):
		orientation = "down"
		velocity.y += 1
	if Input.is_action_pressed("MooveUp"):
		orientation = "up"
		velocity.y -= 1

func _animation():
	if velocity == Vector2(0,0):
		animation_idle()
	else :
		animation_moove()

func animation_idle():
	if orientation == "up":
		$AnimatedSprite2D.animation = animation.idle.up
	elif orientation == "left":
		$AnimatedSprite2D.animation = animation.idle.side
	elif orientation == "right":
		$AnimatedSprite2D.animation = animation.idle.side
	else:
		$AnimatedSprite2D.animation = animation.idle.down

func animation_moove():
	if orientation == "up":
		$AnimatedSprite2D.animation = animation.walk.up
	elif orientation == "left":
		$AnimatedSprite2D.animation = animation.walk.side
	elif orientation == "right":
		$AnimatedSprite2D.animation = animation.walk.side
	else:
		$AnimatedSprite2D.animation = animation.walk.down
