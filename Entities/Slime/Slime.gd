extends CharacterBody2D

signal hit

@export var speed = 50
var player_chase = false
var player = null

var animation = {
	"die" : "die",
	"walk" : "walk",
	"idle" : "idle",
}

func _physics_process(_delta):
	if player_chase:
		$AnimatedSprite2D.play(animation.walk)
		handle_movement()
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		move_and_slide()
	else :
		$AnimatedSprite2D.play(animation.idle)

func handle_movement():
	velocity = Vector2.ZERO
	if player.position.x + 0.05 < position.x:
		velocity.x -= 1
		$AnimatedSprite2D.flip_h = true
	if player.position.x - 0.05 > position.x:
		velocity.x += 1
		$AnimatedSprite2D.flip_h = false
	if player.position.y + 0.05 < position.y:
		velocity.y -= 1
	if player.position.y - 0.05 > position.y:
		velocity.y += 1

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false
