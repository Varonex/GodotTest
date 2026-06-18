extends Node

const SCRIPT: GDScript = preload("res://await/emitter.gd")

@export var emitter: SCRIPT

func _ready() -> void:
	two_deep() # Runs and resumes when two_deep will await

func two_deep() -> void:
	prints("AAAAA", await one_deep()) # Will return control to sender upon awaiting

func one_deep() -> int:
	return await emitter.test1 # Grabs the signal value and returns it

func _process(_delta: float) -> void:
	await emitter.test
	var res = await emitter.test1
	var res2 = await emitter.test2
	
	variable(res, res2)

func variable(...arg) -> void:
	prints(arg)