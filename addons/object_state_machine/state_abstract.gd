extends Object

class_name StateAbstract

# almacena el objeto que controlaremos en el estado
var _owner : Node
# almacena la maquina de estado
var _state_machine : Object
# almacena el nombre del estado
var _state_name : String

# virtual, se espera que se modifique desde el estado heredado
func _set_name() -> void:
	self._state_name = "Undefined"

func _init(owner : Node, state_machine : StateMachine) -> void:
	self._owner = owner
	self._state_machine = state_machine
	
	self._set_name()

# retorna el objeto a controlar desde el estado
func get_owner() -> Node:
	return self._owner

# permite cambiar de estado
func transition_to(state: StateAbstract) -> void:
	if not (state.has_method("is_class_state") && state.is_class_state()):
		return
	
	if self._state_machine.has_method("is_class_state_machine") && \
			self._state_machine.is_class_state_machine():
		self._state_machine.transition_to(state)

# devuelve el nombre del estado
func get_name() -> String:
	return self._state_name
	
func _enter() -> void:
	pass
	
func _exit() -> void:
	pass

func input(event: InputEvent) -> void:
	pass

func process(delta : float) -> void:
	pass

func physics_process(delta : float) -> void:
	pass

func integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	pass

# metodos especiales, para detectar si es un estado o una maquina de estado
func is_class_state_machine() -> bool:
	return false

func is_class_state() -> bool:
	return true
