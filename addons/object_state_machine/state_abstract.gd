extends Object

class_name StateAbstract

# almacena el objeto que controlaremos en el estado
var _owner : Node
# almacena la maquina de estado
var _state_machine : Object
# almacena el nombre del estado
var _state_name : String

# func create(owner : Node, state_machine : StateMachine) -> void:
# Se cambio a Object para soporte con Godot v3
func create(owner : Node, state_machine : Object) -> void:
	self._owner = owner
	self._state_machine = state_machine

	self._set_name()

# publica, retorna el objeto a controlar desde el estado
func get_owner() -> Node:
	return self._owner

# publica, permite cambiar de estado
func transition_to(state: StateAbstract) -> void:
	if not (state.has_method("is_class_state") && state.is_class_state()):
		return

	if self._state_machine.has_method("is_class_state_machine") && \
			self._state_machine.is_class_state_machine():
		self._state_machine.transition_to(state)

# publica, devuelve el nombre del estado
func get_name() -> String:
	return self._state_name

# virtual privada, se espera que se modifique desde el estado heredado
func _set_name() -> void:
	self._state_name = "Undefined"

# virtual privada, se espera que se modifique desde el estado heredado
# aqui se escribe la logica para aceptar una transicion
func _confirm_transition() -> void:
	pass

# virtual privada, se espera que se modifique desde el estado heredado
# es llamada desde la logica del stage machine
func _enter() -> void:
	pass

# virtual privada, se espera que se modifique desde el estado heredado
# es llamada desde la logica del stage machine
func _exit() -> void:
	pass

# virtual privada, pensada para implementar en alguno de estos metodos
# es llamada desde la logica del stage machine
# _unhandled_input(ev : InputEvent)
# _input(ev : InputEvent)
# _input_event(ev : InputEvent)
func _input(event: InputEvent) -> void:
	pass

# virtual privada, pensado para implementar la logica del metodo
# es llamada desde la logica del stage machine
# _process(delta : float)
func _process(delta : float) -> void:
	pass

# virtual privada, pensado para implementar la logica del metodo
# es llamada desde la logica del stage machine
# _physics_process(delta : float)
func _physics_process(delta : float) -> void:
	pass

# virtual privada, pensado para implementar la logica del metodo
# es llamada desde la logica del stage machine
# _integrate_forces(state)

# para godot v3 state es del tipo Physics2DDirectBodyState
# para godot v4 state es del tipo PhysicsDirectBodyState2D
# para evitar problemas entre versiones se cambia a Object
func _integrate_forces(state: Object) -> void:
	pass

# publica
# metodos especiales, para detectar si es un estado o una maquina de estado
func is_class_state_machine() -> bool:
	return false

# publica
# metodos especiales, para detectar si es un estado o una maquina de estado
func is_class_state() -> bool:
	return true
