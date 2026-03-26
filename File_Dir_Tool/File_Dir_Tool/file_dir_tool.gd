@tool
class_name FileDirTool extends Node

# VARIABLES

## Debounce for button actions.
var _debounce: bool = false

## Actions.
@export_group("Actions")

@export_tool_button("Save to file") var out_fct: Callable = _out_fct
@export_tool_button("Read from file") var in_fct: Callable = _in_fct

@export_group("File Content")

## String content.
@export_multiline var content: String

@export_group("Filesystem information")

## Available files.
@export var available_files: PackedStringArray

## Path to use for read/write.
@export var file_name: String = "test_file.txt"

# ENGINE

func _ready() -> void:
	print("Runs in the editor !")
	available_files = _fetch_files_in_user()
	_in_fct()
	
	# Stops the in-editor function run.
	if Engine.is_editor_hint():
		return
	
	print("Runs only in the game !")

# METHODS

func _fetch_files_in_user() -> PackedStringArray:
	var dir: DirAccess = DirAccess.open("user://")
	
	if dir == null:
		printerr("Could not open user:// ! (" + error_string(DirAccess.get_open_error()) + ")")
		return PackedStringArray()
	
	var res: PackedStringArray = dir.get_files()
	
	return res

func _pre_check() -> bool:
	return not file_name.is_empty()

func _out_fct() -> void:
	if not _pre_check() or _debounce:
		return
	
	_debounce = true
	
	var file: FileAccess = FileAccess.open("user://" + file_name, FileAccess.WRITE)
	
	if file == null:
		printerr("Could not open the file ! (" + error_string(FileAccess.get_open_error()) + ")")
		_debounce = false
		return
	
	file.store_string(content)
	file.close()
	
	# Adds to files list if necessary.
	if file_name not in available_files:
		available_files.append(file_name)
	
	print("Saved to user://" + file_name)
	
	_debounce = false

func _in_fct() -> void:
	if not _pre_check() or _debounce:
		return
	
	_debounce = true
	
	content = FileAccess.get_file_as_string("user://" + file_name)
	print("Read from user://" + file_name)
	
	_debounce = false