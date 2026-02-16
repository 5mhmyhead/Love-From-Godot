extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var speed: int = 150

var pressed = []
var lastAction

const directions = {
	&"right": Vector2(1, 0),
	&"left": Vector2(-1, 0),
	&"down": Vector2(0, 1),
	&"up": Vector2(0, -1)
}


func _process(_delta: float) -> void:
	for d in directions:
		if Input.is_action_just_pressed(d):
			pressed.push_back(d)
		if Input.is_action_just_released(d):
			pressed.erase(d)
			lastAction = d
	
	direction = Vector2.ZERO if pressed.is_empty() else directions[pressed[-1]]
	speed = 225 if Input.is_action_pressed('sprint') else 150
	velocity = speed * direction
	
	animate()
	move_and_slide()


func animate() -> void:
	$Sprite.speed_scale = 1.25 if Input.is_action_pressed('sprint') else 1.0
	
	if direction: 
		$Sprite.flip_h = direction.x > 0
		
		if direction.x != 0: 
			$Sprite.animation = 'sprint' if Input.is_action_pressed('sprint') else 'west'
		else:
			$Sprite.animation = 'north' if direction.y < 0 else 'south'
	else:
		if lastAction == 'down':
			$Sprite.animation = 'idle_south'
		elif lastAction == 'up':
			$Sprite.animation = 'idle_north'
		elif lastAction == 'left':
			$Sprite.animation = 'idle_west'
			$Sprite.flip_h = false
		elif lastAction == 'right':
			$Sprite.animation = 'idle_west'
			$Sprite.flip_h = true
