@tool
class_name ToolScriptTest extends Node

# VARIABLES

@export var ready_editor: bool = false
@export var ready_game: bool = false

@export var process_editor: bool = false
@export var process_game: bool = false

@export var physics_process_editor: bool = false
@export var physics_process_game: bool = false

# ENGINE

func _ready() -> void:
	ready_editor = false
	ready_game = false
	process_editor = false
	process_game = false
	physics_process_editor = false
	physics_process_game = false
	
	if Engine.is_editor_hint():
		ready_editor = true
		return
	
	# Runs in node context
	ready_game = true

func _process(_delta: float) -> void:
	# Test to see where it runs!
	if Engine.is_editor_hint():
		process_editor = true
		return
	
	process_game = true

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		physics_process_editor = true
		return
	
	physics_process_game = true

# METHODS

func _get_configuration_warnings() -> PackedStringArray:
	return [
		"I am a warning hello :)"
	]