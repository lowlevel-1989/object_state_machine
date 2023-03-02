@tool
extends GraphEdit

var NodeState : Resource
var ButtonNode : Resource

var _button_first_state   : Button
var _button_normal_state  : Button
var _button_last_state    : Button
var _button_save_metadata : Button

var _state_machine : NodeStateMachine
var _state_seleted : GraphNode

# Called when the node enters the scene tree for the first time.
func _ready():
	NodeState = preload(
		"res://addons/object_state_machine/support_editor_godot_v4/graph_node_state.tscn")
	
	ButtonNode = preload(
		"res://addons/object_state_machine/support_editor_godot_v4/button_node.tscn")
	
	# habilita desconectar y reconectar los cables
	set_right_disconnects(true)
	
	_button_first_state    = ButtonNode.instantiate()
	_button_normal_state   = ButtonNode.instantiate()
	_button_last_state     = ButtonNode.instantiate()
	_button_save_metadata  = ButtonNode.instantiate()
	
	_button_first_state.text   = "First State"
	_button_normal_state.text  = "Normal State"
	_button_last_state.text    = "Last State"
	_button_save_metadata.text = "Save"
	
	get_zoom_hbox().add_child(_button_first_state)
	get_zoom_hbox().add_child(_button_normal_state)
	get_zoom_hbox().add_child(_button_last_state)
	get_zoom_hbox().add_child(_button_save_metadata)
	
	_button_first_state.connect("button_down", _on_button_first_state)
	_button_normal_state.connect("button_down", _on_button_normal_state)
	_button_last_state.connect("button_down",  _on_button_last_state)
	
	_button_save_metadata.connect("button_down",  _on_button_save)
	
	connect("node_selected", _on_node_selected)
	connect("popup_request", _on_popup_request)
	connect("connection_request", _on_connection_request)
	connect("disconnection_request", _on_disconnection_request)

func _on_button_save() -> void:
	print("save metadata")

func _on_popup_request(_position : Vector2) -> void:
	var _inv_zoom : float = 1/zoom
	var _new_node : GraphNode
	_new_node = NodeState.instantiate()
	
	# Se agrega a la visor teniendo en cuenta el scroll y la posicion del mouse
	_new_node.position_offset = ( _position +  scroll_offset ) 
	
	# se agrega un offset para centrar el nodo en el cursor
	_new_node.position_offset -= _new_node.size / 2
	
	# se escala la posicion con el valor del zoom
	_new_node.position_offset *= _inv_zoom
	add_child(_new_node)

func _on_node_selected(node : Node) -> void:
	self._state_seleted = node

func _on_button_normal_state() -> void:
	if self._state_seleted and get_child_count() > 0:
		self._state_seleted.set_mode(self._state_seleted.NORMAL)

func _on_button_last_state() -> void:
	for node in get_children():
		if node.get_mode() == node.LAST:
			node.self_modulate = Color(1, 1, 1, 0.59)

	if self._state_seleted and get_child_count() > 0:
		self._state_seleted.set_mode(self._state_seleted.LAST)

func _on_button_first_state() -> void:
	# solo asignamos un estado como principal
	for node in get_children():
		if node.get_mode() == node.FIRST:
			node.self_modulate = Color(1, 1, 1, 0.59)

	if self._state_seleted and get_child_count() > 0:
		self._state_seleted.set_mode(self._state_seleted.FIRST)

func _on_connection_request(
	from_node: StringName, from_port: int,
	to_node: StringName, to_port: int) -> void:
		if from_node != to_node:
			connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(
	from_node: StringName, from_port: int,
	to_node: StringName, to_port: int):
	disconnect_node(from_node, from_port, to_node, to_port)

func set_state_machine(state_machine : NodeStateMachine) -> void:
	self._state_machine = state_machine
	
func get_state_machine() -> NodeStateMachine:
	return self._state_machine
