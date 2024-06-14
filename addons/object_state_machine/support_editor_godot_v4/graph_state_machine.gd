@tool
extends GraphEdit

var NodeState : Resource
var ButtonNode : Resource

var _button_first_state   : Button
var _button_normal_state  : Button
var _button_last_state    : Button
var _button_new_metadata  : Button
var _button_save_metadata : Button

var _state_machine : NodeStateMachine
var _state_seleted : GraphNode

# si esta en el metadata se actualiza al cargar los datos
# esto es utilizado para asignar los nombres a los estados
# de manera interna, para facilitar las conexiones
var _state_count : int

# Called when the node enters the scene tree for the first time.
func _ready():
	NodeState = preload(
		"res://addons/object_state_machine/support_editor_godot_v4/graph_node_state.tscn")

	ButtonNode = preload(
		"res://addons/object_state_machine/support_editor_godot_v4/button_node.tscn")

	# si esta en el metadata se actualiza al cargar los datos
	# esto es utilizado para asignar los nombres a los estados
	# de manera interna, para facilitar las conexiones
	self._state_count = 0

	# habilita desconectar y reconectar los cables
	set_right_disconnects(true)

	_button_first_state    = ButtonNode.instantiate()
	_button_normal_state   = ButtonNode.instantiate()
	_button_last_state     = ButtonNode.instantiate()
	_button_new_metadata   = ButtonNode.instantiate()
	_button_save_metadata  = ButtonNode.instantiate()

	_button_first_state.text   = "First State"
	_button_normal_state.text  = "Normal State"
	_button_last_state.text    = "Last State"
	_button_new_metadata.text  = "New"
	_button_save_metadata.text = "Save"

	get_menu_hbox().add_child(_button_first_state)
	get_menu_hbox().add_child(_button_normal_state)
	get_menu_hbox().add_child(_button_last_state)
	get_menu_hbox().add_child(_button_new_metadata)
	get_menu_hbox().add_child(_button_save_metadata)

	_button_first_state.button_down.connect(_on_button_first_state)
	_button_normal_state.button_down.connect(_on_button_normal_state)
	_button_last_state.button_down.connect(_on_button_last_state)

	_button_new_metadata.button_down.connect(_on_button_new)
	_button_save_metadata.button_down.connect(_on_button_save)

	node_selected.connect(_on_node_selected)
	popup_request.connect(_on_popup_request)
	connection_request.connect(_on_connection_request)
	disconnection_request.connect(_on_disconnection_request)
	delete_nodes_request.connect(_delete_nodes_request)

func _on_popup_request(_position : Vector2) -> void:
	var _inv_zoom : float = 1/zoom
	var _new_node : GraphNode
	_new_node = NodeState.instantiate()

	# Asignar id unido
	_new_node.set_name("state_{id}".format({"id": self._state_count}))
	self._state_count += 1

	# Se agrega a la visor teniendo en cuenta el scroll y la posicion del mouse
	_new_node.position_offset = ( _position +  scroll_offset )

	# se agrega un offset para centrar el nodo en el cursor
	_new_node.position_offset -= _new_node.size / 2

	# se escala la posicion con el valor del zoom
	_new_node.position_offset *= _inv_zoom
	_new_node.set_mode(_new_node.NORMAL)
	add_child(_new_node)

func _on_node_selected(node : Node) -> void:
	self._state_seleted = node

func _on_button_normal_state() -> void:
	if self._state_seleted and get_child_count() > 0:
		self._state_seleted.set_mode(self._state_seleted.NORMAL)

func _on_button_last_state() -> void:
	for node in get_children():
		if node.get_mode() == node.LAST:
			node.set_mode(node.NORMAL)

	if self._state_seleted and get_child_count() > 0:
		self._state_seleted.set_mode(self._state_seleted.LAST)

func _on_button_first_state() -> void:
	# solo asignamos un estado como principal
	for node in get_children():
		if node.get_mode() == node.FIRST:
			node.set_mode(node.NORMAL)

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

func _delete_nodes_request(nodes):
	self._state_seleted.delete_node()
	_on_button_save()

func _on_button_new() -> void:
	self._state_count = 0
	self.clear_graph()

func _on_button_save() -> void:
	_state_machine.set_meta("graph_ref_version",     1)
	_state_machine.set_meta("graph_ref_scroll",      scroll_offset)
	_state_machine.set_meta("graph_ref_zoom",        zoom)
	_state_machine.set_meta("graph_ref_state_count", _state_count)
	_state_machine.set_meta("graph_ref_connections", get_connection_list())

	var nodes_name   : Array
	var nodes_info   : Array
	var nodes_mode   : Array
	var nodes_offset : Array

	for node in get_children():
		if node.has_method("get_mode"):

			nodes_name.append(node.name)
			nodes_info.append(node.get_info())
			nodes_mode.append(node.get_mode())
			nodes_offset.append(node.position_offset)

	_state_machine.set_meta("graph_ref_nodes_name",   nodes_name)
	_state_machine.set_meta("graph_ref_nodes_info",   nodes_info)
	_state_machine.set_meta("graph_ref_nodes_mode",   nodes_mode)
	_state_machine.set_meta("graph_ref_nodes_offset", nodes_offset)

func clear_graph() -> void:
	clear_connections()
	for node in get_children():
		if node.has_method("get_mode"):
			remove_child(node)
			node.queue_free()

func load_graph() -> void:
	if not self._state_machine.has_meta("graph_ref_version"):
		return

	if self._state_machine.get_meta("graph_ref_version") != 1:
		return

	self.clear_graph()

	self._state_count = self._state_machine.get_meta("graph_ref_state_count")

	scroll_offset = self._state_machine.get_meta("graph_ref_scroll")
	zoom = self._state_machine.get_meta("graph_ref_zoom")

	var node_name   : Array
	var node_info   : Array
	var node_mode   : Array
	var node_offset : Array

	var ref_connections : Array
	ref_connections = self._state_machine.get_meta("graph_ref_connections")

	node_name   = self._state_machine.get_meta("graph_ref_nodes_name")
	node_info   = self._state_machine.get_meta("graph_ref_nodes_info")
	node_mode   = self._state_machine.get_meta("graph_ref_nodes_mode")
	node_offset = self._state_machine.get_meta("graph_ref_nodes_offset")

	for index in range(node_info.size()):
		var new_state : GraphNode
		new_state = NodeState.instantiate()
		new_state.position_offset = node_offset[index]
		new_state.set_name(node_name[index])
		new_state.set_info(node_info[index])
		new_state.set_mode(node_mode[index])
		add_child(new_state)

	for con in ref_connections:
		# validar que los nodos existan
		if con.from_node in node_name and con.to_node in node_name:
			connect_node(con.from_node, con.from_port, con.to_node, con.to_port)

func set_state_machine(state_machine : NodeStateMachine) -> void:
	self._state_machine = state_machine

	if not self._state_machine:
		return

	self.load_graph()

func get_state_machine() -> NodeStateMachine:
	return self._state_machine
