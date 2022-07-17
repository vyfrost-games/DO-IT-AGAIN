extends Node2D


onready var starting_camera : Camera2D = $StartingCamera
onready var character_scene = preload('res://Scenes/Character/Character.tscn')
onready var scene_transition = preload('res://Scenes/Transition/SceneTransition.tscn')

var bottom_location = Vector2(32, -170)
var brick_location = Vector2(32, -600)
var clouds_location = Vector2(32, -900)
var court_location = Vector2(160, -1020)
var at_bottom = Vector2(160,90)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_in_court()
	Player.connect("respawn", self, 'spawn_at_bottom')


func spawn_at_bottom():
	var transition: SceneTransition = scene_transition.instance()
	add_child(transition)
	transition.clouds()
	# Reset character
	Player.dead = false
	var character: KinematicBody2D = spawn_new_player()
	character.position = bottom_location
	# Set camera position
	var starting_camera := Camera2D.new()
	add_child(starting_camera)
	starting_camera.position = at_bottom
	starting_camera.current = true
	yield(get_tree().create_timer(1),"timeout")
	starting_camera.queue_free()
	# View player
	var player_camera: Camera2D = character.get_node("Camera2D")
	player_camera.position = Vector2(130,-45) # Prevent camera shake when switching camera
	player_camera.current = true
	# Gain new ability
	Player.roll_the_dice()
	


func spawn_in_court():
	# Set character
	var character: KinematicBody2D = spawn_new_player()
	character.position = court_location
	# Set camera
	var starting_camera := Camera2D.new()
	add_child(starting_camera)
	starting_camera.position = court_location
	starting_camera.current = true


func spawn_new_player()->KinematicBody2D:
	var character = character_scene.instance()
	$YSort.add_child(character)
	$YSort.move_child(character, 0)
	return character


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
