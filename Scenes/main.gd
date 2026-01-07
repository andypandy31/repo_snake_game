extends Node2D

@export var snake_scene : PackedScene

#game var
var score : int
var game_started : bool = false

#grid
var cells : int = 20
var cell_size : int = 50

#food var
var food_pos : Vector2
var regen_food : bool = true

#snake var
var old_data : Array
var snake_data : Array
var snake : Array

#movment var
var start_pos = Vector2(9, 9)
var up = Vector2(0,-1)
var down = Vector2(0, 1)
var left = Vector2(-1, 0)
var right = Vector2(1, 0)
var move_directions : Vector2
var can_move : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	newgame()

func newgame():
	get_tree().paused = false
	get_tree().call_group("segments", "queue_free")
	$GameOverMenu.hide()
	score = 0
	$Hud.get_node("ScoreLabel").text = "SCORE : " + str(score)
	move_directions = up
	can_move = true
	generate_snake()
	move_food()

func generate_snake():
	old_data.clear()
	snake_data.clear()
	snake.clear()
	#starting with the start pos then genrateing tail segments verically down.
	for i in range(3):
		add_segment(start_pos + Vector2(0, i))
		

func add_segment(pos):
	snake_data.append(pos)
	var SnakeSegment = snake_scene.instantiate()
	SnakeSegment.position = (pos * cell_size) + Vector2(0, cell_size)
	add_child(SnakeSegment)
	snake.append(SnakeSegment)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_snake()

func move_snake():
	#the movement updates
	if Input.is_action_just_pressed("move_down") and move_directions != up:
		move_directions = down
		can_move = false
		if not game_started:
			start_game()
	
	if Input.is_action_just_pressed("move_up") and move_directions != down:
		move_directions = up
		can_move = false
		if not game_started:
			start_game()
	
	if Input.is_action_just_pressed("move_left") and move_directions != right:
		move_directions = left
		can_move = false
		if not game_started:
			start_game()
	
	if Input.is_action_just_pressed("move_right") and move_directions != left:
		move_directions = right
		can_move = false
		if not game_started:
			start_game()

func start_game():
	game_started = true
	$MovementTimer.start()


func _on_movement_timer_timeout() -> void:
	can_move = true
	
	old_data = [] + snake_data
	snake_data [0] += move_directions
	for i in range(len(snake_data)):
		if i > 0:
			snake_data[i] = old_data[i - 1]
		snake[i].position = (snake_data[i] * cell_size) + Vector2(0, cell_size)
		check_out_of_bounds()
		check_self_eaten()
		check_food_eaten()
	
func check_out_of_bounds():
	if snake_data[0].x < 0 or snake_data[0].x > cells - 1 or snake_data[0].y < 0 or snake_data[0].y > cells - 1:
		end_game()

func check_self_eaten():
	for i in range(1, len(snake_data)):
		if snake_data[0] == snake_data[i]:
			end_game()

func move_food():
	while regen_food:
		regen_food = false
		food_pos = Vector2(randi_range(0, cells - 1), randi_range(0, cells -1))
		for i in snake_data:
			if food_pos == i:
				regen_food = true
	$Apple.position = (food_pos * cell_size) + Vector2(0, cell_size)
	regen_food = true
	
func check_food_eaten():
	if snake_data[0] == food_pos:
		score += 1
		$Hud.get_node("ScoreLabel").text = "SCORE : " + str(score)
		add_segment(old_data[-1])
		move_food()

func end_game():
	$GameOverMenu.show()
	$MovementTimer.stop()
	game_started = false
	get_tree().paused = true

func _on_game_over_menu_restart() -> void:
	newgame()
