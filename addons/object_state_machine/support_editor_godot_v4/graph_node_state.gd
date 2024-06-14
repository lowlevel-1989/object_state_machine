@tool
extends GraphNode

enum {FIRST, NORMAL, LAST}

var _mode_state : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# self.delete_request.connect(_on_delete_request)

func delete_node() -> void:
	# TODO: pasar por argumento GraphEdit y evitar utilizar get_parent
	# desconecta todas las conexiones del nodo que vamos a eliminar antes
	# de eliminarlo
	var connections : Array = get_parent().get_connection_list()

	# Limpio las conexiones porque de resto queda una linea colgando
	get_parent().clear_connections()

	# Eliminamos todos a los que nos conectamos
	for con in connections:
		if con.from_node == get_name():
			get_parent().disconnect_node(
				con.from_node, con.from_port, con.to_node, con.to_port)

	# Conectamos todos donde no estemos nosotros
	for con in connections:
		if get_name() in [con.from_node, con.to_node]:
			continue
		get_parent().connect_node(
				con.from_node, con.from_port, con.to_node, con.to_port)

	queue_free()

func set_mode(mode : int) -> void:
	self._mode_state = mode

	# Asignar mapa de colores por Array e indice
	match self._mode_state:
		FIRST:
			self_modulate = Color(0.6, 1, 0.5, 1)
		NORMAL:
			self_modulate = Color(1, 1, 1, 0.59)
		LAST:
			self_modulate = Color(0.8, 0.6, 1, 1)

func get_mode() -> int:
	return self._mode_state

func get_info() -> String:
	return $TextEdit.text

func set_info(info : String) -> void:
	$TextEdit.text = info
