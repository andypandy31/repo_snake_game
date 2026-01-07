extends Node2D

#game var
var score : int
var game_started : bool = false

#grid
var cells : int = 20
var cell_size : int = 50

#snake var
var old_data : Array
var snake_data : Array
var snake : Array

#movment var
var start_pos = Vector2(9, 9)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
