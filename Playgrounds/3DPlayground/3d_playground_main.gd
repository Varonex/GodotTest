extends Node3D

# VARIABLES

## HUD to feature within the game.
@export var hud_scene: PackedScene

## Different test entries.
@export var test_scenes: Array[TestEntry] = []

## Unit size of each plot.
@export var unit_size: float = 10

## Margin between two plots.
@export var margin: float = 5

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
			
		var scene: Node3D = test_scene.scene.instantiate()
		add_child(scene)
		
		var idx: int = i % grid_size.x
		
		@warning_ignore("integer_division")
		var idz: int = i / grid_size.y
		
		var x: float = idx * unit_size + idx * margin
		var z: float = idz * unit_size + idz * margin
		
		scene.global_position = Vector3(x, 0, z)
			
		i += 1
