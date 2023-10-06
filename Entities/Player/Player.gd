extends CharacterBody2D

@export var speed = 400
var orientation = "down"
var screen_size

signal is_attacking

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

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	$AnimatedSprite2D.play()
	handle_attack()
	velocity = handle_movement()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	elif !animation.attack.values.has($AnimatedSprite2D.animation):
		handle_idle()
		# !animation.attack.values.has($AnimatedSprite2D.animation)
	
		
	_position_calculator(delta)
	_flip_player()

func handle_idle():
	if orientation == "up":
		$AnimatedSprite2D.animation = animation.idle.up
	elif orientation == "left":
		$AnimatedSprite2D.animation = animation.idle.side
	elif orientation == "right":
		$AnimatedSprite2D.animation = animation.idle.side
	else:
		$AnimatedSprite2D.animation = animation.idle.down

func handle_attack():
	var anim = $AnimatedSprite2D.animation
	if Input.is_action_pressed("Attack"):
		is_attacking.emit()
		if orientation == "down":
			$AnimatedSprite2D.animation = animation.attack.down
		if orientation == "up":
			$AnimatedSprite2D.animation = animation.attack.up
		if orientation == "left":
			$AnimatedSprite2D.animation = animation.attack.side
			$AnimatedSprite2D.flip_h = true;
		if orientation == "right":
			$AnimatedSprite2D.animation = animation.attack.side
			$AnimatedSprite2D.flip_h = false
	elif animation.attack.values.has($AnimatedSprite2D.animation):
		handle_idle()

func attack_animation_routine():
	if orientation == "right":
		$AnimatedSprite2D.play(animation.attack.side)
		$AnimatedSprite2D.loop = false
		$AnimatedSprite2D.flip_v = true
	elif orientation == "left":
		$AnimatedSprite2D.play(animation.attack.side)
		$AnimatedSprite2D.loop = false
		$AnimatedSprite2D.flip_v = false
	else:
		$AnimatedSprite2D.play(animation.attack[orientation])
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.loop = true
	if orientation == "right":
		$AnimatedSprite2D.animation = animation.idle.side
		$AnimatedSprite2D.flip_v = true
	elif orientation == "left":
		$AnimatedSprite2D.animation = animation.idle.side
		$AnimatedSprite2D.flip_v = false
	else:
		$AnimatedSprite2D.animation = animation.idle[orientation]
	

func handle_movement():
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
	return velocity

func _position_calculator( delta):
	position += velocity * delta
	position.clamp(Vector2.ZERO, screen_size)

func _flip_player():
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "side_walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		if velocity.y < 0:
			$AnimatedSprite2D.animation = "back_walk"
		elif velocity.y > 0:
			$AnimatedSprite2D.animation = "front_walk"

