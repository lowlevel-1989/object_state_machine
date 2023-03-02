@tool
extends GraphNode

enum {FIRST, NORMAL, LAST}

var _mode_state : int

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("close_request", _on_close_request)
	self._mode_state = NORMAL


func _on_close_request() -> void:
	queue_free()

func set_mode(mode : int) -> void:
	self._mode_state = mode
	
	match self._mode_state:
		FIRST:
			self_modulate = Color(0.6, 1, 0.5, 1)
		NORMAL:
			self_modulate = Color(1, 1, 1, 0.59)
		LAST:
			self_modulate = Color(0.8, 0.6, 1, 1)

func get_mode() -> int:
	return self._mode_state
