extends Node2D

@onready var wage_text: Label = $Wage_Text
@onready var BagScene = preload("res://bag.tscn")
@onready var game_over: CanvasLayer = $"../GameOver"
@onready var progress_bar: ProgressBar = $"../Queue/ProgressBar"
@onready var timer: Timer = $"../Queue/ProgressBar/Timer"
@onready var game_timer: Timer = $"../GameTimer"
@onready var console: AnimatedSprite2D = $Console
@onready var sfx_guilty: AudioStreamPlayer = $"../AudioManager/SFX_Guilty"
@onready var sfx_innocent: AudioStreamPlayer = $"../AudioManager/SFX_Innocent"
@export var increment_value: int = 10
@export var interpolation_speed: float = 5.0

var target_value: float = 0.0
var current_bag: Node2D = null
var pay: int = 0


func _physics_process(delta: float) -> void:
	# Smoothly interpolate current value toward the target value
	progress_bar.value = lerp(progress_bar.value, target_value, interpolation_speed * delta)
	if target_value < 0:
		target_value = 0
	if target_value >= 100:
		gameover()
	#print(target_value)


#spawn the first bag on play
func _ready() -> void:
	spawn_bag()
	wage_text.text = "Wages: $%s" % pay
	timer.start()

func spawn_bag() -> void:
	var bag = BagScene.instantiate()
	bag.position = Vector2(30, 200) 
	add_child(bag)
	#print("spawned 1 bag") 
	current_bag = bag

func _on_button_guilty_pressed() -> void:
	if current_bag.timeout == false:
		current_bag.allowed = false
		calculate_pay()
		current_bag.move()
		spawn_bag()
		console.play("guilty")
func _on_button_innocent_pressed() -> void:
	
	if current_bag.timeout == false:
		current_bag.allowed = true
		calculate_pay()
		current_bag.move()
		spawn_bag()
		console.play("innocent")
		
func calculate_pay() -> void:
	if current_bag.allowed == true and current_bag.contraband_present == false:
		pay += 10
		target_value -= 5
		wage_text.modulate = Color(0, 1, 0)
		sfx_innocent.play()
		
	if current_bag.allowed == true and current_bag.contraband_present == true:
		pay -= 20
		target_value += 10
		wage_text.modulate = Color(1, 0, 0)
		sfx_guilty.play()
		
	if current_bag.allowed == false and current_bag.contraband_present == true:
		pay += 30
		target_value -= 5
		wage_text.modulate = Color(0, 1, 0)
		sfx_innocent.play()
		
	if current_bag.allowed == false and current_bag.contraband_present == false:
		pay -= 50
		target_value += 10
		wage_text.modulate = Color(1, 0, 0)
		sfx_guilty.play()
		

	wage_text.text = "Wages: $%s" % pay
	
	# Reset the color back to default after a short delay
	await get_tree().create_timer(0.5).timeout
	wage_text.modulate = Color(1, 1, 1)

	if pay <= 0:
		gameover()

func gameover():
	#print ("game over")
	game_over.visible = true
	get_tree().paused = true

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	#progress_bar.value += 1
	target_value += 1


func _on_game_timer_timeout() -> void:
	timer.wait_time -= 0.1
	#print("Wait time reduced")
