extends Node

@export var enable_process_print: bool = false
@export var enable_physics_process_print: bool = false

func _output(msg: String) -> void:
	print("[%s]: %s" % [name, msg])

func _init() -> void:
	_output("Init")

func _enter_tree() -> void:
	_output("Enter tree")

func _ready() -> void:
	_output("Ready")

func _process(_delta: float) -> void:
	if enable_process_print:
		_output("Process")

func _physics_process(_delta: float) -> void:
	if enable_physics_process_print:
		_output("Physics process")

func _exit_tree() -> void:
	_output("Exit tree")

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE: _output("Predelete")
