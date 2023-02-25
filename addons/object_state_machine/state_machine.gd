extends Object

class_name StateMachine

# señal que indica cuando se realiza un cambio de estado
signal transitioned(current : StateAbstract, next : StateAbstract)

var _name_state_machine : String

var _init_state    : StateAbstract
var _prev_state    : StateAbstract
var _current_state : StateAbstract
var _next_state    : StateAbstract

var _transition_debug : bool

func _init(name: String) -> void:
	self._name_state_machine = name
	self._transition_debug = false

# asigna el estado inicial para la maquina de estado
func set_init_state(state : StateAbstract) -> void:
	self._init_state    = state
	self._prev_state    = state
	self._current_state = state
	
	if not (
		self._current_state.has_method("is_class_state") && \
		self._current_state.is_class_state()):
		return
	
	self._init_state._enter()

# habilita información de debug via consola
func transition_debug_enable() -> void:
	self._transition_debug = true

# desabilita información de debug via consola
func transition_debug_disable() -> void:
	self._transition_debug = false

func _transition_debug_report() -> void:
	print("[ {sm} ] {prev_state} -> {next_state} ".format(
				{
					"sm":         self._name_state_machine,
					"prev_state": self._prev_state.get_name(),
					"next_state":  self._current_state.get_name()
				}))

func get_current_state() -> StateAbstract:
	return self._current_state
	
func get_prev_state() -> StateAbstract:
	return self._prev_state

# transicion entre estados
func transition_to(state: StateAbstract) -> void:
	
	if not (state.has_method("is_class_state") and state.is_class_state()):
		return
	
	if state == self._current_state:
		return
	
	emit_signal("transitioned", self._current_state, state)
	
	# cambia al nuevo estado
	self._next_state = state
	self._next_state._enter()
	
	# sale del estado anterior
	self._prev_state = _current_state
	self._prev_state._exit()
	
	# actualiza el estado actual
	self._current_state = _next_state
	
	if self._transition_debug:
		self._transition_debug_report()

func input(event: InputEvent) -> void:
	if not (
		self._current_state.has_method("is_class_state") && \
		self._current_state.is_class_state()):
		return

	self._current_state.input(event)

func process(delta : float) -> void:
	if not (
		self._current_state.has_method("is_class_state") && \
		self._current_state.is_class_state()):
		return
		
	self._current_state.process(delta)

func physics_process(delta : float) -> void:
	if not (
		self._current_state.has_method("is_class_state") && \
		self._current_state.is_class_state()):
		return
		
	self._current_state.physics_process(delta)

func integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not (
		self._current_state.has_method("is_class_state") && \
		self._current_state.is_class_state()):
		return
		
	self._current_state.integrate_forces(state)

# libera recursos
func free() -> void:
	super()
	
# metodos especiales, para detectar si es un estado o una maquina de estado
func is_class_state_machine() -> bool:
	return true

func is_class_state() -> bool:
	return false
