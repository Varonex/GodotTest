extends Node

const ClassImport: GDScript = preload("res://Inner/named_global_class.gd")

@export var my_inner_class: NamedGlobalClass.Inner = NamedGlobalClass.Inner.new("Hey")
@export var my_inner_class2: ClassImport.Inner = ClassImport.new("Hi")

func _ready() -> void:
	print(my_inner_class)
	print(my_inner_class2)