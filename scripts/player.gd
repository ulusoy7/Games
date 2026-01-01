extends CharacterBody2D

@export var speed: float = 300.0
var screen_size: Vector2
var half_size = 16
var game_over_label
var is_game_over = false

func _ready():
	screen_size = get_viewport_rect().size
	game_over_label = get_node("/root/Main/UI/GameOverLabel")
	game_over_label.visible = false
	
	if is_game_over:
		return
		
func _physics_process(_delta):
	var direction = Vector2.ZERO

	if is_game_over:
		if Input.is_action_just_pressed("Restart"):
			get_tree().reload_current_scene()
		return


	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
		
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
	check_enemy_collision()
	
	position.x = clamp(position.x, half_size, screen_size.x - half_size)
	position.y = clamp(position.y, half_size, screen_size.y - half_size)

func check_enemy_collision():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.is_in_group("Enemy"):
			game_over()
			
func game_over():
	is_game_over = true
	game_over_label.visible = true
	set_physics_process(true)

func _on_body_entered(body):
	if body.name == "Enemy":
		game_over()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	pass # Replace with function body.
