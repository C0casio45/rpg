extends CharacterBody2D

@export var speed = 100
@export var damage_dealt = 100
@export var health = 100

var orientation
var screen_size

signal is_attacking

func _ready():
	screen_size = get_viewport_rect().size
	orientation = "down"

func _physics_process(_delta):
	_movement()
	_animation()
	move_and_slide()

func _movement():
	pass

func _animation():
	pass

func attack():
	if Input.is_action_pressed("Attack"):
		is_attacking.emit(self)
		attack_animation_routine()
#	elif animation.attack.values.has($AnimatedSprite2D.animation):
#		handle_idle()



func attack_animation_routine():
	if orientation == "right":
		$AnimatedSprite2D.play(animation.attack.side)
		$AnimatedSprite2D.flip_h = false
	elif orientation == "left":
		$AnimatedSprite2D.play(animation.attack.side)
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.play(animation.attack[orientation])
	await $AnimatedSprite2D.animation_finished
	if orientation == "right":
		$AnimatedSprite2D.animation = animation.idle.side
		$AnimatedSprite2D.flip_h = false
	elif orientation == "left":
		$AnimatedSprite2D.animation = animation.idle.side
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.animation = animation.idle[orientation]

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

