extends Label

func _process(_delta: float) -> void:
	text = "Balls : %d" % get_tree().get_node_count_in_group("ball")