extends KinematicBody2D

const GRAVITY = 500.0

var velocity_gravity = Vector2()

var velocity_jump = Vector2()
var can_jump = false
var jumping = false
var jump = 0
var jump_ang = 0
var jump_loading = -100

var on_jump_stream = false

var player_is_sticked = false
var can_player_stick = false


func _physics_process(delta):
	player_jumping(delta)
	check_collisions()
	gravity_fall(delta)


func _input(event):
	if event.is_action_pressed("mouse_l_click") and can_jump:
		start_loading_player_jump_power()
	if event.is_action_released("mouse_l_click") and can_jump:
		if not player_is_sticked:
			jump_player()
		stop_loading_player_jump_power()
	if event.is_action_pressed("mouse_r_click"):
		start_trying_stick()
	if event.is_action_released("mouse_r_click"):
		stop_trying_stick()

#gravity
func gravity_fall(delta):
	if not player_is_sticked:
		velocity_gravity.y += delta * GRAVITY
		move_and_slide(velocity_gravity, Vector2(0, -1))
		
		if self.is_on_floor() and not on_jump_stream:
			hit_ground()

func hit_ground():
	#print("hit_ground")
	if not can_jump:
		$AnimatedSprite.play("default")
		$AnimatedSprite.play("hit_ground")
	velocity_gravity.y = 0
	velocity_gravity.x = 0
	can_jump = true
	jumping = false
	velocity_jump.y = 0
	velocity_jump.x = 0

#jump
func jump_player():
	jump = 3500
	can_jump = false
	jumping = true
	
	jump_ang = self.position.angle_to_point($Camera.get_global_mouse_position())
	jump_ang -= PI/2
	
	velocity_jump.y = jump_loading
	velocity_jump = velocity_jump.rotated(jump_ang)
	
	$AnimatedSprite.play("jumping")


func player_jumping(delta):
	if jumping:
		velocity_jump.y -=	delta * jump
		jump /= 1.45
		move_and_slide(velocity_jump)


#loading jump
func start_loading_player_jump_power():
	$PowerOfJumpLoader.start()
	$AnimatedSprite.play("loading_jump_min")

func stop_loading_player_jump_power():
	$PowerOfJumpLoader.stop()
	jump_loading = -10

func _on_PowerOfJumpLoader_timeout():
	jump_loading -= 8
	if jump_loading < -250:
		$PowerOfJumpLoader.stop()
		$AnimatedSprite.play("loading_jump_max")


# collisions and stick
func check_collisions():
	if self.is_on_ceiling() or self.is_on_wall():
		hit_block_on_jumping()

func hit_block_on_jumping():
	$AnimatedSprite.play("default")
	$AnimatedSprite.play("hit_ground")
	if can_player_stick:
		stick_player()
	if abs(get_slide_collision(0).position.x - self.position.x) < 1:
		velocity_jump.y /= 2
	else:
		velocity_jump.x = -velocity_jump.x/1.5
	jump /= 2
		
func start_trying_stick():
	can_player_stick = true
	self.scale.x = 1.2
	self.scale.y = 1.2
	$Collision.scale.x = 1.1
	$Collision.scale.y = 1.1
	
func stop_trying_stick():
	player_is_sticked = false
	can_player_stick = false
	self.scale.x = 1
	self.scale.y = 1
	$Collision.scale.x = 1
	$Collision.scale.y = 1
	
func stick_player():
	hit_ground()
	player_is_sticked = true


func _on_AnimatedSprite_animation_finished():
	if can_jump and jump_loading == -10:
		$AnimatedSprite.play("default")

# JumpStream
func jump_stream_on(power):
	self.can_jump = false
	player_is_sticked = false
	jumping = true
	print("js")
	print("p1",velocity_jump.y / jump)
	jump += power
	print("p2", velocity_jump.y / jump)
	if velocity_jump.x > 0:	
		velocity_jump.x += 1
	else:
		velocity_jump.x -= 1
