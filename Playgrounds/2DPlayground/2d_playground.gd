extends Node2D

# VARIABLES

## HUD to feature within the game.
@export var hud_scene: PackedScene

## Different test entries.
@export var test_scenes: Array[TestEntry] = []

## Unit size of each plot.
@export var unit_size: int = 300

## Margin between two plots.
@export var margin: int = 100

## Size of grid.
@export var grid_size: Vector2i = Vector2i(5, 5)

# ENGINE

func _ready() -> void:
	var hud: CanvasLayer = hud_scene.instantiate()
	add_sibling.call_deferred(hud)
	
	# Instantiation des scènes
	var i: int = 0
	
	for test_scene: TestEntry in test_scenes:
		if i > grid_size.x * grid_size.y:
			break
		
		if not test_scene.enabled or test_scene.scene == null:
			continue
		
		var scene: Node2D = test_scene.scene.instantiate()
		add_child(scene)
		
		var idx: int = i % grid_size.x
		
		@warning_ignore("integer_division")
		var idy: int = i / grid_size.y
		
		var x: int = idx * unit_size + idx * margin
		var y: int = idy * unit_size + idy * margin
		
		scene.global_position = Vector2(x, y)
		
		i += 1
