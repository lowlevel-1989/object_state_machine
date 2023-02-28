extends Object

# señal que indica cuando se realiza un cambio de estado
# signal transitioned(current : StateAbstract, next : StateAbstract)
# se elimina el tipo, porque no lo soporta Godot v3
signal transitioned(current, next)

var _name_state_machine : String

var _init_state    : StateAbstract
var _prev_state    : StateAbstract
var _current_state : StateAbstract
var _next_state    : StateAbstract

var _transition_debug : bool

# metodo publico
# crea la maquina de estado
func create(name: String) -> void:
	self._name_state_machine = name
	self._transition_debug = false

# metodo publico
# asigna el estado inicial para la maquina de estado
# func set_init_state(state : StateAbstract) -> void:
# Se cambio a Object para soporte con Godot v3
func set_init_state(state : Object) -> void:
	self._init_state    = state
	self._prev_state    = state
	self._current_state = state

	if not (
		self._current_state.has_method("is_class_state") && \
			self._current_state.is_class_state()):
		return

	self._init_state._enter()

# metodo publico
# habilita información de debug via consola
func transition_debug_enable() -> void:
	self._transition_debug = true

# metodo publico
# desabilita información de debug via consola
func transition_debug_disable() -> void:
	self._transition_debug = false

# metodo privado
func _transition_debug_report() -> void:
	print("[ {sm} ] {prev_state} -> {next_state} ".format(
				{
					"sm":          self._name_state_machine,
					"prev_state":  self._prev_state.get_name(),
					"next_state":  self._current_state.get_name()
				}))

# metodo publico
# retorna el estado actual
# func get_current_state() -> StateAbstract:
# Valor de retorno modificado a Object para soporte con Godot v3
func get_current_state() -> Object:
	return self._current_state

# metodo publico
# retorna el metodo previo
# func get_prev_state() -> StateAbstract:
# Valor de retorno modificado a Object para soporte con Godot v3
func get_prev_state() -> Object:
	return self._prev_state

# metodo publico
# transicion entre estados
# func transition_to(state: StateAbstract) -> void:
# Valor de retorno modificado a Object para soporte con Godot v3
func transition_to(state: Object) -> void:

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

func confirm_transition() -> void:
	if not (
		self._current_state.has_method("is_class_state") && \
			self._current_state.is_class_state()):
		return

	self._current_state._confirm_transition()

# metodo publico, se espera que se utilice en estos metodos
# _unhandled_input(ev : InputEvent)
# _input(ev : InputEvent)
# _input_event(ev : InputEvent)
func input(event: InputEvent) -> void:
	if not (
		self._current_state.has_method("is_class_state") && \
			self._current_state.is_class_state()):
		return

	self._current_state.input(event)

# metodo publico, pensado para que se utilice en el metodo
# _process(delta : float)
func process(delta : float) -> void:
	if not (
		self._current_state.has_method("is_class_state") && \
			self._current_state.is_class_state()):
		return

	self._current_state._process(delta)

# metodo publico, pensado para que se utilice en el metodo
# _physics_process(delta : float)
func physics_process(delta : float) -> void:
	if not (
		self._current_state.has_method("is_class_state") && \
			self._current_state.is_class_state()):
		return

	self._current_state._physics_process(delta)

# metodo publico, pensado para que se utilice en el metodo
# _integrate_forces(state)

# para godot v3 state es del tipo Physics2DDirectBodyState
# para godot v4 state es del tipo PhysicsDirectBodyState2D
# para evitar problemas entre versiones se cambia a Object
func integrate_forces(state: Object) -> void:
	if not (
		self._current_state.has_method("is_class_state") && \
			self._current_state.is_class_state()):
		return

	self._current_state._integrate_forces(state)

# metodo publico
# metodos especiales, para detectar si es un estado o una maquina de estado
func is_class_state_machine() -> bool:
	return true

# metodo publico
# metodos especiales, para detectar si es un estado o una maquina de estado
func is_class_state() -> bool:
	return false
